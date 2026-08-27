use serde::{Deserialize, Serialize};
use std::collections::{BTreeMap, BTreeSet};

const ATTESTATIONS: [&str; 3] = ["correctness_assurance", "architecture", "human_quality"];

#[derive(Debug, Deserialize)]
pub struct StrictProjection {
    pub rules: Vec<PolicyRule>,
}

#[derive(Debug, Deserialize)]
pub struct PolicyRule {
    pub id: String,
    pub maturity: String,
    pub enforcement: String,
    pub remediation: Remediation,
}

#[derive(Debug, Deserialize)]
pub struct Remediation {
    pub default_authority: String,
    #[serde(default)]
    pub action_overrides: Vec<ActionOverride>,
}

#[derive(Debug, Deserialize)]
pub struct ActionOverride {
    pub action: String,
    pub authority: String,
}

#[derive(Debug, Deserialize)]
pub struct AssessmentInput {
    pub unit_id: String,
    pub verdicts: Vec<RuleVerdict>,
    pub attestations: Vec<Attestation>,
    #[serde(default)]
    pub findings: Vec<Finding>,
    #[serde(default)]
    pub repair_plans: Vec<RepairPlan>,
    #[serde(default)]
    pub limitations: Vec<Limitation>,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct RuleVerdict {
    pub rule_id: String,
    pub verdict: String,
    pub inspected_surfaces: Vec<String>,
    pub evidence: Vec<String>,
    #[serde(default)]
    pub finding_ids: Vec<String>,
    #[serde(default)]
    pub limitation_keys: Vec<String>,
    #[serde(default)]
    pub applicability_evidence: Vec<String>,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct Attestation {
    pub dimension: String,
    pub inspected_surfaces: Vec<String>,
    pub evidence: Vec<String>,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct Finding {
    #[serde(rename = "finding_id")]
    pub id: String,
    pub rule_id: String,
    pub action: String,
    pub file: String,
    pub evidence: String,
    pub disposition: String,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct RepairPlan {
    pub plan_id: String,
    pub finding_ids: Vec<String>,
    pub owned_files: Vec<String>,
    pub preserved_behavior: Vec<String>,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct Limitation {
    pub key: String,
    pub kind: String,
    pub evidence: Vec<String>,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct Assessment {
    pub schema_version: String,
    pub unit_id: String,
    pub verdicts: Vec<RuleVerdict>,
    pub attestations: Vec<Attestation>,
    pub findings: Vec<Finding>,
    pub repair_plans: Vec<RepairPlan>,
    pub limitations: Vec<Limitation>,
}

/// Validates a complete unit assessment against the strict projection.
///
/// # Errors
///
/// Returns an error for missing or duplicate normative verdicts, contradictory
/// links, empty attestations, invalid repair authority, or orphan records.
pub fn validate_assessment(
    projection: &StrictProjection,
    input: AssessmentInput,
) -> Result<Assessment, String> {
    require_text(&input.unit_id, "ledger.unit_id_empty")?;
    let policies = normative_policies(projection)?;
    let findings = index_findings(&input.findings, &policies)?;
    let limitations = index_limitations(&input.limitations)?;
    let plans = index_plans(&input.repair_plans, &findings, &policies)?;
    validate_verdicts(&input.verdicts, &policies, &findings, &limitations)?;
    validate_attestations(&input.attestations)?;
    validate_record_links(&input.verdicts, &findings, &limitations, &plans)?;

    let mut assessment = Assessment {
        schema_version: "northstar.rust-quality.assessment.v1".to_owned(),
        unit_id: input.unit_id,
        verdicts: input.verdicts,
        attestations: input.attestations,
        findings: input.findings,
        repair_plans: input.repair_plans,
        limitations: input.limitations,
    };
    assessment
        .verdicts
        .sort_by(|left, right| left.rule_id.cmp(&right.rule_id));
    assessment
        .attestations
        .sort_by(|left, right| left.dimension.cmp(&right.dimension));
    assessment
        .findings
        .sort_by(|left, right| left.id.cmp(&right.id));
    assessment
        .repair_plans
        .sort_by(|left, right| left.plan_id.cmp(&right.plan_id));
    assessment
        .limitations
        .sort_by(|left, right| left.key.cmp(&right.key));
    Ok(assessment)
}

fn normative_policies(
    projection: &StrictProjection,
) -> Result<BTreeMap<String, &PolicyRule>, String> {
    let mut policies = BTreeMap::new();
    for rule in &projection.rules {
        if rule.maturity == "approved"
            && rule.enforcement != "evaluation_only"
            && policies.insert(rule.id.clone(), rule).is_some()
        {
            return Err(format!("ledger.policy_duplicate: {}", rule.id));
        }
    }
    if policies.is_empty() {
        return Err("ledger.policy_empty: strict projection has no normative rules".to_owned());
    }
    Ok(policies)
}

fn index_findings<'a>(
    records: &'a [Finding],
    policies: &BTreeMap<String, &PolicyRule>,
) -> Result<BTreeMap<String, &'a Finding>, String> {
    let mut findings = BTreeMap::new();
    for finding in records {
        require_text(&finding.id, "ledger.finding_id_empty")?;
        require_text(&finding.file, "ledger.finding_file_empty")?;
        require_text(&finding.evidence, "ledger.finding_evidence_empty")?;
        if !policies.contains_key(&finding.rule_id) {
            return Err(format!("ledger.finding_rule_invalid: {}", finding.rule_id));
        }
        if !matches!(
            finding.disposition.as_str(),
            "repair_planned" | "reported" | "deviation" | "operator_decision"
        ) {
            return Err(format!(
                "ledger.finding_disposition_invalid: {}",
                finding.id
            ));
        }
        if findings.insert(finding.id.clone(), finding).is_some() {
            return Err(format!("ledger.finding_duplicate: {}", finding.id));
        }
    }
    Ok(findings)
}

fn index_limitations(records: &[Limitation]) -> Result<BTreeMap<String, &Limitation>, String> {
    let mut limitations = BTreeMap::new();
    for limitation in records {
        require_text(&limitation.key, "ledger.limitation_key_empty")?;
        require_text(&limitation.kind, "ledger.limitation_kind_empty")?;
        require_nonempty(&limitation.evidence, "ledger.limitation_evidence_empty")?;
        if limitations
            .insert(limitation.key.clone(), limitation)
            .is_some()
        {
            return Err(format!("ledger.limitation_duplicate: {}", limitation.key));
        }
    }
    Ok(limitations)
}

fn index_plans<'a>(
    records: &'a [RepairPlan],
    findings: &BTreeMap<String, &Finding>,
    policies: &BTreeMap<String, &PolicyRule>,
) -> Result<BTreeMap<String, &'a RepairPlan>, String> {
    let mut plans = BTreeMap::new();
    for plan in records {
        require_text(&plan.plan_id, "ledger.plan_id_empty")?;
        require_nonempty(&plan.finding_ids, "ledger.plan_findings_empty")?;
        require_nonempty(&plan.owned_files, "ledger.plan_files_empty")?;
        require_nonempty(&plan.preserved_behavior, "ledger.plan_behavior_empty")?;
        for finding_id in &plan.finding_ids {
            let finding = findings
                .get(finding_id)
                .ok_or_else(|| format!("ledger.plan_finding_unknown: {finding_id}"))?;
            if finding.disposition != "repair_planned" {
                return Err(format!("ledger.plan_finding_not_repairable: {finding_id}"));
            }
            let policy = policies
                .get(&finding.rule_id)
                .ok_or_else(|| format!("ledger.plan_rule_unknown: {}", finding.rule_id))?;
            if authority(policy, &finding.action) != "review_required" {
                return Err(format!("ledger.plan_authority_invalid: {finding_id}"));
            }
        }
        if plans.insert(plan.plan_id.clone(), plan).is_some() {
            return Err(format!("ledger.plan_duplicate: {}", plan.plan_id));
        }
    }
    Ok(plans)
}

fn validate_verdicts(
    verdicts: &[RuleVerdict],
    policies: &BTreeMap<String, &PolicyRule>,
    findings: &BTreeMap<String, &Finding>,
    limitations: &BTreeMap<String, &Limitation>,
) -> Result<(), String> {
    let mut seen = BTreeSet::new();
    for verdict in verdicts {
        if !policies.contains_key(&verdict.rule_id) {
            return Err(format!("ledger.verdict_rule_invalid: {}", verdict.rule_id));
        }
        if !seen.insert(verdict.rule_id.clone()) {
            return Err(format!("ledger.verdict_duplicate: {}", verdict.rule_id));
        }
        require_nonempty(&verdict.inspected_surfaces, "ledger.verdict_surfaces_empty")?;
        require_nonempty(&verdict.evidence, "ledger.verdict_evidence_empty")?;
        validate_verdict_links(verdict, findings, limitations)?;
    }
    let expected: BTreeSet<_> = policies.keys().cloned().collect();
    if seen != expected {
        let missing = expected
            .difference(&seen)
            .cloned()
            .collect::<Vec<_>>()
            .join(",");
        return Err(format!(
            "ledger.verdict_inventory_mismatch: missing {missing}"
        ));
    }
    Ok(())
}

fn validate_verdict_links(
    verdict: &RuleVerdict,
    findings: &BTreeMap<String, &Finding>,
    limitations: &BTreeMap<String, &Limitation>,
) -> Result<(), String> {
    match verdict.verdict.as_str() {
        "pass" => require_no_links(verdict),
        "finding" => {
            if verdict.finding_ids.is_empty()
                || !verdict.limitation_keys.is_empty()
                || !verdict.applicability_evidence.is_empty()
            {
                return Err(format!(
                    "ledger.finding_verdict_invalid: {}",
                    verdict.rule_id
                ));
            }
            for finding_id in &verdict.finding_ids {
                let finding = findings
                    .get(finding_id)
                    .ok_or_else(|| format!("ledger.verdict_finding_unknown: {finding_id}"))?;
                if finding.rule_id != verdict.rule_id {
                    return Err(format!(
                        "ledger.verdict_finding_rule_mismatch: {finding_id}"
                    ));
                }
            }
            Ok(())
        }
        "not_applicable" => {
            if verdict.applicability_evidence.is_empty()
                || !verdict.finding_ids.is_empty()
                || !verdict.limitation_keys.is_empty()
            {
                return Err(format!(
                    "ledger.not_applicable_invalid: {}",
                    verdict.rule_id
                ));
            }
            Ok(())
        }
        "degraded" => {
            if verdict.limitation_keys.is_empty()
                || !verdict.finding_ids.is_empty()
                || !verdict.applicability_evidence.is_empty()
            {
                return Err(format!("ledger.degraded_invalid: {}", verdict.rule_id));
            }
            for key in &verdict.limitation_keys {
                if !limitations.contains_key(key) {
                    return Err(format!("ledger.verdict_limitation_unknown: {key}"));
                }
            }
            Ok(())
        }
        _ => Err(format!("ledger.verdict_invalid: {}", verdict.verdict)),
    }
}

fn validate_attestations(attestations: &[Attestation]) -> Result<(), String> {
    let mut seen = BTreeSet::new();
    for attestation in attestations {
        if !ATTESTATIONS.contains(&attestation.dimension.as_str()) {
            return Err(format!(
                "ledger.attestation_dimension_invalid: {}",
                attestation.dimension
            ));
        }
        if !seen.insert(attestation.dimension.as_str()) {
            return Err(format!(
                "ledger.attestation_duplicate: {}",
                attestation.dimension
            ));
        }
        require_nonempty(
            &attestation.inspected_surfaces,
            "ledger.attestation_surfaces_empty",
        )?;
        require_nonempty(&attestation.evidence, "ledger.attestation_evidence_empty")?;
    }
    let expected: BTreeSet<_> = ATTESTATIONS.into_iter().collect();
    if seen != expected {
        return Err(
            "ledger.attestation_inventory_mismatch: exactly three attestations required".to_owned(),
        );
    }
    Ok(())
}

fn validate_record_links(
    verdicts: &[RuleVerdict],
    findings: &BTreeMap<String, &Finding>,
    limitations: &BTreeMap<String, &Limitation>,
    plans: &BTreeMap<String, &RepairPlan>,
) -> Result<(), String> {
    let linked_finding_ids: Vec<_> = verdicts
        .iter()
        .flat_map(|verdict| verdict.finding_ids.iter())
        .collect();
    let linked_findings: BTreeSet<_> = linked_finding_ids.iter().copied().collect();
    if linked_finding_ids.len() != findings.len() || linked_findings.len() != findings.len() {
        return Err(
            "ledger.finding_orphan_or_duplicate: findings must be linked exactly once".to_owned(),
        );
    }
    let linked_limitation_keys: Vec<_> = verdicts
        .iter()
        .flat_map(|verdict| verdict.limitation_keys.iter())
        .collect();
    let linked_limitations: BTreeSet<_> = linked_limitation_keys.iter().copied().collect();
    if linked_limitation_keys.len() != limitations.len()
        || linked_limitations.len() != limitations.len()
    {
        return Err(
            "ledger.limitation_orphan_or_duplicate: limitations must be linked exactly once"
                .to_owned(),
        );
    }
    let planned_finding_ids: Vec<_> = plans
        .values()
        .flat_map(|plan| plan.finding_ids.iter())
        .collect();
    let planned_findings: BTreeSet<_> = planned_finding_ids.iter().copied().collect();
    let repair_findings: BTreeSet<_> = findings
        .values()
        .filter(|finding| finding.disposition == "repair_planned")
        .map(|finding| &finding.id)
        .collect();
    if planned_finding_ids.len() != repair_findings.len() || planned_findings != repair_findings {
        return Err(
            "ledger.plan_inventory_mismatch: every planned finding needs one plan".to_owned(),
        );
    }
    Ok(())
}

fn authority<'a>(policy: &'a PolicyRule, action: &str) -> &'a str {
    policy
        .remediation
        .action_overrides
        .iter()
        .find(|item| item.action == action)
        .map_or(policy.remediation.default_authority.as_str(), |item| {
            item.authority.as_str()
        })
}

fn require_no_links(verdict: &RuleVerdict) -> Result<(), String> {
    if verdict.finding_ids.is_empty()
        && verdict.limitation_keys.is_empty()
        && verdict.applicability_evidence.is_empty()
    {
        Ok(())
    } else {
        Err(format!("ledger.pass_has_links: {}", verdict.rule_id))
    }
}

fn require_text(value: &str, code: &str) -> Result<(), String> {
    if value.trim().is_empty() {
        Err(code.to_owned())
    } else {
        Ok(())
    }
}

fn require_nonempty(values: &[String], code: &str) -> Result<(), String> {
    if values.is_empty() || values.iter().any(|value| value.trim().is_empty()) {
        Err(code.to_owned())
    } else {
        Ok(())
    }
}
