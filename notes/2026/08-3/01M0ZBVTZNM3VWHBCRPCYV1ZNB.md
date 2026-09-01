---
id: 01M0ZBVTZNM3VWHBCRPCYV1ZNB
created: 2026-08-26T15:43:49.237402Z
updated: 2026-09-01T13:55:53.324918Z
type: task
title: ISO 42001 joins as the eighth framework, and the AI Policy gets something to answer to
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 430
sprint: s8cjs5n
blocked_by:
- 01M0Z96KW5NKNYZM3G0HBSZ976
- 01M0Z96370R231D1A9PTH5CP5B
- 01M0Z992TBV07R7WE2XHZRBB19
comments:
- id: 01M10E8TGF670KGWJ7SAZWHY6A
  author: Steve Vine
  at: 2026-08-27T01:45:06.31916Z
  text: |-
    Done — PR #430.

    ISO/IEC 42001:2023 joins as the eighth framework — 65 assessable requirements: clauses 4–10 plus 38 Annex A controls under nine control objectives. The nine objectives are imported as grouping nodes rather than requirements, so they never appear in a denominator or sit permanently in the gap list, which is exactly the case the assessability flag was built for.

    It is an Annex SL standard, so its clauses sit in the same shape as ISO 27001's — which is why it lands now, while the machinery it needs is being built, rather than after.

    Flagging one thing for COM-431: six requirements are genuinely uncovered by the Core library and cannot be mapped without an AI domain — 6.1.4 (AI system impact assessment), 8.4 (impact assessment as an operational activity), A.5.5, A.6.1.2, A.7.4 and A.9.3. Those six are the input to that task. I have deliberately declared no 42001 requirement jointly complete: a framework whose subject matter the library does not yet cover should not report coverage it has not got.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Import ISO/IEC 42001:2023 — the AI management system standard — as an eighth
framework. **38 Annex A controls across nine objectives, plus clauses 4–10.**
Roughly 68 requirements.

The Artificial Intelligence Policy is the only one of the 36 policies with no
domain. `domain_id` is null, so it sits under no domain, counts toward no
coverage, and nothing flags it. It is published, so it looks fine. It is a
statement of intent nobody is measured against — which in a system built to
measure reality against the playbook is the one kind of document that cannot be
wrong.

This is the real fix: not a domain of AI controls, but a standard for the policy
to answer to.

## Why now rather than later

This sprint is building the exact machinery 42001 needs and nothing else needed:
framework versions, nested requirements, the ISMS-clauses-versus-Annex-A split,
applicability with exclusion justification, and relationship-typed mappings.
42001 is an Annex SL standard, so its clauses sit in the same shape as ISO
27001's. Retrofitting later means reopening all of it.

The crosswalk rebuild already works framework by framework as separate PRs, so
an eighth is one more PR against a control set that has stopped moving.

## What is deliberately not in scope

**The AI control domain.** Writing 15–20 Core controls to satisfy 42001 is the
expensive half, and none of the other seven frameworks need it.

Deferring it is safe now in a way it was not before: with relationship-typed
coverage, an imported framework you cannot fully satisfy is informative rather
than embarrassing. 42001 will show as partly covered, and the map will say
exactly how far the existing controls reach. Expect real partial cover already —
AI policy against the policy-lifecycle control, internal organisation against
roles and accountability, third-party relationships against the supply chain
controls, data for AI systems against classification and privacy, impact
assessment against DPIAs.

So the sprint ends knowing which of the 38 are genuinely uncovered, and the
decision about an AI domain gets made from a map instead of a guess. Raise it as
a follow-up task with a number attached.

## Near-term cover, separately

Whatever is decided about the domain, the actual exposure today is staff pasting
company or client data into chatbots and nobody having assessed the vendor. Two
or three controls in domains that already exist cover it, and they belong with
the new-control tasks rather than here: acceptable use of AI tools (Security
Awareness or Governance), company and personal data entering third-party models
(Information Classification), AI services assessed like any other supplier
(Supply Chain).

## Implementation

- Nine Annex A objectives, `A.2`–`A.10`: policies related to AI · internal
  organisation · resources for AI systems · assessing impacts of AI systems · AI
  system life cycle · data for AI systems · information for interested parties ·
  use of AI systems · third-party and customer relationships.
- Clauses 4–10 imported at sub-clause level, using the same `part` split that
  separates the ISMS from Annex A on ISO 27001. Same pattern, second caller —
  which is the point of doing it now.
- Requirement text is copyrighted: refs and titles only, descriptions enriched
  in-app (ADR 0028).
- **Watch the clause duplication.** 27001 and 42001 have structurally identical
  clauses 4–10 scoped to different subjects. Most governance controls will map to
  both, but not all — "assessing impacts of AI systems on individuals and
  society" has no information-security equivalent. Map both without duplicating
  the controls, and without claiming an ISMS management review discharges an AIMS
  one. Say so in the mapping notes; this is exactly the case relationship types
  exist for.
- Clause 6.1.3 works like 27001's: you select controls by risk treatment and
  compare against Annex A rather than implementing all 38. So 42001 needs the
  per-company applicability and exclusion justification from COM-415, and its own
  Statement of Applicability. Check the SoA export handles two standards.

**On the EU AI Act.** 42001 is necessary but not sufficient — the AI-specific
harmonised standard is **prEN 18286**, still in the EU pipeline. 42001 is the
right foundation and re-baselining onto 18286 when it publishes is the sane path,
but nothing in Compass should let "42001" read as "AI Act compliant". Do not
claim the mapping.

Tests: coverage splits AIMS clauses from Annex A; the AI Policy resolves to a
framework; an SoA can be produced for 42001 independently of 27001.
