---
id: 01KZP772YXE4W1ZFC7VAAY3M78
created: 2026-08-10T16:13:43.261267Z
updated: 2026-08-10T16:14:23.79958Z
type: task
title: No playbook can become desk-executable — so the Service Desk path dead-ends on every incident
project: 01KX671DATY39VW6GWK3M2T3DN
number: 640
sprint: s1rgnyx
assignee: steve
label:
- bug
priority: high
task_status: backlog
---
Found 2026-08-10 walking the Service Desk triage path. `GuidedIncidentView` shows "No pre-approved response for this incident — escalate to a DevOps engineer" for **every incident in the estate**, and will continue to no matter what anyone authors. The empty state is honest; it is just the only reachable state.

`/desk-playbooks` (`issues.py:1051`) filters matches to `desk_state == "desk_executable"`. Staging has **zero** such playbooks, and three independent things stop one existing:

**1. Both playbooks have an empty body.** `body_len = 0` on both rows. `PlaybookCreate.body` defaults to `""` (`playbooks_api.py:90`), so a playbook saves happily with no procedure prose — and `publish_desk` then refuses it: *"no body — the interpreter needs the procedure prose"* (`playbooks.py:147`). Nothing at authoring time says the thing you just saved can never run. The monitor_alert one has no envelope either, which is the second refusal.

**2. The author cannot publish their own playbook.** `playbooks.py:138` — separation of duties, ADR 0056: the publisher must not be `created_by`. Both playbooks were authored by `Steve.Vine@moneypenny.co.uk`.

**3. There is no second engineer.** The estate has exactly two users: `Steve.Vine@moneypenny.co.uk` and `break-glass@local`. So gate 2 is not merely unsatisfied, it is **unsatisfiable** — no playbook authored in this deployment can ever be published, by anyone, ever.

Taken together: the desk's entire reason to exist (run a pre-approved response) is unreachable, and every path to fixing it is blocked by a rule that reads as sound in isolation.

**Scope**
- Authoring must state runnability: a playbook missing a body or a valid envelope should say "not publishable — needs X" on the playbook itself, at save, not at the publish click. Reuse the preflight failure-category discipline — name the missing precondition.
- The publish gate should fail *legibly on the playbook*, listing every unmet condition at once (body, envelope, second engineer) rather than one 409 at a time.
- Settle what happens when there is no second engineer. Options: break-glass as the publisher of record (auditable, arms a window), an explicit single-operator mode for a deployment this small, or accept it and make the message say "no other engineer exists to publish this" instead of a rule the reader cannot act on. **This is a decision, not a fix.**
- Related: the two advisory playbooks have `efficacy_total = 0`, so nothing is proven and `compute_tier` can never reach `rubber-stamp`. The advisory→published route wants to be a visible promotion path, not a separate authoring act.

**Acceptance**: an operator can get a playbook from authored to desk-executable in this deployment; a playbook that cannot be published says why on its own page; the Service Desk sees at least one runnable response on an incident it matches.