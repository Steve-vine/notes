---
id: 01M1BKBQ5NMRRJVYXQ78C96TQE
created: 2026-08-31T09:45:42.837053Z
updated: 2026-08-31T09:45:52.975742Z
type: task
title: Agree the permission catalogue — the actual list of things a role can be allowed to do
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 550
sprint: sz42uhw
blocked_by:
- 01M1BKB5HFFGHC8082QJRQ80K9
assignee: steve
company: null
label:
- brief
priority: medium
task_status: backlog
---
The mechanism task makes roles data at today's granularity: thirteen coarse capabilities — read/write library, read/write company, read/write vendors, submit vendor request, assess vendors, read/write access, expedite access, govern privileged access, read portal. Ticking thirteen boxes is not the product; "Access Management → Create Business Role · Create Request · Approve Request · Approve Privileged Request" is. This task agrees that list.

Design work, not typing. Every split is a decision about who may do what, and once a permission is in the API contract, renaming it is awkward — so the list is worth getting right before it is built.

**What comes out of it** — a written catalogue in `brief/`, grouped the way the screen will group it (Library, Company, Vendors, Access Management, Administration), each permission named in the words on the screen rather than after an endpoint, with a one-line statement of what it lets someone do and what it does not.

**The questions to settle**
- Where read splits from write, and whether read is ever worth its own tick or is implied by any write in that group.
- Which existing coarse capability is genuinely several things. *Write access* is at least: raise a request, approve one, edit at the gate, cancel someone else's, create and map business roles, accept a coverage proposal. Those are different jobs and today they are one box.
- Which permissions are dangerous enough to name loudly — approving privilege, break-glass, deleting a directory account (see the leaver task), editing role definitions themselves.
- Which of today's roles survive as built-in definitions, and what a sensible starter set looks like: an Access Manager and a Vendor Manager that mean comparable things, rather than one existing because a module needed it.
- What the portal-only roles become. They are an isolation boundary, not a permission bundle — someone holding only portal roles must never reach the internal app, and that should not depend on nobody ticking the wrong box.
- Whether permissions are company-scoped. Compass is multi-company; "can write company data" in one company is not the same grant as in another, and deciding this later would be expensive.

**Not permissions, and the catalogue should say so where they could be mistaken for one**: approver ≠ requester, a validator who cannot be the person who broke glass, an Access Admin's name on a privileged approval. Rules about a person and a record, enforced regardless of what any role permits.

Sequenced after the mechanism lands so there is somewhere to put the catalogue, but the design can be agreed at any point — and probably should be, since it shapes the admin screen.
