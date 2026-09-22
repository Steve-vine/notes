---
id: 01M34Y8FRZ0ZBP1FQWE7BSQMQ8
created: 2026-09-22T16:12:53.919308Z
updated: 2026-09-22T21:44:19.168908Z
type: task
title: 'Shared mailboxes: who can open each one, and who can send as it'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 742
sprint: s3nfes0
blocked_by:
- 01M34Y77T2T2XKFFJA1YRG7VN8
comments:
- id: 01M35H7AZ0EQ6ZC1TEHF3SNZ5N
  author: Steve Vine
  at: 2026-09-22T21:44:19.16874Z
  text: |-
    Done — PR #750, merged to main.

    An hourly pass (at :50) lists every shared mailbox and who can open or send as it through one PowerShell process and writes it into a mirror in the directory-mirror idiom: keyed by the mailbox's Entra object id, a mailbox that leaves the tenant is marked rather than deleted, access rows are replaced each pass because they are current-state facts. Trustees are resolved to Entra object ids in the script; what Exchange cannot resolve (a deleted account's SID, say) is kept as the string Exchange reported and shown as such. Self, inherited and deny entries are dropped. Send-on-behalf is not mirrored.

    Screens: **Access Control ▸ Shared Mailboxes** — name, address, a Cloud / On-premises pill, the two counts, every row a link, sortable, with an honest empty state; a page per mailbox (`/access/shared-mailboxes/<id>`) with *Can open* and *Can send as* tables, a person or group opening its own modal; a **Shared mailboxes** section in the user modal (direct, or through a group they are in); and a **Shared mailboxes** panel on the Exchange card in Admin ▸ Integrations with the last pass and a *Read now* button.

    Nothing here writes to Exchange. Needs the Exchange connection from COM-738 configured before the list fills.

    Smoke test: Admin ▸ Integrations ▸ Exchange Online ▸ Read now, then Access Control ▸ Shared Mailboxes; open one; open a person from it; check their modal lists it back.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Today the answer to "who has access to the sales@ mailbox" needs an admin and a command. It becomes a page.

**Mirror**, on its own hourly cadence (fewer than 100 shared mailboxes: one listing plus two permission reads per mailbox is a couple of hundred calls, cheap enough to run hourly): every shared mailbox — Entra object id, display name, primary address, created, on-prem synced flag — and its access rows: **can open** (FullAccess) and **can send as** (SendAs), each naming the grantee. Grantees are matched to the mirrored directory user by Entra object id; a group grantee is kept and shown as a group; `NT AUTHORITY\SELF`, inherited and deny entries are ignored. Send-on-behalf is deliberately not mirrored — it is on-prem-owned for synced mailboxes and we will never manage it.

Vanished handling follows the mirror rule: a mailbox that leaves the tenant is marked, never deleted; an access row that disappears is removed, because it is a current-state fact.

**Screens** (Screen conventions, `brief/information-architecture.md`): **Access Control ▸ Shared Mailboxes** — searchable list with name, address, on-prem pill, and the two counts; a detail page with two lists, *Can open* and *Can send as*, each row linking to the person or group. A user's detail page gains a *Shared mailboxes* section. Read-only in this task.

Depends on the Exchange connection. Until it is configured the list says so.