---
id: 01M7F9BXGRXPAXD7R8XTXJZPBD
created: 2026-11-15T09:42:12.248066Z
updated: 2026-11-15T12:01:10.048332Z
type: task
title: Active Directory evidence reads through a separate read-only account, never Access Control's delegated one
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1839
sprint: spsp226
blocked_by:
- 01M7F9BCSDAHHXAF5SW66GZK72
comments:
- id: 01M7FHAB0T9431AKJG0JT2XDNK
  author: Steve Vine
  at: 2026-11-15T12:01:09.145928Z
  text: |-
    Built and merged — PR #1835 (978b5d17). This one changes the database (migration 0857_ad_read_only_account) and the API.

    What you'll see:
    - **Admin ▸ Integrations ▸ Active Directory has a "Read-only account for evidence" section** below the service account. It has a username, password, Save, Test, Remove, a status badge, and "Evidence last read as <account> at <time>". It uses the same domain controllers and LDAPS/Kerberos settings. Access Control's own account can't be entered as the read-only one, whether typed as name@domain or DOMAIN\name.
    - **Collected checks and Polaris's design reads sign in to AD only as that account**, never as the service account. A capture is labelled "Active Directory · <read-only account>".
    - **Without one, AD isn't offered for evidence.** Polaris says "Active Directory needs a read-only account before checks can read it." and links to the AD set-up. A check's AD read is refused with the same sentence, and the AD tile's What we use it for tab says the same. Access Control and directory sync are untouched.
    - **Test** signs in, reads the domain, then asks AD what the account may change, in the domain and in each ticked OU. If it can change or create groups or accounts, it warns, and the badge reads "Can change things". The check covers the domain root, the ticked OUs and up to 200 groups and users, so it can miss some rights. It advises; it doesn't block.
    - **Secrets register:** its password is a secret beside the service account's, with the same rotation reminders. A new password counts as a rotation, and Remove retires the secret.
    - docs/active-directory/README.md has a new step 5 for creating and testing the account.

    Decisions:
    - **There is no fallback to the service account.** AD checks already approved stop collecting, and show the missing-account sentence, until the read-only account is set. Flagging and Re-create are COM-1840.
    - Test runs only when someone presses it, never on the 5-minute background check. A wrong password retried every five minutes would lock the account out.

    Tests: backend tests that evidence reads never sign in as the delegated account and that a missing read-only account means AD isn't offered, plus the screen and Secrets register. Vitest covers the second account on the AD card.

    **Needs you:** a plain domain user in each AD domain (e.g. compass-ad-read), with no groups, no delegation and a long, non-expiring password. Enter it on the AD card and press Test. **This must be set in production before this release goes there**, or production's AD checks stop collecting.
assignee: steve
label:
- improvement
priority: medium
task_status: review
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