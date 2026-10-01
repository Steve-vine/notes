---
id: 01M3T2HDSB26KQQAQVVK4MH8YJ
created: 2026-09-30T21:11:44.171458Z
updated: 2026-10-01T07:53:26.05789Z
type: task
title: CI has a throwaway Active Directory domain to test the connection against
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 817
sprint: sme8esk
comments:
- id: 01M3V78CJAZHZX99DA7Y8DEF1B
  author: Steve Vine
  at: 2026-10-01T07:53:25.322313Z
  text: |-
    Done: PR #826, merged to main (9b35f19).

    **CI now has a real AD domain controller to test against**, a throwaway Samba domain (*compass.test*), alongside the in-memory fake used until now.
    - It's built ready-to-run, so a test session gets a working domain in a few seconds.
    - It answers both ways Compass can connect: LDAPS with its own certificate authority, and Kerberos.
    - Like real AD, it refuses a password sent over plain LDAP.
    - It holds a service account with rights over one OU, a user, a group and a nested OU.

    **What's now proven against a real DC:**
    - Test connection over LDAPS succeeds and names the domain.
    - A certificate from the wrong authority is refused as "not trusted".
    - A wrong password is refused.
    - A password over plain LDAP is refused.
    - The AD reader reads people, groups and OUs correctly.

    All five tests take about 5 seconds.

    **One fix it found:** Test connection failed against a DC that doesn't answer the "who am I?" question; Samba doesn't. The configured account name now stands in. Real AD answers it, so nothing changes for you.

    Nothing to smoke-test: test infrastructure only.
assignee: steve
label:
- chore
priority: medium
task_status: review
---
Part of the on-premises AD sprint (Kerberos, ADR in COM-816). This was deferred from COM-776 and COM-777. Kerberos can't be proven against today's in-memory fake domain (`tests/fake_ad.py`), which has no Kerberos and no encryption at all.

## What people see

Nothing directly. It's the test domain that the Kerberos connection (and LDAPS, for the first time) is proven against before either reaches staging.

## Notes (technical)

- **A Samba AD DC testcontainer**, pulled through zot under `compass/test/*` (see the memory on zot sync re-validating). The container provisions:
  - a realm, a service account and a test OU
  - LDAPS on, with a self-signed CA, so both connection methods are tested against the same domain
- **A session-scoped fixture** behind its own marker. The existing `fake_ad` tests stay as they are; this doesn't replace them.
- **Check the cost on the self-hosted runners.** Samba provisioning takes about 30–60 s, once per session. If it's much slower, cache a provisioned image in zot.
- **First tests:**
  - LDAPS Test connection succeeds against the domain.
  - The existing AD reader lists its users, groups and OUs.

**Done when:** CI connects to the Samba domain over LDAPS and reads it, and the fixture is ready for the Kerberos connection task.