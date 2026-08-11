---
id: 01KZP77MJZ1V21AJQCSGA3QRMQ
created: 2026-08-10T16:14:01.311976Z
updated: 2026-08-11T18:38:43.423757Z
type: task
title: The Service Desk rung can close an incident but cannot ask about it, be assigned it, or raise one
project: 01KX671DATY39VW6GWK3M2T3DN
number: 641
sprint: s1rgnyx
comments:
- id: 01KZRCQQ348JJA4R31B9MWBZYP
  author: Steve Vine
  at: 2026-08-11T12:28:39.908499Z
  text: |-
    PR #597, with an ADR 0056 amendment. All three moved to `responder`, and the amendment records why each was an accident rather than a boundary.

    **The line the amendment settles on**, which is what I think was actually being reached for originally:

    > The desk may act within what has been pre-approved, and may find out anything. It may not commission new AI work, or author a proposal someone else will have to carry.

    Reading, owning and reporting are triage. Commissioning is not. So diagnose / analyse / propose-remediation stay operator-only — they spend AI budget and produce proposals an engineer must carry — and the three that moved are the ones where the body's reasoning holds without qualification.

    Two details worth recording:

    - **A viewer still cannot do any of the three.** The rung moved by one, not away. The incident chat spends AI budget even though it changes nothing, so reading the queue is still not the same as questioning it.
    - **The UI follows the API rather than leading it.** The composer now renders for a responder, with the three AI buttons still gated on operator *inside* it — previously the whole panel was one operator gate, which is how the chat box came to be behind the same door as the diagnose button in the first place.

    **On the responder account: I have not created one, and I think that is right.** Creating an identity with access to production incidents is a decision about who is allowed in, not a code change, so it stays with you. The tests stand in for it by signing in as the rung — which, as far as I can tell, is the first time anything in this repo has done so. Until a real account exists, this amendment is reasoned but not smoke-tested, and I would rather say that than imply otherwise.

    The observation in the body is the one I would keep: **a role boundary nobody has ever stood on the wrong side of is an untested assumption, not a decision.** Every scenario test to date ran as admin, which is exactly why three accidental gates survived this long.
assignee: steve
label:
- improvement
priority: high
task_status: done
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