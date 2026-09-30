---
id: 01M3T2HDSB26KQQAQVVK4MH8YJ
created: 2026-09-30T21:11:44.171458Z
updated: 2026-09-30T21:11:44.171458Z
type: task
title: CI has a throwaway Active Directory domain to test the connection against
label: chore
priority: medium
assignee: steve
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 817
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