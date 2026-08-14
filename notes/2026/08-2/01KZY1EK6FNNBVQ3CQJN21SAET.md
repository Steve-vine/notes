---
id: 01KZY1EK6FNNBVQ3CQJN21SAET
created: 2026-08-13T17:06:53.263117Z
updated: 2026-08-14T08:49:25.925657Z
type: task
title: The timeline narrates a signal getting worse and says nothing when it gets better or goes blind
project: 01KX671DATY39VW6GWK3M2T3DN
number: 692
sprint: sevhjex
comments:
- id: 01KZYGV7RQ2Y7H9ARTJ2WAR0HW
  author: Steve Vine
  at: 2026-08-13T21:35:56.18376Z
  text: |-
    2026-08-13 — DONE, PR #645 merged to main.

    **The early return that actually hid it was not the one the task named.** The task pointed at the severity guard (`if SEVERITY_RANK[effective] <= …: return False`). The real culprit is one line above it: `if not opens or finding.resolved_at is not None: return False`. A monitor going to No Data maps to `low`, which is **below the auto-open bar**, so `opens` is False and `_escalate` returned before the severity guard was ever reached. Hooking the narration at the severity guard — which is what I did first — produced nothing at all for IN-1278, the exact case the task was written from. It goes before the `opens` check.

    **What it deliberately does not do, and why:**

    - **Does not lower severity.** Upward-only stays (ADR 0040 §2). The title *does* refresh, with the same master exemption as the escalation path, and that is what stops an incident claiming a state its signal left.
    - **Does not notify.** An escalation is always news because the estate got worse; an easing is not something to page anyone about, and routing it to the same emitter would make recovery noisier than failure. A test asserts no `NotificationDelivery` row appears.
    - **Does not invent words for the state.** `promotion` is connector-agnostic and holds a severity, not a monitor state — "No Data" is a DataDog word, and reading it back out of a title would be sniffing one connector's string format from the layer above it. The finding's own current title travels on the event instead, so the timeline reads "now [Synthetics] Kora (UK) is No Data (low)" in the connector's words. **This is the honest answer to the task's "No Data needs its own words" — doing it properly at the ISE level would need connectors to carry the raw state as a field, which is a bigger change and its own task if you want it.**

    **Not alert-only**, unlike `_record_alert_lifecycle`. I first copied that guard and it silently skipped every test — triggered/recovered are alert concepts and an Observation has no lifecycle to narrate, but a change of *grade* is neither, and withholding it would have repeated this exact defect on a different signal type.

    **Flap guard** compares against the last recorded grade *and* the last recorded title, so a signal sitting quietly below its incident's grade writes one row, not one per sync — and a genuine second move is still news. Both halves are tested. Cost: one indexed audit lookup per live incident whose signal has fallen, which is a minority of incidents per sync.

    **Title decision:** refreshed downward, not marked stale. Doing neither is what produced IN-1224. Note this only helps where the signal's own text changed — IN-1224's finding title may still read "is Alert" after recovery, and that recovery is already narrated by `alert_recovered`.

    Verified: 4 new backend tests, all 31 in test_promotion.py green (including the pre-existing escalation ones), test_severity_thresholds / test_notification_emits / test_correlation_memory / test_azure_alerts green; 1 timeline-rendering test; ruff, mypy strict, prettier, eslint, build green; PR CI green (backend 10m18s).
assignee: steve
label:
- improvement
priority: high
task_status: done
tech: null
---
An incident records the worst the estate got and never mentions that the reading moved since. Two staging reports, one cause.

**IN-1278** — incident opened `high` on 10 Aug when a synthetic was in `Alert`; the monitor has since gone to `No Data` (`_STATE_SEVERITY`, `datadog.py:110`, maps No Data → `low`). The incident still shows `high` against a `low` signal, and nothing anywhere says the reading changed. Read as "an incident was opened for a low-severity signal".

**IN-1224** — signal recovered 11 Aug 06:51 and the incident's title still reads "High Disk Write IO **is Alert** on…". Read as "ISE ignored the all-clear", which it had not: `finding_status=recovered`, `resolved_at` set within two minutes.

**The asymmetry.** `_raise_severity` (`promotion.py:359`) escalates upward, writes an `incident_escalated` audit row, and refreshes the title so it carries the signal's current grade. Downward it returns at the guard — `if SEVERITY_RANK[effective] <= SEVERITY_RANK[target.severity]: return False` — silently. No audit row, no title refresh, no timeline entry. The incident's grade going up is news; the signal beneath it falling, or going blind, is not.

Holding severity upward-only is correct and stays (ADR 0040 §2: a monitor oscillating Warn↔Alert would swing the queue on every sync). But *recording the worst* and *never saying it changed* are two decisions, and only the first was made deliberately. The timeline is where the second belongs.

**Already present, do not rebuild:** `alert_triggered` / `alert_recovered` / `alert_retriggered` are audited (`promotion.py:427-437`) and already have timeline labels (`IssueTimeline.tsx:819-821`). IN-1278's timeline correctly shows triggered → recovered → re-triggered. The gap is everything that is not one of those three transitions.

**Scope**
- Narrate a signal's **severity/state change** on the incident timeline, in both directions. The downward path is the missing one; make it an event rather than an early return.
- **`No Data` needs its own words.** Mapping it to `low` makes "we have gone blind" render as "less urgent" — arguably backwards for a synthetic, where a check that stopped reporting may be a broken check, not a healthy service. The timeline entry should say the monitor stopped reporting, not that severity fell. (Whether the `No Data` → `low` mapping itself is right is a separate question — flagged, not assumed.)
- **Guard flapping.** A monitor oscillating would spam the timeline with one row per sync, which is the noise the signal/incident split exists to prevent. Collapse repeats within a window, or record transitions only when the state differs from the last recorded one.
- **Decide the title.** It refreshes on escalation only, so it states the worst grade ever seen, forever. Either refresh it downward too (respecting the ADR 0040 §4 master exemption — a master's title names the merged problem, not one child's alert), or mark it visibly stale. Doing neither is what produced IN-1224.
- Children record against their master (ISE-178, ADR 0035 §4), as the existing lifecycle events already do — reuse that path rather than a second one.

**Not a behaviour change to severity.** The incident's grade still records the worst the estate got. This makes the record legible, not different.

Related: ISE-691 (the Impact panel never names its subject) — same family. Twice today ISE held a correct answer and presented it in a form that read as a defect.