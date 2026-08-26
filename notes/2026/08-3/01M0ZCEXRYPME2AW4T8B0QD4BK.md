---
id: 01M0ZCEXRYPME2AW4T8B0QD4BK
created: 2026-08-26T15:54:14.686239Z
updated: 2026-08-26T15:54:46.676233Z
type: task
title: The AI domain gets written, and 42001 stops being a standard nobody answers
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 431
sprint: s31sysr
blocked_by:
- 01M0ZBVTZNM3VWHBCRPCYV1ZNB
- 01M0Z9E0XKTK6356G40449BC5T
assignee: steve
company:
- moneypenny
label:
- feature
priority: high
task_status: backlog
---
The fast-follow to COM-430. That task imports ISO/IEC 42001 and deliberately
leaves it partly covered; this one writes the Core controls that close it, as a
24th domain — **AI Governance `AIG`**, in the Govern function alongside People
Security.

Roughly 15–20 controls. The number is deliberately soft, because COM-428 decides
it: the crosswalk rebuild will have mapped all 38 Annex A controls and the AIMS
clauses against the existing library, so the real input to this task is a list of
what is genuinely uncovered rather than what looks new.

**Start by reading that list, not by writing controls.** Expect meaningful
partial cover already — AI policy against the policy-lifecycle control, internal
organisation against roles and accountability, third-party relationships against
the supply chain controls, data for AI systems against classification and
privacy, impact assessment against DPIAs. Writing an AI-flavoured duplicate of a
control that already exists is the failure mode here, and it is the same mistake
that produced 35 domains in the first place.

## What is likely to be genuinely new

Working list, to be cut against COM-428's output:

- An inventory of AI systems in use — built, bought and embedded in SaaS. This is
  the one nobody has, and everything else depends on it.
- AI impact assessment covering effects on individuals and society, distinct from
  a DPIA, which covers personal data only.
- Human oversight of automated decisions: who can intervene, on what, and how a
  decision is contested.
- Data provenance for training, tuning and inference — where it came from, what
  it may lawfully be used for, and how that is evidenced.
- Acceptable use of AI tools by staff, including what may and may not be put into
  a third-party model. *(The near-term controls deferred in COM-430 land here.)*
- AI-specific supplier assessment: model providers, their training data claims,
  their subprocessors, and what happens to the data you send them.
- AI incident handling — model failure, harmful output, drift — and how it joins
  the existing incident process rather than forking it.
- Transparency to affected people: when they are interacting with an AI system,
  and what information they are owed.
- Roles, competence and accountability for AI, where they exceed the general
  security equivalents.
- Life cycle controls: how an AI system is specified, validated before release,
  monitored in production, and retired.

## Also in this task

- **The AI Policy is re-pointed and re-authored.** It is a published shell today
  and the only domainless policy of 36 (see COM-423). It moves into `AIG` and is
  written against the controls, not the other way round.
- **Map `AIG` to 42001** and re-run coverage. Some of these controls will also
  carry ISO 27001 and NIST CSF requirements — data provenance and supplier
  assessment especially — so map across all eight frameworks, not just 42001.
- **Descriptions** in the three-part shape from COM-417. ISO 42001 Annex B is
  per-control implementation guidance and is the right reference for "what good
  looks like" — read it, do not ship it, it is copyrighted.

## Two things to hold the line on

**Do not claim the EU AI Act.** 42001 is a foundation, not sufficiency. The
AI-specific harmonised standard is **prEN 18286**, still in the EU pipeline.
Nothing in Compass should let a reader infer AI Act compliance from a 42001
score. If AI Act work is wanted, it is a separate framework import once 18286
publishes.

**Annex C is a risk catalogue, not a control set.** ISO 42001 Annex C lists
potential AI-related objectives and risk sources. It is genuinely useful, but it
belongs to the risk module (ADR 0012) as seed content for the risk register — not
here, and not as framework requirements. Worth raising as its own task if it
looks valuable once this lands.

Depends on COM-430 (the framework imported) and COM-428 (the map that says what
is actually missing).
