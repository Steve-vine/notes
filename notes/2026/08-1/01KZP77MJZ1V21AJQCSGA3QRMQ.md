---
id: 01KZP77MJZ1V21AJQCSGA3QRMQ
created: 2026-08-10T16:14:01.311976Z
updated: 2026-08-10T16:14:01.311976Z
type: task
title: The Service Desk rung can close an incident but cannot ask about it, be assigned it, or raise one
assignee: steve
task_status: backlog
label: improvement
priority: high
project: 01KX671DATY39VW6GWK3M2T3DN
number: 641
---
Found 2026-08-10 walking the Service Desk triage path. `responder` is the Service Desk rung (`rbac.py:5`, ADR 0056: "run desk-executable playbooks, resolve afterwards, record notes — nothing else"). Splitting the incident endpoints by the role they demand:

| Responder can | Operator only |
| --- | --- |
| merge / detach (`issues.py:631,672`) | **diagnose** (`:1107`) |
| run a desk-executable playbook (`:1077`) | **analyse** (`:1142`) |
| set status — resolve/dismiss (`:1260`) | **propose remediation** (`:1123`) |
| | **ask the incident chat** (`/conversation/turns`, `:1317`) |
| | **assign the incident** (`:1482`) |
| | **raise an incident by hand** (`:1161`) |

With no desk-executable playbooks in existence ([ISE-640]), the desk's working set is two verbs: **merge, and close**.

**Which of these are genuinely the ADR's boundary, and which are accidents.** Diagnose / analyse / propose-remediation spend AI budget and produce proposals an engineer must own — operator-only is defensible. The other three are harder to defend:

- **Asking the incident chat is read-only.** It reads estate state and answers; it changes nothing. Denying it to the desk means the person triaging cannot ask "what does this host do" or "has this happened before" — the two questions triage *is*. They must escalate to ask a question. (Assist-the-product settled this shape already: ask → viewer.)
- **Assignment.** The desk cannot take ownership of the incident it is working. `acknowledge_if_new` fires when they run a playbook (`issues.py:1094`), so ISE already records that they picked it up — it just cannot say the incident is theirs.
- **Raising an incident by hand.** The Service Desk is precisely who takes the phone call about a thing ISE has not noticed. Requiring an operator to raise it is a call-transfer. [ISE-632] already argues the manual incident should be first-class; this is who creates it.

**Also**: there is no responder account in the estate — the only users are `Steve.Vine@moneypenny.co.uk` (admin) and `break-glass@local`. All scenario testing to date has run as admin, so none of these gates were ever hit. **The desk experience has never actually been exercised as the desk.** A responder test account is a prerequisite for any of this being verifiable.

**Scope**: settle each of the three (chat, assignment, raise) as a deliberate decision — an ADR 0056 amendment if the boundary moves — and create a responder test account so the persona can be smoke-tested at all.

**Acceptance**: the desk persona can be signed in as; whatever the desk cannot do, it is denied for a reason someone chose, not for one nobody revisited.