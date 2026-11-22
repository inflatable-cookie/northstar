---
name: red-pen
description: Review a product or tool for overbuilding and recommend what to keep, simplify, or remove. Use when the operator asks which features earn their place, where a design is too complicated, or what they can cut.
---

# Red pen

Review the agreed scope by feature, option, or workflow. Split a feature when
its core behaviour and its extras deserve different verdicts.

For each item, identify who relies on it, what job it does, and what it costs
to use, operate, or maintain. Look for duplicate ways to do the same job and
flexibility built for needs that haven't materialised. Ground the review in
stated goals, actual workflows, and caller evidence. For libraries and other
reusable surfaces, no current callers alone is not grounds for Remove: unused
but specified or deliberately held surface is Keep unless it is wrong,
misleading, a duplicate or alias, constant by construction, or never
constructed. Check contracts, dependents, and any retained-surface register
before proposing a cut; do not cut a listed item unless its recorded evidence
has changed. Record operator-kept items in that register, or propose one if
the project has none.

- **Keep** when the item serves a current need and its complexity is justified.
- **Simplify** when a smaller design can serve the need. Name the behaviour
  to preserve and what would go.
- **Remove** when the item has no distinct job worth the cost. Name what
  would disappear and who would be affected.

Give one verdict per item with a short reason. Mark provisional verdicts
and say what would settle them. Lead with the changes that would save the
most effort or friction, and call out any migration or compatibility cost.
The default deliverable is a review. Make changes when the operator asks
for implementation.
