---
id: 01M34Y7PYDC14PWXMPYVM0YNB5
created: 2026-09-22T16:12:28.493282Z
updated: 2026-09-22T16:13:05.906898Z
type: task
title: A role can grant a shared mailbox — joiners, movers and leavers follow
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 739
sprint: s3nfes0
blocked_by:
- 01M34Y77T2T2XKFFJA1YRG7VN8
- 01M34Y8FRZ0ZBP1FQWE7BSQMQ8
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
A business role maps groups today. It can now also map a **shared mailbox**, with an access set: *can open*, *can send as*, or both — they are granted separately in practice, so they are modelled separately. "Sales Support gets the sales@ mailbox, open and send as."

**Joiners, movers and leavers follow.** Desired mailbox access is derived from the subject's roles exactly as group membership is; the execution task grants and removes it through the Exchange client from the connection task (FullAccess with automapping on; SendAs via recipient permission). New change kinds `mailbox_access_granted` / `mailbox_access_removed` join the per-subject trail; the mirror is updated at the write so the screen does not wait an hour. Why a person holds mailbox access is derived, not stamped (ADR 0063), and a role edit brings its holders in line (ADR 0064) — both apply to mailboxes without a second mechanism.

**The boundary is the same as for groups.** A mailbox is *managed* iff some active role maps it. Compass writes only to managed mailboxes; anything else it observes and leaves alone, and an attempt is refused and recorded as a per-subject outcome, never silently skipped. Re-checked at the write, not trusted from the approval (ADR 0045 §5).

**Screens.** The role editor gains a *Shared mailboxes* picker beside the groups one, with the two access toggles per mailbox; the request detail shows mailbox changes alongside group changes with the same outcome pills; the mailbox detail page names the roles that grant it.

Excluded on purpose: send-on-behalf (on-prem-owned when synced), creating or converting mailboxes, forwarding and auto-reply — later layers on the same connection.