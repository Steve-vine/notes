---
id: 01M6PVHPWFFN7J6MZ4GRE3D8XT
created: 2026-11-05T21:58:55.63115Z
updated: 2026-11-07T08:55:26.085719Z
type: task
title: Scheduled collection into Evidence — Compass runs each live collected check on its schedule (and on Collect now), reads every page from every account, and files the capture straight into the Evidence register as a readable page with the raw data; an unchanged result just moves "still true on"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1602
sprint: s1jcke1
blocked_by:
- 01M6PVH5WFJT1Q6W36FMM95112
comments:
- id: 01M6Q7114MFPGVQW6QDYH6PBET
  author: Steve Vine
  at: 2026-11-06T01:19:31.988846Z
  text: |-
    Done: PR #1618 merged. This one is on the chain: migration 0788.

    What's there:
    - **On schedule:** every hour Compass collects each live check whose time has come (daily, weekly or monthly), for live companies, with no AI involved.
    - **Collect now** on a check (needs Record assessments, at most once a minute) collects it straight away on the lane a person waits on.
    - **One run of a check at a time:** the schedule and Collect now can't overlap.
    - **What a run files:**
      - an unchanged answer files nothing new; the last capture's "still true on" moves to today;
      - a changed one files a new PDF page in the Evidence register on the control, replacing the last in its history, with the raw JSON kept beside it.
    - **Broken:** a read that fails keeps nothing. The check shows Broken with why, and what to do:
      - re-enter the key;
      - grant the permission named;
      - ask Polaris to re-create the check, or edit its read;
      - narrow the read;
      - nothing, it tries again at the next run.
    - **Each capture on the card** has **Page (PDF)**, through the register's own download, and **Raw data**, the JSON as kept (needs View audit). The card also says when the check is next collected.

    My call: the schedule runs at :41 past each hour, a minute no other hourly pass uses.

    Tested:
    - integration: Collect now once a minute; the schedule queues what's due; the raw data and the PDF download; Broken says what to do;
    - a real WeasyPrint render of the capture page (skipped where WeasyPrint isn't installed);
    - 1 Vitest.

    To check on staging: needs a live collected check (from COM-1601), which needs Polaris's AI provider or a check written by hand (Advanced).
- id: 01M6RBEMY98AAAE4TBVY6CWE88
  author: Steve Vine
  at: 2026-11-06T11:56:06.985319Z
  text: |-
    Pre-UAT, as E2E Admin A in E2E Test Company: Failed on Collect now (defect COM-1617, fixed). The scheduled and first-capture paths passed.

    Seen:
    - **First capture.** Filed into the Evidence register on approve: "Microsoft 365: 210 items, taken 6 Nov 2026, 10:56, still true on 6 Nov 2026", with Page (PDF) and Raw data.
    - **The PDF reads well.** 7 pages, headed with the control, account, what was asked, when, item count, what it shows, "Collected by Compass, approved by E2E Admin A on 2026-11-06. Fields left out: id, principalId", then the table.
    - **Collect now, nothing changed.** "filed 0, unchanged 1": no new file, and "still true on" moved.
    - **A changed answer.** After an account re-read, a changed capture replaced the old one; the audit pack index marks the old one "Replaced on 6 November 2026".
    - **A refused key.** It turned the check Broken with "E2E GitHub – RootCause-IT public: The service refused the sign-in (401). Check the key." Nothing was saved.

    Defects:
    - **COM-1617.** Collect now runs on a worker lane without the evidence storage. Its rule couldn't be judged, and a changed capture from Collect now would have gone to a throwaway disk.
    - **COM-1618.** The card didn't update after a capture until a reload.
    - **COM-1619.** After the reads changed, the old account's capture still showed on the card.

    Not seen: a run on its weekly schedule (the next is due 13 Nov). Re-test of Collect now to follow once the fixes are on staging.

    Screenshots and PDF: ~/compass-uat/s1jcke1/COM-1602/
- id: 01M6RCXR3RTRQPMKTRQWMZ1VYV
  author: Steve Vine
  at: 2026-11-06T12:21:50.328718Z
  text: |-
    Re-test after COM-1617, COM-1618 and COM-1619 (staging 63d195ce): Passed.
    - Collect now on ACC.13 filed a changed capture from the interactive lane ("filed 1"). It's in the register with its PDF.
    - The card showed it within 8 seconds, with no reload.
    - The card lists only the account the check reads now.

    Still not seen: a weekly scheduled run. The next is due 13 Nov.
assignee: steve
label:
- feature
priority: high
task_status: done
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