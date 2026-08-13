---
id: 01KZY1EK6FNNBVQ3CQJN21SAET
created: 2026-08-13T17:06:53.263117Z
updated: 2026-08-13T18:03:57.775254Z
type: task
title: The timeline narrates a signal getting worse and says nothing when it gets better or goes blind
project: 01KX671DATY39VW6GWK3M2T3DN
number: 692
sprint: sevhjex
assignee: steve
label:
- improvement
priority: high
task_status: todo
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