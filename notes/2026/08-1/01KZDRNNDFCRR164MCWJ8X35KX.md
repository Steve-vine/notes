---
id: 01KZDRNNDFCRR164MCWJ8X35KX
created: 2026-08-07T09:25:36.815307Z
updated: 2026-08-13T19:00:03.002752Z
type: task
title: Assist message affordances — copy, regenerate, edit-and-resend
project: 01KX671DATY39VW6GWK3M2T3DN
number: 603
sprint: snk16ew
comments:
- id: 01KZEJN8PHJXMG5MVGFWAMXAAT
  author: Steve Vine
  at: 2026-08-07T16:59:46.769505Z
  text: |-
    Done — PR #527 (feature/ise-603-assist-message-affordances).

    THREE AFFORDANCES, ONE SERVER PRIMITIVE. Regenerate = "ask that again"; edit-and-resend = "ask a better version of that". Both mean the last exchange is SUPERSEDED, and both need the original question (the client no longer holds it after a reload) — so both go through DELETE /threads/{id}/exchanges/last, which removes the trailing Q+A pair and hands the question back.

    Decisions worth keeping:
    - THE REMOVAL IS SERVER-SIDE, BEFORE THE NEW TURN. The transcript is what the next turn's history is rebuilt from, so a superseded answer still in the database would be fed back to the model as CONTEXT FOR ITS OWN REPLACEMENT.
    - THE agent_run SURVIVES. The tokens were spent and the charge is real — spend and audit must not be editable by changing your mind about an answer. agent_run_id is a plain FK from message to run, so deleting the message leaves the run. Asserted by a test because it's the property that makes this safe.
    - 409 while streaming: an in-flight turn is writing to the row this would delete.
    - Regenerate/edit on the LAST answer only — reworking one with a conversation built on top would silently rewrite the middle of a transcript the operator has already read. Copy is offered on every message (it changes nothing).
    - Edit prefills the composer rather than re-asking: the point of editing is to say it DIFFERENTLY, and asking first spends on the question already judged wrong.
    - Copy renders Markdown WITH citations as a Sources list of real links. A copied answer that says "see checkout down" with no way to reach it has lost the half that made it trustworthy. An unresolved citation copies as plain text, matching how it renders (ISE-64).
    - ACTION ROW ALWAYS RENDERED, not hover-revealed. Hover-only is invisible on touch, unreachable by keyboard, undiscoverable to anyone who doesn't already know. Subtle icon buttons cost almost nothing visually and cost none of that.
    - Disabled across BOTH halves of a rework — between the delete and the new turn there's a moment with no stream to stop, and a second click would drop a second exchange.
    - Idempotency key was ALREADY a fresh UUID per send, so a regenerate is naturally a new turn rather than a 409'd retry. Now asserted rather than assumed.

    SAME TRAP AS ISE-604, hit again: created_at is server_default=now() = the TRANSACTION timestamp, and a question and its answer are written in ONE transaction, so they always tie. The walk back from newest must break ties answer-before-question or it meets the question first and removes HALF AN EXCHANGE. That was a real test failure, not a hypothetical.

    Tests: 4 backend + 5 frontend. Backend assist suite + ruff + mypy strict green; frontend 673/673 + tsc + eslint + prettier green.

    MERGE NOTE: ISE-601, ISE-603 and ISE-604 all touch AssistPage.tsx, and 603/604 both touch assist.py (both add a ties-broken ordering — unify on ISE-604's _turn_rank helper when merging). Run `npm run build` after resolving.
assignee: steve
label: null
priority: medium
task_status: done
tech: null
---
Per-message actions on the Assist conversation (shared chat primitives in components/chat.tsx — issue-chat inherits where it makes sense):

- **Copy** an assistant answer as markdown (one click, with citations rendered as links).
- **Regenerate** the last answer: re-runs the turn with the same question; the superseded answer is replaced, not duplicated (idempotency-key handling — a regenerate is a NEW turn, not a 409 retry).
- **Edit-and-resend** the last user question: prefills the composer, superseding the last exchange.
- Respect the streaming state machine (useAssistTurn) — affordances disabled mid-stream; Stop remains the only mid-stream action.

Screen: AssistPage message bubbles gain a quiet hover action row.