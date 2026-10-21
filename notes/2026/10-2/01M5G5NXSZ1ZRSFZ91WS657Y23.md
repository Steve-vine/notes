---
id: 01M5G5NXSZ1ZRSFZ91WS657Y23
created: 2026-10-21T21:25:36.703554Z
updated: 2026-10-21T21:29:27.114885Z
type: task
title: The threat catalogue — Admin ▸ Rubrics ▸ Threats, shipped with about 30 common threats (including fraud and the AI risk sources), each with what it threatens and the controls that usually address it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1223
sprint: s33gwqy
blocked_by:
- 01M5G5NMRZ0TGKD15E9N1DMB7X
assignee: steve
label:
- feature
priority: high
task_status: todo
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