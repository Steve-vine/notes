---
id: 01M7F9CFBMAHBVDXBY1013JAR7
created: 2026-11-15T09:42:30.516516Z
updated: 2026-11-15T09:48:37.281343Z
type: task
title: Integrations screens group connections into "Can change things" and "Read only", each saying what Compass uses it to do
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1841
sprint: spsp226
blocked_by:
- 01M7F9BCSDAHHXAF5SW66GZK72
comments:
- id: 01M7F9Q1AGZS35AJK5P7K838K7
  author: Steve Vine
  at: 2026-11-15T09:48:16.592173Z
  text: Since logging this, COM-1843 puts Collection and Core on separate tabs, with Collection first. Build the "Can change things" / "Read only" grouping inside the Core tab. The Collection tab is all read only, so the "link to Collection integrations with a count" under Read only isn't needed. Each Collection tile still shows the Read only pill. Build after COM-1843, or rebase onto it if it lands first.
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
## What happened

This follows from the ADR on read-only evidence. Steve wanted the read-only/read-write split to be visible. Today Admin ▸ Integrations lists Compass's own connections (Microsoft 365, Active Directory, AWS, Azure, Google Cloud, mail, storage, Endoflife…), and Collection integrations sit on their own screen. Nothing says which connections can change things or what Compass uses each one for.

## What people see

- **Admin ▸ Integrations is grouped under two headings:**
  - **Can change things:** Microsoft 365 and Active Directory (Access Control), SMTP, SendGrid and Amazon SES (sending mail), and S3 (storing files).
  - **Read only:** AWS, Azure, Google Cloud, Endoflife, and a link to Collection integrations with a count.
- **Each connection carries a pill and a line.** The pill says "Can change things" or "Read only". The line says "Compass uses it to: …", for example "manage people, groups and mailboxes", "send mail", "store uploaded files", "discover resources for Inventory", "read evidence and feeds" or "know when software goes out of support".
- **Collection integrations show "Read only"** on their list and on each integration.
- **The AD card shows two accounts**: Access Control's (can change things) and the read-only one for evidence, once that task lands.
- This is different from COM-1835's "What we use it for", which is the business's own statement of which evidence lives where. The words "Compass uses it to" keep the two apart.

## Done when

- On staging, Admin ▸ Integrations shows the two groups, with every connection in the right one and its pill and line. Collection integrations show "Read only". Narrow widths still work.
- Vitest covers the grouping and pills. `screen-conventions.test.ts` still passes.

**Independent** (screens only). The AD two-account part waits on the read-only AD account task; until then the AD card sits under "Can change things".