/**
 * Advisory-only posture checks for Northstar-shaped `docs/` trees.
 * Always exits 0. Prints [northstar:advisory] lines for operators to triage.
 *
 * Optional: pass repo root as first arg or `--repo <path>` (Effigy-style).
 */
import { existsSync, readdirSync, readFileSync } from "node:fs";
import path from "node:path";
import { repoRootFrom } from "./lib/checks";

function parseRepoRootFromArgv(defaultRoot: string): string {
  const argv = process.argv.slice(2);
  for (let i = 0; i < argv.length; i++) {
    if (argv[i] === "--repo" && argv[i + 1]) {
      return path.resolve(argv[i + 1]!);
    }
  }
  if (argv[0] && !argv[0].startsWith("-")) {
    return path.resolve(argv[0]);
  }
  return defaultRoot;
}

function parseActiveGeneration(genIndexText: string): string | null {
  const sectionMatch = genIndexText.match(
    /## Active generation\s*\r?\n([\s\S]*?)(?=\r?\n## |\r?\n# |\s*$)/,
  );
  if (!sectionMatch) return null;
  const lineMatch = sectionMatch[1]!.match(/`?(g\d+)`?/);
  return lineMatch?.[1] ?? null;
}

function listTopLevelNumberedSpecs(specsDir: string): string[] {
  if (!existsSync(specsDir)) return [];
  return readdirSync(specsDir, { withFileTypes: true })
    .filter((e) => e.isFile() && /^\d{3}-.+\.md$/u.test(e.name))
    .map((e) => e.name);
}

function listBatchCardFiles(batchDir: string): string[] {
  if (!existsSync(batchDir)) return [];
  return readdirSync(batchDir, { withFileTypes: true })
    .filter((e) => e.isFile() && /^\d{3}-.+\.md$/u.test(e.name))
    .map((e) => e.name);
}

function main(): void {
  const defaultRoot = repoRootFrom(import.meta.dir);
  const repoRoot = parseRepoRootFromArgv(defaultRoot);
  const warnings: string[] = [];

  const genIndex = path.join(repoRoot, "docs/roadmaps/generation-index.md");
  if (existsSync(genIndex)) {
    const text = readFileSync(genIndex, "utf8");
    const gen = parseActiveGeneration(text);
    if (gen) {
      const genDir = path.join(repoRoot, "docs/roadmaps", gen);
      const genReadme = path.join(genDir, "README.md");
      if (!existsSync(genDir)) {
        warnings.push(
          `generation-index names active ${gen} but docs/roadmaps/${gen}/ is missing`,
        );
      } else if (!existsSync(genReadme)) {
        warnings.push(
          `generation ${gen} exists but docs/roadmaps/${gen}/README.md is missing (operators use it as a front door)`,
        );
      } else {
        const milestones = readdirSync(genDir, { withFileTypes: true }).filter(
          (e) => e.isFile() && /^\d{3}-.+\.md$/u.test(e.name),
        );
        if (milestones.length === 0) {
          warnings.push(
            `docs/roadmaps/${gen}/ has no NNN-<slug>.md milestone files while generation-index still names it active`,
          );
        }
      }

      const batchDir = path.join(genDir, "batch-cards");
      if (existsSync(batchDir)) {
        const cards = listBatchCardFiles(batchDir);
        if (cards.length === 0) {
          warnings.push(
            `docs/roadmaps/${gen}/batch-cards/ exists but has no NNN-<slug>.md cards (strict lanes normally keep ready cards here)`,
          );
        }
      }
    }
  }

  const specsDir = path.join(repoRoot, "docs/specs");
  const numbered = listTopLevelNumberedSpecs(specsDir);
  if (numbered.length > 0) {
    const archiveReadme = path.join(specsDir, "archive/README.md");
    if (!existsSync(archiveReadme)) {
      warnings.push(
        "docs/specs/ has numbered master specs but docs/specs/archive/README.md is missing (archive posture should be explicit for strict-style repos)",
      );
    }
  }

  if (warnings.length === 0) {
    console.log("Northstar posture advisory checks: OK (0 warnings)");
    return;
  }

  for (const w of warnings) {
    console.log(`[northstar:advisory] ${w}`);
  }
  console.log(
    `Northstar posture advisory checks: ${warnings.length} warning(s) (non-blocking)`,
  );
}

main();
