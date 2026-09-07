---
id: 01M1YM1TC1CAHJPTBGRPJBQXGG
created: 2026-09-07T19:03:21.21793Z
updated: 2026-09-07T20:04:26.298519Z
type: task
title: 'ADR: control tiers — Essential, Expected, Specialised'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 604
sprint: sqc2gdq
comments:
- id: 01M1YQHNHTA3G585495RC5ER5V
  author: Steve Vine
  at: 2026-09-07T20:04:26.298314Z
  text: |-
    Done — ADR 0069 "A tier orders work; applicability decides scope" merged to main in PR #613.

    It records: the three tiers and what each means; §1 tier orders work and never decides scope (Specialised means "not first", never "not for you" — that question belongs to applicability, ADR 0011 and 0057, and no per-company promotion); §2 stored not computed, with the rule kept as a re-runnable report that applies nothing; §3 required on every control including hand-made ones, and why that is consistent with ADR 0027; §4 the seeding rule, its provenance and the provisional counts, plus the human pass on the boundary; §5 no scoring changes, stated as a non-goal so a future "Essential gaps weigh double" has to supersede it.

    Append-only: a new record, nothing edited in 0011, 0018 or 0027.
assignee: steve
label:
- brief
priority: high
task_status: active
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