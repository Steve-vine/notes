---
id: 01M8EED1JWZH5K8NNQBTA6ZDGZ
created: 2026-11-27T12:06:39.452661Z
updated: 2026-11-27T14:50:46.293373Z
type: task
title: Compass makes every AD change its account has the rights for — anything AD refuses becomes an on-premises to-do, never a failed change
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2178
sprint: smq8t5s
comments:
- id: 01M8EQSGKXR6D4BY2140HVTRQT
  author: Steve Vine
  at: 2026-11-27T14:50:45.245858Z
  text: |-
    Built — PR #2189, merged to main as 47a08d4e9 (not yet on staging; goes with the sprint deploy). ADR 0182 added and marked Accepted on your principle in this task.

    What changed:
    - When Compass tries a change in AD and AD refuses it for lack of permission, it becomes an on-premises to-do, not a failed request: membership adds/removes, a leaver's disable (the rest of the leaver still runs, sessions still ended) and the later delete, account detail corrections, send on behalf, and recertification removals. The request carries on waiting on AD; the next AD read closes the to-do once it's done by hand.
    - After a refusal, that object's next change goes straight to a person without asking AD again, until the next rights check (which runs after each healthy AD connection check).
    - Every to-do says why it's manual, on the request, the review row, and in brackets on the Actions title: "Outside the OUs Compass manages", "Compass's account can't change groups in this OU" (or accounts / who sends on behalf of a list), "AD refused the change: insufficient access rights". In an install where Compass doesn't change AD at all, the request says "Compass doesn't change on-premises AD in this setup" but Actions titles leave it out (every to-do would say it).
    - The person and group popups say "AD refused Compass a change to it — changes are to-dos until the next rights check" when that's the case.
    - Unchanged: an unreachable domain controller still fails and is retried; a joiner Compass can't create still fails (COM-2185).

    To-dos raised before this have no reason and show none.

    For the Done-when on staging: needs a group in a ticked OU whose permission is narrowed on that group alone — if staging's AD has none, it can be checked with a protected group once COM-2179 is in (that reason reads "Protected by AD…" instead).
assignee: steve
label:
- feature
priority: medium
task_status: review
---
**On the chain** (likely a migration for the to-do's reason; API gains the reason). First of three, with COM-2179 (AD protection) and COM-2180 (built-in containers).

Steve's decision (27 Nov 2026): Compass should be able to change **every** account, group and container in AD. Whether it does is decided by the permissions an admin has given Compass's AD account, not by Compass. Where it can't, it raises a to-do for an admin, and the next AD read confirms it.

Today a change is only attempted where the object sits in a ticked OU and the rights check for that OU passed (ADR 0083). If AD then refuses, the request **fails**. That happens for objects AD protects (COM-2179), and wherever someone has narrowed a permission on one object below its OU.

## What people see
- **AD says no:** when Compass tries a change in AD and AD refuses it for lack of permission, the change becomes an **on-premises to-do** instead of failing the request. The request stays *Executing*, and the to-do appears in Actions as usual, closed by the next AD read.
- **Every to-do says why it's manual**, in one line, on the request, the review row and the Actions item:
  - "Outside the OUs Compass manages"
  - "Compass's account can't change groups in this OU"
  - "Protected by AD — Compass's account has no rights on protected objects" (COM-2179)
  - "AD refused the change: insufficient access rights"
- **Covers every kind of on-prem change:** membership adds and removes, leaver disable and delete, account detail changes, and send on behalf (lists and shared mailboxes), whether from a request, a mover or leaver, a recertification removal, or undoing an unrequested change.
- **Other failures stay failures:** an unreachable domain controller is retried, as today. Only "you may not" turns into a to-do.
- **Joiners are unchanged:** a joiner Compass can't create still fails. There's no "create this account by hand" to-do; that's a separate decision.

## Notes (technical)
- **ADR 0182**, amending ADR 0083 §3/§4. ADR 0083 routes on configuration, never health, and that stands. Add: a write AD refuses for lack of rights (LDAP insufficientAccessRights, 50) is re-routed to a manual step with its reason, and the object is remembered as `no_rights` until the next rights check. Reference Steve's principle above.
- **Reason on the step:** store `why_manual` (enum plus optional detail) on `access_manual_steps`. Fill it at every place a step is raised: `manual_steps.raise_membership_step`, account steps, list and mailbox right steps, `steps_now_managed_in_ad`, and recert steps.
- **Where the refusal is caught:** `ad_writer` calls run through `_ad_run` in `tasks/access_execute.py`. Catch the access-denied error there per write, raise the matching step, and don't fail the subject. Keep a refused write idempotent: a retried request mustn't raise the same step twice.
- **Shown in:** `manual_steps` titles and request detail; recert row text; the Actions item (COM-2177 rewords its title in the same place, so build on it if it has landed).

**Done when:** on staging:
- An AD membership change Compass's account isn't allowed to make (e.g. a group in a ticked OU whose permission is narrowed on that group alone) becomes a to-do with "AD refused the change: insufficient access rights", not a failed request.
- Doing it by hand closes it on the next AD read.