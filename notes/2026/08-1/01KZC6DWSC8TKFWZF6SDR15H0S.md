---
id: 01KZC6DWSC8TKFWZF6SDR15H0S
created: 2026-08-06T18:47:33.42098Z
updated: 2026-08-07T17:58:14.365223Z
type: task
title: 'Breakglass slice 1: the window lifecycle — table, grant, request/arm/disarm/expire (ADR 0089)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 592
sprint: snk16ew
blocked_by:
- 01KZC6DBRBH9CXTSQ4CQNZGRFN
- 01KZDRMEHA2BYH83X980Q42YTT
assignee: steve
label: null
priority: medium
task_status: active
---
**Split 2026-08-07.** ADR 0089's full flow was a sprint's worth of work in one task ("split when planned" — it never was). This task now carries **slice 1 of 4**: the window itself. Follow-ups: **ISE-612** (auto-approval + tiers + guards), **ISE-613** (the record: timeline, Platform Log, Teams System event, statusline), **ISE-614** (the screen: pending-request modal + armed banner).

Slice 1 — the domain core. Headless by design; the screen is ISE-614.

- `breakglass_window` table + migration: user, incident, pinned MCP session, status, reason, duration, both clocks, `end_reason`. The row IS the record — never deleted, never rewritten.
- The **breakglass grant**: the string `breakglass` carried in a user's existing `roles`, ignored by the tier ladder (`role_level` confers nothing for unknown strings). Not a rung — a named capability granted out-of-band to people who already hold direct access to the underlying systems, which is the whole access-parity argument. No migration needed.
- **Request** (grant required, one live window per person per incident) → **arm** (requester only, reason required, 1–120 minutes) → **disarm**.
- All four end conditions: timer expiry, explicit disarm, incident resolved (ends *every* engineer's window on it), pinned session superseded. Expiry applied lazily on the next look, like the MCP session idle timeout.
- An audit row on every transition, including the two nobody performs (`expired`, `request_expired`) — the ends most likely to be missing from a trail otherwise.

Deliberately NOT in this slice: the `break_glass` MCP tool, the auto-approval hook, the tier/guard behaviour, the notifications, and the UI. Until ISE-612 lands, an armed window changes nothing — a T2 proposal still queues for a human exactly as before, which is the correct failure direction for a half-built security control.

Depends on: ISE-591 (Teams System event, released) and `propose_change` (released) — both consumed by the later slices.