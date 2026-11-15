---
id: 01M7F9BXGRXPAXD7R8XTXJZPBD
created: 2026-11-15T09:42:12.248066Z
updated: 2026-11-15T10:57:57.621318Z
type: task
title: Active Directory evidence reads through a separate read-only account, never Access Control's delegated one
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1839
sprint: spsp226
blocked_by:
- 01M7F9BCSDAHHXAF5SW66GZK72
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
## What happened

This follows from the ADR on read-only evidence. Collected checks that read Active Directory sign in as Access Control's service account, which holds delegated write rights (ADR 0086, the central delegation). AD has no web API, so the evidence can't move to a Collection integration. Instead, the AD connection needs a second sign-in that can only read.

## What people see

- **Admin ▸ Integrations ▸ Active Directory gets a second account: "Read-only account for evidence"**, with its own username, password, hint and test.
  - It uses the same domain controllers and the same LDAPS or Kerberos settings as the main account.
  - A plain domain user is enough, because authenticated users can read the directory. LAPS, BitLocker and password attributes stay refused, as now.
- **Collected checks, feeds and Polaris's design reads use only that account.** Access Control's account is never used for them.
- **If no read-only account is set,** AD is not offered as a source for evidence. Polaris says so: "Active Directory needs a read-only account before checks can read it." Access Control is unaffected.
- **Its test shows the account can sign in and read.** Where the directory can say so, the test also warns if the account appears to hold the write rights given to Access Control's account.
- It follows the secrets register's rotation reminders like the main account (ADR 0141).

## Done when

- On staging, the AD connection has a read-only account set. A collected check reading AD signs in as it, and the check's capture and the connection's last-read show that account.
- With the read-only account removed, Polaris doesn't offer AD for evidence and says why. Access Control's sync still works.
- Backend tests confirm evidence reads never use the delegated account, and that a missing read-only account means AD isn't offered. Vitest covers the second account on the AD card.

**Needs Steve:** a plain domain user in each AD domain.

**On the chain** (migration for the second credential, plus API changes). Blocked by the ADR task.