---
id: 01M3T2HQH8VZJ5J5PV0P2DJW9A
created: 2026-09-30T21:11:54.152543Z
updated: 2026-09-30T21:12:18.583707Z
type: task
title: Compass connects to AD with Kerberos encryption — every read, write and password change works without a certificate
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 818
sprint: sme8esk
blocked_by:
- 01M3T2H6BWZ678XVTYEQ9MHGKM
- 01M3T2HDSB26KQQAQVVK4MH8YJ
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Part of the on-premises AD sprint (Kerberos, ADR in COM-816).

## What people see

Nothing on screen yet; the choice arrives on the AD card in the next task. With a Kerberos connection configured (through the environment for now), everything Compass does in AD works exactly as it does over LDAPS:
- reading people, groups, lists and OUs
- spotting changes made directly in AD
- joiners, leavers, and group and list changes
- setting passwords

Existing LDAPS connections are unchanged.

## Notes (technical)

- **The connection** (`core/active_directory.py`): the connection factory gains a Kerberos path. It connects on plain 389, binds with SASL GSSAPI, then adds the confidentiality layer the ADR chooses. `ad_reader`, `ad_writer` and `_ad_run` are unchanged and take their connections from the same factory. **Refuse a DC that won't negotiate confidentiality.**
- **Setting:** `connection_security` (`ldaps` | `kerberos`) on `ad_settings`, via a migration that defaults to `ldaps` so existing installs are untouched. Env fallback `AD_CONNECTION_SECURITY`. The CA certificate becomes required only for `ldaps`.
- **Worker image:** the libkrb5 runtime and `gssapi` (built from source; the builder stage needs the krb5 dev headers). The arm64 backend build is emulated, so watch build time and cache hits.
- **`describe_failure` gains the Kerberos cases, in plain words:**
  - clock skew
  - server not known to Kerberos (a DC listed by IP or short name, or a missing SPN)
  - KDC unreachable on 88
  - DC refused to encrypt
  - wrong password: never retried on the other DCs, the same lockout rule as LDAPS
- **Integration tests against the Samba domain (COM-817):**
  - a bind, a read and a write
  - a `unicodePwd` set. AD refuses that over an unencrypted connection, so its success proves the connection is sealed.
  - the LDAPS tests still pass
- **Chart README:** the reach section lists TCP 88 and 389 for Kerberos alongside 636 for LDAPS.

**Done when:** CI proves a read, a write and a password set over Kerberos against the Samba domain, and the LDAPS path is unchanged.