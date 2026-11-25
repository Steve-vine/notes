---
id: 01M8AETSYW70DYZVKYBHMSDCRR
created: 2026-11-25T22:57:12.668332Z
updated: 2026-11-25T23:36:55.810963Z
type: task
title: Send on behalf on a shared mailbox is held, shown and watched — like Full Access and Send As
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2173
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Split out of COM-850 (review of what the mirror holds). **On the chain** (migration + API). The second half — requesting, roles, carrying it out, recertification — follows in its own task.

ADR 0075 §5 left send on behalf on shared mailboxes out on purpose: it lives on the on-premises object for a synchronised mailbox, so Exchange would refuse to set it. Since then the lists work (ADR 0106) solved exactly that — Exchange for cloud objects, AD or an on-prem to-do for synchronised ones. Steve's call (25 Nov): send on behalf on shared mailboxes is **governed** like the other mailbox rights.

## What people see

- A **shared mailbox's page** lists a third right beside Full Access and Send As: **Send on behalf**, with who has it. A **person's popup ▸ Shared mailboxes** shows it too ("Accounts — Send on behalf").
- Read **hourly with the other mailbox rights** (fifty past the hour). For a cloud mailbox it comes from Exchange; for a mailbox synchronised from on-prem AD, from AD — the place that actually holds it.
- **Watched for unrequested changes.** Someone grants or removes send on behalf by hand, in the admin centre or in AD. The next read finds it: "Ada can now send on behalf of Accounts". It goes under *Needs validation* if a role gives mailbox rights on that mailbox, *For information* otherwise — the same rule as the other mailbox rights.
  - It sits under the existing **Shared mailboxes** line of *What Compass watches* (access granted / access removed), so switching that off stops it too.
- The first read after the deploy is a baseline and raises nothing.

## Notes (technical)

- **ADR:** a new ADR (next free number — 0181 if COM-902's 0180 lands first) superseding ADR 0075 §5: send on behalf is in, read from Exchange for cloud mailboxes and from AD `publicDelegates` for synchronised ones, and routed like list rights (ADR 0106).
- **Mirror:** add `send_on_behalf` to the `shared_mailbox_access` kind. Cloud: `exchange_scripts/list_shared_mailboxes.ps1` returns `GrantSendOnBehalfTo` (resolve the entries to Compass keys, the way `list_list_senders.ps1` results are resolved). Synchronised (`is_dir_synced`): read `publicDelegates` through `core/ad_reader.py`, as the list senders do. Where AD isn't connected, say "not read — needs the AD connection" rather than showing none.
- **Detection:** diff in the mailbox pass like the existing mailbox-access kinds; add the new discriminator to `_pending_item_exists` in `tasks/directory_sync.py` or two findings collapse into one. Respect the ADR 0082 switch.
- Polaris's shared-mailbox read tools should include the new right.

**Done when:** on staging, send on behalf granted by hand on a cloud test shared mailbox shows on the mailbox page and in the person's popup after the next hourly read, and shows as an unrequested change. Switching **Shared mailboxes ▸ access granted** off stops the next one.