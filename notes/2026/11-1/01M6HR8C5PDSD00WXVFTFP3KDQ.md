---
id: 01M6HR8C5PDSD00WXVFTFP3KDQ
created: 2026-11-03T22:25:11.86263Z
updated: 2026-11-04T07:45:49.690956Z
type: task
title: A Compass check, "Secrets are rotated on time" — fails while any registered secret is past its due date, listing them, and raises a gap on IDM.18 that closes when they're all rotated; being Long-lived never fails it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1568
sprint: sjrd5gz
blocked_by:
- 01M6HR7ZNGB841CC92QNPYP697
comments:
- id: 01M6J752A7W2G440CKEXK6N29X
  author: Steve Vine
  at: 2026-11-04T02:45:32.103229Z
  text: |-
    Done: PR #1582 merged.

    What's there:
    - **Posture ▸ Checks** has **"Secrets are rotated on time"**, under a new **Secrets** filter.
      - **Passing:** "All 23 secrets are within their rotation dates."
      - **Failing:** "3 secrets are past their rotation date". Each is listed as SEC-n · name, with its owner (or "No owner") and "N days past due", linked to the secret. Expired counts as past due.
    - **A failing check raises a gap on IDM.18**, marked *Raised by Compass check*. It closes itself when the check passes, and never changes the control's status.
    - **Threshold:** "Fail when a secret is this many days past due", 0 by default.
    - **Doesn't count:** long-lived on its own, needs a date, no schedule, retired secrets, and anything on Discovered nobody registered.
    - **No secrets registered** is *Can't tell*, not a pass.
    - **Polaris explains it:** "Rotate each secret listed, or record the rotation if it's already been done; if a secret isn't used any more, retire it."

    My calls:
    - **Can't tell instead of Off.** The task says the check is "off" with no secrets registered. I used *Can't tell* with the reason "No secrets registered", because that's how every check says it has nothing to judge; *Off* means someone switched it off.
    - **Like every check, a gap needs an assessment.** The gap goes on IDM.18 in a company that has assessed IDM.18 as applicable.

    To test on staging (after the sprint deploys), in E2E Test Company:
    1. With one secret overdue, Run now on the check: it fails and lists SEC-n, and a gap appears on IDM.18 (once IDM.18 is assessed there).
    2. Record the rotation and run again: it passes, and the gap closes.
    3. A long-lived secret that isn't due doesn't change the result.
- id: 01M6JPZFZS5VKHHY9657RDZ0E5
  author: Steve Vine
  at: 2026-11-04T07:22:06.712864Z
  text: |-
    **Pre-UAT: Passed** (staging, E2E Test Company).
    - The check "Secrets are rotated on time" was run with SEC-2 overdue. It **failed**: 1 of 3, "1 secret is past its rotation date", listing SEC-2 with its owner, on control IDM.18.
    - After SEC-2's rotation was recorded it **passed**: "All 3 secrets are within their rotation dates".
    - **Note for Steve:** the check's detail showed no gap raised (`gaps: []`). E2E Test Company has no assessment of IDM.18, which may be why. Worth a look on a company that has assessed it.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint "Secrets - New Module" (ADR 0141, COM-1563). Builds on COM-1567. It follows Continuous Control Checks (ADR 0132).

## What people see

- **Posture ▸ Checks** gains **"Secrets are rotated on time"**:
  - **Passing:** "All 23 secrets are within their rotation dates."
  - **Failing:** "3 secrets are past their rotation date". It lists each with SEC-N, owner and days overdue, linked to the secret. "Expired" counts as past due.
- **A failing check raises a gap** on **IDM.18** ("Machine and service identities are inventoried, owned by a named person, and rotated on a defined schedule"), marked *Raised by Compass check*. It closes itself when the check passes. Like every check, it never changes the control's status.
- **Threshold** (on screen, as other checks have): "Fail when a secret is [0] days past due".
- **What doesn't count:** Long-lived on its own, Needs a date, retired secrets, and unregistered Discovered entries.
- **Explain** (Polaris and the check's page) says what to do: "Rotate them, or record the rotation if it's already been done; if a secret isn't used any more, retire it."
- The check is **off** for a company that has no secrets registered, and says "No secrets registered" rather than passing.

## Notes (technical)

- A new check module `core/checks/secrets.py`, registered with the engine. It reads `core/secrets/due.py`. Look the control up by key `s42.IDM.3` (memory: control key vs ref).
- If a new Celery task or schedule is added, add its TASK_LABELS entry.
- The check catalogue's tests pin counts. Update them, and run `pytest -q -n 4` with no `-m` before pushing (memory: unit suite and tsc before push).

**Chain:** on the chain (API: a new check key).

**Done when:** on staging, in E2E Test Company:
- with one secret overdue, Run now fails the check and raises a gap on IDM.18 listing SEC-N;
- recording its rotation and running again passes, and the gap closes;
- a Long-lived secret that isn't due doesn't affect the result.