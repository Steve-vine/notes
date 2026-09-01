---
id: 01M1FEXDXNMYA0T52Z79H69PHH
created: 2026-09-01T21:44:58.03799Z
updated: 2026-09-01T21:45:33.94895Z
type: task
title: 'Retire the Obs Loop: observation detection returns to the Integrations'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 768
sprint: s7nj09w
assignee: steve
label:
- tech_debt
priority: medium
task_status: backlog
tech: null
---
Per ADR 0107, `obs_loop.py` dissolves rather than being renamed.

Its real job — `connector.detect_observations()` on a per-system cadence — is an outbound harvest, which makes it an ordinary Integration capability. Its cadence moves to the Conductor. The change-detection work its name implies moves to the Differ, which is new code.

**In scope:** move the detector call into the integration path; retire the bespoke dispatcher; migrate `System.obs_detection_enabled`, `obs_interval_seconds` and `last_obs_run_at`.

**Not in scope, and cannot be:** the 6,447 `obs_run` and 100 `obs_run_requested` audit rows keep their names — `audit_event` is append-only by trigger. ADR 0030 keeps its name too; it is amended, not rewritten.

**Watch:** the default cadence is 86,400s today *because* it dials out. That reasoning still applies to the harvest after the move — it is the Differ that runs per-minute, not this.

**Headless.** The only visible change should be that the Obs Loop stops appearing as a thing separate from its integration.

**Blocked by** the Conductor and the Differ.