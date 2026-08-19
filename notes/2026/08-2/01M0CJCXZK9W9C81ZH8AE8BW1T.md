---
id: 01M0CJCXZK9W9C81ZH8AE8BW1T
created: 2026-08-19T08:32:26.611772Z
updated: 2026-08-19T21:27:11.419594Z
type: task
title: Entra health card — a passing Test sits beside a stale stored verdict
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 271
sprint: s5gwx0s
comments:
- id: 01M0D94NC66VX0DTJT9BYJTBA7
  author: Steve Vine
  at: 2026-08-19T15:09:52.902491Z
  text: |-
    Merged to main in PR #272. All three gaps closed:

    - **Test persists its verdict** — `POST /integrations/entra/test` now writes `health`/`health_checked_at`/`health_message` on success *and* failure, via an actorless session exactly like the Beat check (entra_settings is audited; a test click must not spam the activity log — test asserts the row count is unchanged). Env-var-only configs (no row) unchanged.
    - **Card refetches after a test settles** — `onSettled` invalidates `['integrations-entra']`, so badge + stored alert + live test result always agree.
    - **Stored verdict is dated** — "as of HH:MM" renders next to the health badge and inside the error alert.

    So the exact smoke scenario (grant consented → Test passes → red banner persists) now self-heals on the first Test click.
assignee: steve
label:
- bug
priority: low
task_status: done
---
Smoke finding, Sprint 34 (2026-08-19). After granting the new `RoleManagement.Read.Directory` consent (COM-252), Steve clicked **Test connection** (passed, green) yet the card kept showing the red "Signed in, but missing admin consent for: RoleManagement.Read.Directory" alert — through a test *and* a resync. The error was real when written, stale when read.

Mechanism, three gaps stacking:

* The alert renders the **stored** health columns on `entra_settings`, written only by the Beat check (`tasks/entra_health.py`, every 300 s). **Test connection** runs the same `check_entra_connection` live but never writes the row — a passing test and a red banner co-exist with nothing saying the banner is old.
* **Sync now** touches the mirror status, not health — "I resynced" is a reasonable but wrong repair attempt.
* The card's query (`['integrations-entra']`) fetches on mount only; even after the Beat pass flips the row to ok, the screen shows the old verdict until a reload.

Fix (smallest coherent set):

* **The test endpoint persists its verdict.** `POST /integrations/entra/test` just performed the authoritative check — write `health` / `health_checked_at` / `health_message` to the row when one exists (env-var-only configs still have no row to carry it; unchanged). Test then doubles as the instant fix for a stale verdict.
* **The card refetches after a test settles** (success or failure) — invalidate `['integrations-entra']` in the test mutation, so badge + alert + test result always agree.
* **Show recency on the stored verdict**: `health_checked_at` is already in the payload — render "as of HH:MM" next to the health alert/badge so a stale banner reads as stale, not current.

Only the Entra card has stored health columns; the M365/SSO cards show live test results only, so this is Entra-scoped.

Refs: `tasks/entra_health.py`, `api/v1/integrations.py` (`test_entra`), `admin/IntegrationsSection.tsx` (`EntraForm`, `EntraHealthBadge`); COM-252 (the grant whose first sighting surfaced this), COM-245 (the sibling Test-button finding, same screen).