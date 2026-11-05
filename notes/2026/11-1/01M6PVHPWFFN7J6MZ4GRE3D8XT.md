---
id: 01M6PVHPWFFN7J6MZ4GRE3D8XT
created: 2026-11-05T21:58:55.63115Z
updated: 2026-11-05T21:58:55.63115Z
type: task
title: Scheduled collection into Evidence — Compass runs each live collected check on its schedule (and on Collect now), reads every page from every account, and files the capture straight into the Evidence register as a readable page with the raw data; an unchanged result just moves "still true on"
task_status: todo
assignee: steve
label: feature
priority: high
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1602
---
Sprint "Evidence Collection - Integrations" (ADR 0142, COM-1595). Builds on COM-1601. What happens when a capture's shape changes is the next task (COM-1603). Here every successful capture goes in.

## What people see

- **Live collected checks run on their schedule** (daily, weekly or monthly), with no AI involved. **Collect now** on the control's card runs one at once (needs Record assessments, at most once a minute).
- **Each capture goes straight into Audit ▸ Evidence** on its control, one per account:
  - a line "Collected by Compass: <check name> · <account>", evidence type *Configuration or screenshot*;
  - the period it covers (the capture's date) and Valid for from the type.
- **Opening a capture** shows a readable page:
  - a header: control, check, account, when it was taken, what was asked, "Collected by Compass, approved by <person> on <date>";
  - then the data as a table, with left-out fields absent.
  - **Download** gives the page as a PDF, and the raw data as JSON. It is what an auditor gets instead of a screenshot.
- **Nothing changed since last time?** No new file. The last capture's **"still true on"** date moves to today, so the register isn't flooded with copies and still proves the setting was checked.
- **A capture can't be edited**, only archived like other evidence. A newer capture **replaces** the previous one in the register (ADR 0122 lineage), so earlier ones stay in the history.
- **A read that fails** (sign-in refused, permission missing, throttled to the end, over the caps) saves nothing. The check shows as **Broken**, with the reason in words and what to do, on the control's card.

## Notes (technical)

- A Beat task (hourly) runs checks that are due. Per check and account: COM-1598 / COM-1596 read → drop left-out fields → canonical JSON → sha256. Equal to the last hash means bump `still_true_on`; otherwise store the JSON plus the rendered page (WeasyPrint as elsewhere, house style ADR 0110) and add the evidence line. New Celery tasks need TASK_LABELS entries.
- Evidence register: a new `RegisterSource` in `core/evidence_register.py`, kind `collected` (widening `EvidenceKind` ripples to frontend types: see the checks sprint memory). Or store as `Attachment(owner_type=evidence)` with lineage through `core/evidence_versions.py`. Pick whichever keeps audit packs (`core/audit_pack.py`, `current_during`) working unchanged.
- Idempotent per (check, account, run slot); advisory lock as `core/checks/engine.py` does.
- Collect now runs on the interactive queue.

**Chain:** on the chain (migration and API).

**Done when:** on staging, in E2E Test Company, the check approved in COM-1601:
- runs on schedule;
- Collect now with nothing changed adds no file but moves "still true on";
- after a policy change in the test tenant, Collect now adds a new capture that replaces the old one in the register;
- the PDF reads well;
- a revoked key turns the check Broken with the reason, and nothing is saved.