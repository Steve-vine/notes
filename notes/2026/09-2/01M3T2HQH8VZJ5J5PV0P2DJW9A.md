---
id: 01M3T2HQH8VZJ5J5PV0P2DJW9A
created: 2026-09-30T21:11:54.152543Z
updated: 2026-10-06T10:41:20.655151Z
type: task
title: Compass connects to AD with Kerberos encryption — every read, write and password change works without a certificate
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 818
sprint: sme8esk
blocked_by:
- 01M3T2H6BWZ678XVTYEQ9MHGKM
- 01M3T2HDSB26KQQAQVVK4MH8YJ
comments:
- id: 01M3VBA7KQAHWT0DFSHX895C8A
  author: Steve Vine
  at: 2026-10-01T09:04:20.087358Z
  text: |-
    Done: PR #827, merged to main (de743e3).

    **Compass can now connect to AD with Kerberos instead of LDAPS.**
    - It uses plain LDAP on port 389, signed in with the service account's own Kerberos ticket, and every message after sign-in is encrypted.
    - No certificate is needed on the domain controllers.
    - Reading AD, spotting changes, joiners, leavers, group changes and password sets all work exactly as they do over LDAPS. Nothing above the connection knows which method was used.
    - Existing LDAPS connections are unchanged; LDAPS stays the default.

    **Proven against the Samba test domain in CI:**
    - A joiner was created **with a password**, put in a group, disabled, moved and deleted, over both LDAPS and Kerberos. AD refuses a password set over an unencrypted connection, so this is proof Kerberos encrypts it.
    - A captured copy of the network traffic after sign-in contains nothing readable.
    - A wrong password fails once, before any domain controller is tried, so it can't lock the account out.

    **What an admin sees when Kerberos says no:**
    - wrong, unknown, disabled or expired service account
    - *Can't reach a domain controller on port 88 (Kerberos)*
    - *Kerberos doesn't know 10.0.0.5 — list domain controllers by their full name*
    - *dc01's clock is 7 minutes off Compass's — Kerberos allows 5*
    - *dc01 wouldn't encrypt the connection*

    **Behind the scenes:**
    - The Kerberos library has to be compiled, so the app image and the CI runner image both gained a compiler and the Kerberos headers. You rolled the runners (`ci-runner:2.336.0-20261001-0732`).
    - The chart README now lists the ports for each method and the clock requirement.

    Nothing to smoke-test yet: the choice appears on the AD card in COM-819, and staging switches over in COM-820.
assignee: steve
label:
- feature
priority: high
task_status: done
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