---
id: 01M006NTB1QS5QXFEARZT5T95X
created: 2026-08-14T13:16:41.697643Z
updated: 2026-08-14T13:16:41.697643Z
type: task
title: Escalation is 2000 characters of prose that nothing can execute
assignee: steve
priority: medium
task_status: backlog
label: feature
project: 01KX671DATY39VW6GWK3M2T3DN
number: 713
tech: null
---
`Envelope.escalation` is `str = Field(min_length=10, max_length=2000)` — it describes what a human should do and nothing can act on it. For a human-triggered desk run that is fine: a person reads it. For an autonomous run it is the entire failure path, and it does nothing.

Worse, **there is no escalation action to call.** Grepping the action catalogue finds none, and the Service Desk has never had a human-escalation action at all. The voice/on-call work that would provide one — ADRs 0079/0080, ISE-545..549 — is still Backlog. So "close or escalate" cannot be completed until something exists to escalate *to*.

**Scope**
- Turn `escalation` into a route: a named action plus its parameters, validated at publish time against the same catalogue `allowed_operations` is checked against, with the existing prose retained as the human-readable note that travels with it.
- The route must state **who** — a rota, a team, a channel — not just a verb. An escalation that reaches nobody in particular is the same failure as no escalation.
- Fires on a failed validation *and* on an unreachable one (ISE-712 keeps both as FAIL). The note should distinguish them so the human is sent to the right place.
- An autonomous run that escalates must leave the incident in a state a human can pick up cold: what ran, what it checked, what it found, what it expected. The timeline is where that lands (ISE-692's narration work is the same surface).
- If no escalation action exists yet, an autonomous playbook must not be publishable — publish-time validation should refuse it rather than shipping a playbook whose failure path is a no-op.

**Dependency, not a detail.** This is the one piece of ADR 0101 blocked on unbuilt work elsewhere. Either pull the minimum escalation action forward from ISE-545..549, or scope autonomy's first release to playbooks whose failure path is "leave the incident open and say why" — which is honest, and is a real option worth deciding rather than defaulting into.

Depends on ISE-710.