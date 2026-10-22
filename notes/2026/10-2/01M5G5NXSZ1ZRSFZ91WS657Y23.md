---
id: 01M5G5NXSZ1ZRSFZ91WS657Y23
created: 2026-10-21T21:25:36.703554Z
updated: 2026-10-22T21:38:23.250372Z
type: task
title: The threat catalogue — Admin ▸ Rubrics ▸ Threats, shipped with about 30 common threats (including fraud and the AI risk sources), each with what it threatens and the controls that usually address it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1223
sprint: s33gwqy
blocked_by:
- 01M5G5NMRZ0TGKD15E9N1DMB7X
comments:
- id: 01M5JRT0JQFJK9SE5MDZGCW0C0
  author: Steve Vine
  at: 2026-10-22T21:38:22.423499Z
  text: |-
    Done — merged in PR #1242 (migration 0510). Not yet on staging; the threats load on the next deploy.

    - Admin ▸ Rubrics has a new Threats card, the last on the page. It lists 30 threats written fresh for Compass, including the four fraud threats and the six AI risk sources.
    - Each threat shows its name, description, category, what it usually affects (Confidentiality / Integrity / Availability / Compliance / People) and the core controls that usually address it. Each control links to its page.
    - An admin can add a threat (name, category, description, what it affects, controls), edit any threat including its controls, and retire or restore one. A retired threat stays listed as Retired and can't be picked for a new assessment.
    - History on each threat shows every version, who saved it and when, and the controls it had then. Control link changes also appear in Activity.
    - The "Manage rubrics and levels" permission description now mentions threats.

    My calls:
    - A threat that came with Compass can be retired but never deleted, because each deploy puts back any missing default. A threat an admin added can be deleted until an assessment uses it; after that it can only be retired.
    - The list is sorted by category, then name, with no manual reordering.
    - Anyone signed in can see the threats; changing them needs "Manage rubrics and levels".
    - The deploy adds missing default threats but never touches admins' edits, control links or retirements. If an admin has already used a default's name for their own threat, the default is skipped rather than failing the deploy.

    To check: which controls each threat links to are my choices, 5–10 per threat. Payment or invoice fraud has no finance-specific control to point at, so it links segregation of duties, least privilege, vendor management, social-engineering awareness, DMARC and internal audit. Worth a look when you test.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 83, Risk Assessments (ADR in COM-1219).

**Chain:** on the chain — migration + API

## What people see

**Admin ▸ Rubrics ▸ Threats**, under *Manage rubrics*, versioned with "— history" like the other rubrics:
- Each threat: **name**, **category**, **description**, what it usually affects (**Confidentiality / Integrity / Availability / Compliance / People**), and the **core controls that usually address it**.
- Categories: Malicious outsider · Insider · Human error · Technical failure · Third party · Physical and environmental · **Fraud** · Legal and regulatory · **AI**.
- Add, edit, retire. A threat used in an assessment can be retired but not deleted.

**Shipped defaults (~30, written fresh for Compass):** e.g. ransomware; other malware; credential theft and account takeover; social engineering; exploited application or API; cloud or SaaS misconfiguration; denial of service; supplier outage or breach; admin error exposing data; data corruption or loss; backup or recovery failure; hardware failure; facility failure; theft or loss of equipment; malicious insider; workforce unavailability; natural hazard; regulatory breach and fines;
- **Fraud (SOC 2 CC3.3):** payment or invoice fraud; misuse of privileged access for gain; manipulation of records or reporting; IT-enabled fraud (e.g. BEC-led payment diversion).
- **AI (ISO 42001 Annex C risk sources, from the AI Risk Assessment Standard):** biased or unfair outputs; lack of transparency; unsafe or harmful outputs; data poisoning / model manipulation; loss of human oversight; misuse beyond intended purpose.

## Notes (technical)

- New rubric table + revisions, seed via importer (insert-missing-only; repair in importer, not migration, per seed practice).
- Controls stored by `CoreControl.key`, not ref.
- Do **not** copy Carbide's threat template text.

**Done when:** Rubrics shows a Threats tab with the defaults; an admin can add one, link controls, and retire one; history shows the edits.