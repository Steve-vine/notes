---
id: 01M0ZCEXRYPME2AW4T8B0QD4BK
created: 2026-08-26T15:54:14.686239Z
updated: 2026-08-28T18:21:47.040036Z
type: task
title: The AI domain gets written, and 42001 stops being a standard nobody answers
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 431
sprint: s31sysr
blocked_by:
- 01M0ZBVTZNM3VWHBCRPCYV1ZNB
- 01M0Z9E0XKTK6356G40449BC5T
comments:
- id: 01M13PK7FNK2PPSX26SZCTY7YM
  author: Steve Vine
  at: 2026-08-28T08:08:19.189861Z
  text: |-
    Done — PR #472, merged as 0b705a4, deployed to staging (Helm revision 112).

    **Sixteen controls in a 24th domain, AI Governance (AIG), closing the Govern function.**

    Started from COM-428's map, as the brief said to. ISO 42001 went from 0 fully covered / 59 partly / 6 not covered, to 58 / 7 / 0.

    The seven that stay partial are deliberate. 4.1, 4.2, 4.4, 7.1, 9.2, 9.3 and 10.1 ask about the management system itself — its context, its resources, its internal audit, its management review — and the existing ISMS controls answer those. An AI-flavoured duplicate of each is the mistake that produced 35 domains. For the same reason there is no "an AI policy exists" control: the policy lifecycle control already assesses a policy for owner, approval, review and communication, per policy, so A.2.2, A.2.3 and A.2.4 keep it. The test file asserts what the domain does *not* contain as much as what it does.

    What was genuinely new, and what the map said was missing:
    - an inventory of AI systems, including the ones a supplier switches on inside software you already own
    - an impact assessment distinct from a DPIA — what the system does to people, not whether personal data is lawful
    - human oversight: who can intervene before the outcome lands, and how someone contests it
    - data provenance and lawful basis for training; quality, representativeness and bias
    - the AI-specific supplier questions — training data claims, subprocessors, retention, model-change notice
    - drift and harmful output as incidents, on the same clock as any other

    Ordered as an argument: who answers for this, what we are trying to achieve, what we have, how staff may use it — before it reaches training data. Every control carries the three-part description. Annex B was read for "what good looks like" and not shipped.

    **Also mapped into ISO 27001 and NIST CSF** — twelve rows. Provenance is A.5.34 and ID.AM-07's question as much as 42001's; the AI inventory is the part of ID.AM-02 nobody keeps. Each sits alongside the existing answer, never instead of it.

    **The AI Policy** moves into AIG and ships authored against the controls. It was the last domainless policy of 36 and a published shell, and both were the same problem: nothing to write it against. It is the one policy the seed authors, and only ever over a placeholder — an edit made in Compass is never overwritten.

    **Held the line on both:** Annex C stays out (it is a risk catalogue, and it belongs to the risk register — worth its own task). Nothing claims the EU AI Act: no control mentions it, and the policy names it exactly once, to deny it. That last point is a small judgement call — I kept an explicit "42001 conformance is not AI Act compliance" sentence in the policy rather than staying silent, on the grounds that a denial is the stronger form of the rule. Easy to remove if you would rather it were not mentioned at all.

    **One thing worth knowing:** this needed a migration. The seed inserts the new domain but never touches an existing one, so AIG would have landed on top of Asset & Configuration Management and seventeen domains would have read one place early — silently, with nothing failing. Migration 0135 makes room. I verified it against a populated database migrated from main and seeded first: AIG lands at position 7, no duplicate ordering, and both an edited control description and an edited AI Policy body survived.

    The first staging deploy failed on a Helm download flake and was rerun; the second was clean.

    Ready for a UI smoke test — the Playbook's "Not assigned to a domain" list should now be empty, and AI Governance should appear last in Govern with sixteen controls.
assignee: steve
company:
- moneypenny
label:
- feature
priority: high
task_status: done
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
