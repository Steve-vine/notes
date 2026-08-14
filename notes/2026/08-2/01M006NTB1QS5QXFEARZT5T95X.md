---
id: 01M006NTB1QS5QXFEARZT5T95X
created: 2026-08-14T13:16:41.697643Z
updated: 2026-08-14T15:15:34.608309Z
type: task
title: Escalation becomes an executable route — and the routes already exist
project: 01KX671DATY39VW6GWK3M2T3DN
number: 713
sprint: sevhjex
assignee: steve
label:
- feature
priority: medium
task_status: active
tech: null
---
`Envelope.escalation` is `str = Field(min_length=10, max_length=2000)` — it describes what a human should do and nothing can act on it. For a human-triggered desk run that is fine: a person reads it. For an autonomous run it is the entire failure path, and it does nothing.

**NOT blocked on the on-call work.** An earlier draft of this task said escalation needed ISE-545..549 first. That assumed a phone call is the only escalation, which is wrong — most incidents do not warrant waking someone at 3am. Verified on `origin/main`, two routes exist and work today:

- **FreshService `create_ticket`** — a real **T1 action in the catalogue** (ISE-442, `freshservice.py:646`), additive by design. Because it is a catalogue action it already passes through the same publish-time validation `allowed_operations` uses.
- **Teams** — `NotificationChannel` (ADR 0067/0069) with `destination_kind` of `user`, `group_chat` or `assignee`. A DM, a team channel, or whoever the incident is assigned to.

**Email does not exist.** There is no SMTP path anywhere in the backend; every notification destination is Teams. If email is wanted as a route it is its own piece of work, not part of this.

**That reframes the field.** Escalation is not one path, it is a *route chosen to match urgency* — raise a ticket for something that can wait until morning, message the assignee for something that needs a person today, ring someone only when it genuinely cannot wait. The voice/on-call route (ISE-545..549) becomes one more option when it lands, not a prerequisite for any of this.

**Scope**
- Replace the prose field with a route: kind + target + the existing prose retained as the human-readable note that travels with it. Validated at publish time against the catalogue for action routes and against configured channels for notification routes.
- Support at least `create_ticket` and a Teams destination at first release; leave the shape open for a voice route later.
- The route must name **who** — a rota, a team, a person, a queue. An escalation that reaches nobody in particular is the same failure as no escalation.
- Fires on a failed validation *and* on an unreachable one (ISE-712 keeps both as FAIL); the note should distinguish them so the human is sent to the right place.
- Whatever the route, the incident must be left pickup-able cold: what ran, what it checked, what it found, what it expected. That is timeline work, same surface as ISE-692.
- Publish-time refusal if an autonomous playbook has no resolvable route — never ship one whose failure path is a no-op.

Depends on ISE-710.