---
id: 01KZENN90F5Y13ECY1RS7WY7EV
created: 2026-08-07T17:52:12.815739Z
updated: 2026-08-07T21:49:30.269114Z
type: task
title: 'Breakglass slice 3: the record — timeline, Platform Log, Teams System event, statusline (ADR 0089)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 613
sprint: snk16ew
comments:
- id: 01KZF37J1HHVZT6G3MWJTQY53S
  author: Steve Vine
  at: 2026-08-07T21:49:23.376942Z
  text: |-
    Built — PR #534 (was #532; GitHub auto-closed that one when its stacked base branch was deleted on merging #531 — the standing "never --delete-branch a stacked chain" trap, hit again).

    Four surfaces, all of them deliverables rather than side effects — the legible trail is the whole justification for the mode, because going direct leaves none at all.

    - INCIDENT TIMELINE: merge-on-read over the audit rows the window already writes, exactly the treatment a change's transitions already get (entity_type breakglass_window, joined by the incident's window ids). No new table, nothing to keep in sync. The armed line carries the time box and the REASON, because the reason is the one thing the record cannot reconstruct afterwards.
    - PLATFORM LOG: one WARNING row per transition, request included, so an operator scrolling it sees the whole shape of an episode — asked, opened, closed — without knowing to query a table. Diagnosis in `extra`, never in the message.
    - TEAMS: a system_event card on arm AND on end (ISE-591's type, breakglass its first producer). NOT on request — half of all requests are never armed, and a notice people learn to skim is worse than fewer notices. Every ending names itself: the timer ran out / disarmed / the incident was resolved / the Claude session moved on. Two of the five are nobody's doing, which is exactly why "ended" alone will not do.
    - STATUSLINE: GET /mcp/session carries breakglass {armed, remaining_minutes, reason}, minutes rounded UP, and the script leads with 🔓 BREAKGLASS <n>m. The terminal is where the engineer actually is.

    The key is always present and never omitted — a shell script that has never seen a window reads a missing key and a false one identically, and only one of them keeps reading that way once somebody arms one. That is also what the one CI red was: test_mcp_client_kit asserts the snapshot's whole dict (deliberately), and its failure stranded an open MCP session, which failed the transcript-hook test alongside it. Two reds, one cause; fixed in c1d3d4c.

    No post-hoc review queue, per the 2026-08-06 decision — the stamps, the timeline block and the Teams events ARE the record.

    11 new integration tests + 2 vitest; ADR 0089's Implementation status updated.
assignee: steve
label: null
priority: medium
task_status: review
---
Slice 3 of 4 of the breakglass build (split from ISE-592, which carries slice 1).

**The audit trail is the product.** The legible trail is what going-direct can never provide — it is the whole justification for the mode existing, so it is a deliverable and not a side effect.

- **Incident timeline event** on every armed/disarmed/expired transition, so the incident's own story shows the window opening and closing in line with everything else.
- **Platform Log** entry on each transition (remember: a `logger.warning` is a user-visible screen row — put diagnosis in `extra`).
- **Teams System event** notification on arm AND on end, so the channel shows the window closed, not just opened. ISE-591 built the System event type; breakglass is its first producer.
- **`GET /mcp/session`** carries the armed state and remaining minutes, so the Claude Code statusline sidecar shows it in the terminal.
- No mandatory post-hoc review (Steve, 2026-08-06): the stamps, the timeline block and the Teams events ARE the record. A review queue would add ceremony the access-parity argument says nobody will honour.

`breakglass.remaining_seconds()` already exists from slice 1 for the statusline and the banner.

Depends on ISE-592 (slice 1). Independent of slice 2.