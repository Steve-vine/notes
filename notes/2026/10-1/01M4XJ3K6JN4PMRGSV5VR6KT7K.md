---
id: 01M4XJ3K6JN4PMRGSV5VR6KT7K
created: 2026-10-14T15:57:13.298884Z
updated: 2026-10-14T16:53:52.067395Z
type: task
title: Compass reads who can send as and send on behalf of each list, and the list's page shows it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 953
sprint: s192kdq
blocked_by:
- 01M4XJ2HVWMSYMP10PMXPCQ30N
comments:
- id: 01M4XNB98VRP3B6EYPEAH4BQ50
  author: Steve Vine
  at: 2026-10-14T16:53:51.003342Z
  text: |-
    Done — PR #947, merged to main. Not on staging until all five are in review.

    What to look at: Access Control ▸ Groups ▸ open a distribution list or mail-enabled security group. The pop-up has a new **Senders** card at the bottom:
    - **Can send as** and **Can send on behalf**, each listing who holds that right.
    - "Last read at 14:05" under them. If the latest read failed, it says so, with Exchange's message.
    - If nobody holds either right: "Nobody can send as this list or on its behalf."
    - Before the first read, or with Exchange not connected, it says that, never "nobody".
    - A security group or Microsoft 365 group has no card.

    How it's read: a new hourly pass at ten past the hour, on its own schedule so a slow read can't delay the shared-mailbox pass. Send as is one tenant-wide read rather than one per list; send on behalf comes with the list of lists. Each pass records how long it took, so we'll know the cost on staging. I'll post that time here after the first staging read.

    Different from the task text:
    - The "why" on each sender (role / exception) arrived with COM-954, which is where Compass starts giving these rights. In this PR alone every row has no badge.
    - In AD only, send on behalf is read from AD with the rest of the directory. Send as shows "Not read in this setup", because in that setup it lives in AD's permissions, which Compass doesn't read.

    Technical: migration 0255 (list_senders, list_sender_sync_status), list_list_senders.ps1 (read-only), tasks/list_sender_sync.py, publicDelegates added to the AD group read. The PowerShell can't run in CI; I parse-checked it with pwsh 7.6.6. The staging pass is its first real run.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Part of the POC Tweaks sprint; follows the ADR (COM-952). Read-only: nothing here changes a list. It can go to staging on its own.

## What people see

- **A list's page** (Access Control ▸ Groups ▸ a distribution list or mail-enabled security group) gains a **Senders** card. It has two headings, **Can send as** and **Can send on behalf**, and each lists the people (or, rarely, groups) Exchange or AD says hold that right.
- Each row says **why** where Compass knows: the role that grants it, or *Exception* for one granted by a request. Until the roles task lands, every row reads *Not from a role*, which is true.
- **"Last read"** on the card, as on a shared mailbox's page, so a stale answer is visible as stale.
- A list with neither right granted to anyone says so in one line instead of showing an empty card.
- Security groups and Microsoft 365 groups have no Senders card.

## Notes (technical)

- **Mirror.** A new table beside `shared_mailbox_access`, keyed by (group id, trustee, kind), with `kind` one of `send_as` / `send_on_behalf`. Same doctrine as `mailbox_mirror`: current-state facts replaced each pass, global, not audited, trustee resolved to a `DirectoryUser` where possible. Keep the trustee-kind enum, or reuse `SharedMailboxPrincipalKind` if it fits. A new Postgres enum must be created explicitly before a column references it (`create_type=False`). Next migration is **0252**; the revision id must be ≤32 characters.
- **Cloud and synced lists: one Exchange script**, `list_list_senders.ps1` (read-only, JSON over stdin like its siblings):
  - `Get-DistributionGroup -ResultSize Unlimited` gives `GrantSendOnBehalfTo`, `ExternalDirectoryObjectId`, `RecipientTypeDetails` and `IsDirSynced` in one call. Room lists are filtered out here.
  - **Send as**: prefer one tenant-wide `Get-RecipientPermission -AccessRights SendAs -ResultSize Unlimited` filtered to the lists' identities, rather than ~1,400 per-list calls. **Measure it on staging.** The 270-mailbox read took ~4.5 min, and if this is far slower it needs its own schedule rather than riding the hourly mailbox pass.
  - Reuse `Resolve-CompassTrustee` from `list_shared_mailboxes.ps1` (move it to `_common.ps1` if needed).
- **AD.** Add `publicDelegates` to `ad_reader._GROUP_ATTRIBUTES`. In **AD only** it is the source of send on behalf. In **Hybrid**, Exchange's `GrantSendOnBehalfTo` already reflects it after sync, so read it from one place per setup and say which in a comment. Send as is not read from AD (no ACL parsing); in AD only the heading says *Not read in this setup*.
- **Schedule.** Prefer riding the hourly `mailbox_sync` pass (same session, same cost) if the measurement allows; otherwise give it its own beat entry. Beat crontabs are wall-clock.
- **API.** Extend the group detail response (or add `GET /directory/groups/{id}/senders`). Remember page tests' prefix stubs answer a new sub-route with the parent object: `asList()` the hook and stub the route. Regenerate `schema.d.ts`.
- **Tests.** The fake-pwsh seam (`EXCHANGE_PWSH_PATH`) for the script round-trip; the pass replacing rows; an unresolvable trustee; a room list excluded.

**Done when:** on staging, a list somebody has been given send as in the admin centre shows that person under **Can send as**; a list with send on behalf (including a synced one) shows them under **Can send on behalf**; and the read time for the whole tenant is recorded on this task.