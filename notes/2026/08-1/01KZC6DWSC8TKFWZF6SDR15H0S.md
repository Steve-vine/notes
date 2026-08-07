---
id: 01KZC6DWSC8TKFWZF6SDR15H0S
created: 2026-08-06T18:47:33.42098Z
updated: 2026-08-07T17:59:31.568548Z
type: task
title: 'Breakglass slice 1: the window lifecycle — table, grant, request/arm/disarm/expire (ADR 0089)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 592
sprint: snk16ew
blocked_by:
- 01KZC6DBRBH9CXTSQ4CQNZGRFN
- 01KZDRMEHA2BYH83X980Q42YTT
comments:
- id: 01KZEP2GDTCRA80DZSM7FN79GJ
  author: Steve Vine
  at: 2026-08-07T17:59:26.39482Z
  text: |-
    SPLIT + slice 1 done — PR #528 (feature/ise-592-breakglass), migration 0106.

    The task said "likely a sprint's worth of slices — split when planned" and it never was. Split into four: ISE-592 (this, the window lifecycle), ISE-612 (auto-approval + tiers + guards), ISE-613 (the record), ISE-614 (the screen). Steve chose the split at the planning moment rather than at the end.

    STACKED ON PR #526 (ISE-601) — it holds migration 0105, and a migration branch must rebase-stack or the revision chain breaks. Hit this the hard way: the first test run failed with `KeyError: '0105'` because I'd numbered 0106 on a branch off main. Merge #526 first.

    Built:
    - `breakglass_window` (mig 0106). THE ROW IS THE RECORD — never deleted, never rewritten; reading this table is how "what happened during the outage" gets answered afterwards. `ix_breakglass_live` is partial on ended_at IS NULL and UNIQUE on (user, incident): it's both the lookup the approval path will do AND the database's own guarantee that one person can't hold two live windows on one incident. Worth having in the schema — the consequence of getting it wrong is an approval gate stuck open.
    - THE GRANT NEEDS NO MIGRATION: it's the string `breakglass` in a user's existing roles. rbac.role_level ignores unknown strings, which is exactly right — the grant is NOT a rung on viewer<...<admin. An admin doesn't get it by being an admin and nobody is promoted onto it; it's granted out-of-band to people who already hold direct access, which IS the access-parity argument.
    - Request → arm → disarm. Self-approval is deliberate: waiting for a second human is what the mode exists to avoid. The ceremony buys an interactive SSO'd session rather than a bearer token, a REASON written while the person still knows it, and a chosen duration. 120 min is a ceiling, not a default.
    - FOUR ways to end, deliberately outnumbering the one way to start: timer, disarm, incident resolved (EVERY engineer's window, not just the resolver's), session superseded.
    - Both clocks LAZY, on the next look, like the MCP session idle timeout — nothing consults a window except through active_window, and that's where the clock is read.
    - Audit row on every transition INCLUDING the two nobody performs (expired, request_expired) — the ends most likely to be missing from a trail otherwise.

    HEADLESS BY DESIGN, stated not assumed (DoD rule). No screen in this slice — it's ISE-614, and until it exists a window CANNOT BE ARMED IN THE APP AT ALL. That's the intended failure direction: nothing armable, rather than something armable without ceremony. Likewise until ISE-612 lands an armed window changes nothing — a T2 proposal still queues for a human exactly as before.

    ADR 0089 gains an Implementation status section and STAYS Proposed. An ADR saying Accepted while the guards it describes are unbuilt is worse than one saying nothing.

    Also hit: declaring `index=True` on the column AND a named sa.Index for the same column makes the models-vs-migration comparison fail on a duplicate index. Kept the auto-named one.

    Tests: 19 cases. Backend 735 unit + 21 migration + 19 breakglass, ruff, mypy strict green.
assignee: steve
label: null
priority: medium
task_status: review
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