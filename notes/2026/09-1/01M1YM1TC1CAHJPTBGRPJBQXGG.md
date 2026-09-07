---
id: 01M1YM1TC1CAHJPTBGRPJBQXGG
created: 2026-09-07T19:03:21.21793Z
updated: 2026-09-07T19:30:41.723621Z
type: task
title: 'ADR: control tiers — Essential, Expected, Specialised'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 604
sprint: sqc2gdq
assignee: steve
label:
- brief
priority: high
task_status: todo
---
**The vocabulary question this task originally asked is settled.** It asked whether "Specialised" could honestly carry two meanings — *situational* (privacy, AI, card data: depends who you are) and *later* (passive discovery, separation of duties: applies to everyone, just not yet). It can't, and it no longer has to: the situational half belongs to **applicability**, which already exists. Tier means "not first" and nothing else. Three tiers, names as above, no per-company promotion.

What's left is writing it down, because this changes a standing model.

**What the ADR has to record**

- **Tier orders work; applicability decides scope.** The line between them is the whole point. Compass has had a per-company "does this apply to us" since ADR 0011 — `applicable` plus a required justification on the assessment — and ADR 0057 did the same for framework requirements. A tier that also meant "may not apply" would be a second mechanism for one question, and the two would disagree in front of an auditor. Specialised means "not first", never "not for you".
- **Tier is stored, part of a Core control's definition**, seeded by the mapping rule rather than derived from it. A computed tier would move under a company mid-assessment whenever someone edited a mapping or enabled a framework — a change nobody decided. Stored means it can drift from the mappings; the rule stays re-runnable as a report so the drift is visible.
- **Required on every control**, including ones analysts create in-app (ADR 0027), which have no mappings for a rule to read. The author picks.
- **Tier changes no scoring.** Not the rubrics (ADR 0018), not gap ranking, not risk. Filter, pill, and three Dashboard rings. Stating the non-goal matters — a field like this grows quietly once it exists.
- **The seeding rule and its provenance**, so a later reader knows the tiers came from Cyber Essentials, CIS IG1 and cross-framework consensus, not from someone's judgement of 383 controls.

**Note on ADR 0027.** That ADR made the Core library editable, governed data. A required, human-editable tier is consistent with it — worth saying so explicitly rather than leaving a reader to wonder whether the tier is content or derivation.

Append-only, as ever: this is a new ADR, not an edit to 0011, 0018 or 0027.