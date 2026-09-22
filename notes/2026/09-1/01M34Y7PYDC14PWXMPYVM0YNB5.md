---
id: 01M34Y7PYDC14PWXMPYVM0YNB5
created: 2026-09-22T16:12:28.493282Z
updated: 2026-09-22T22:12:53.444377Z
type: task
title: A role can grant a shared mailbox — joiners, movers and leavers follow
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 739
sprint: s3nfes0
blocked_by:
- 01M34Y77T2T2XKFFJA1YRG7VN8
- 01M34Y8FRZ0ZBP1FQWE7BSQMQ8
comments:
- id: 01M35JVN24E3ERJ3N5R6SA03T0
  author: Steve Vine
  at: 2026-09-22T22:12:53.444206Z
  text: |-
    Done — PR #751, merged to main. ADR 0076.

    A business role now grants shared mailboxes beside its groups — *can open* and *can send as*, each mapped separately because they are granted separately. A mailbox is managed iff some active role maps it, for either kind, and that is the whole of what Compass writes to Exchange: a leaver loses every managed grant they hold; a membership-change request may only name managed mailboxes, refused at raise time and re-checked at the write.

    Joiners, movers and leavers derive their mailbox grants from their roles exactly as their groups. All of a person's changes go to Exchange in one session, each reported on its own — what landed is recorded (mirror, reason, ledger) before what was refused fails the subject. A mover removes only what a lost role gave; an approved exception survives; an unexplained grant is left alone and said on the request. If Exchange is not configured the subject says "mailbox access not applied" rather than silently skipping.

    Why a person holds mailbox access is derived (role-derived / exception / unattributed), re-derived on the hourly pass and stamped at the write. A role edit brings its holders' mailboxes in line through the same one request as groups, with the preview showing "grants Sales (can send as) to 3 people" before the save.

    Screens: the role editor gains a **Shared mailboxes** picker (search, a button per kind, a pill per kind with its own revoke); the request page shows **Gaining / Losing mailbox access**; a mailbox's page shows **Granted by roles** (empty means observed, never written).

    Smoke test: Access Control ▸ Role matrix ▸ a role ▸ Shared mailboxes ▸ grant one kind; raise a joiner with that role and approve as someone else; check the person's modal and the mailbox's page; then a leaver. Needs the Exchange identity's role assignment in place (scripts/exchange/README.md).
assignee: steve
label:
- feature
priority: medium
task_status: review
---
A business role maps groups today. It can now also map a **shared mailbox**, with an access set: *can open*, *can send as*, or both — they are granted separately in practice, so they are modelled separately. "Sales Support gets the sales@ mailbox, open and send as."

**Joiners, movers and leavers follow.** Desired mailbox access is derived from the subject's roles exactly as group membership is; the execution task grants and removes it through the Exchange client from the connection task (FullAccess with automapping on; SendAs via recipient permission). New change kinds `mailbox_access_granted` / `mailbox_access_removed` join the per-subject trail; the mirror is updated at the write so the screen does not wait an hour. Why a person holds mailbox access is derived, not stamped (ADR 0063), and a role edit brings its holders in line (ADR 0064) — both apply to mailboxes without a second mechanism.

**The boundary is the same as for groups.** A mailbox is *managed* iff some active role maps it. Compass writes only to managed mailboxes; anything else it observes and leaves alone, and an attempt is refused and recorded as a per-subject outcome, never silently skipped. Re-checked at the write, not trusted from the approval (ADR 0045 §5).

**Screens.** The role editor gains a *Shared mailboxes* picker beside the groups one, with the two access toggles per mailbox; the request detail shows mailbox changes alongside group changes with the same outcome pills; the mailbox detail page names the roles that grant it.

Excluded on purpose: send-on-behalf (on-prem-owned when synced), creating or converting mailboxes, forwarding and auto-reply — later layers on the same connection.