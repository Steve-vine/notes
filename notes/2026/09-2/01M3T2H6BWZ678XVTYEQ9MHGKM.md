---
id: 01M3T2H6BWZ678XVTYEQ9MHGKM
created: 2026-09-30T21:11:36.572921Z
updated: 2026-10-01T07:01:53.819016Z
type: task
title: Kerberos as a second way to secure the AD connection — no certificate on the domain controllers (ADR)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 816
sprint: sme8esk
assignee: steve
label:
- brief
priority: high
task_status: active
---
Part of the on-premises AD sprint (ADR 0083). Scoped with Steve 2026-09-30. **Gates the other Kerberos tasks.**

Today Compass connects to AD only over LDAPS, which needs a certificate on every domain controller. Some estates can't or won't put one there: staging's domain has no CA, and its DCs drop LDAPS. This adds a second way to connect, where the connection is encrypted by the service account's Kerberos sign-in instead. An admin picks one per AD connection, and both stay supported.

## What the ADR settles

- **Two ways, and the admin chooses:** *LDAPS (certificate)* or *Kerberos (no certificate)*. Compass never switches from one to the other by itself. A failing connection is Failed + Retry (ADR 0083's rule), never a quiet downgrade.
- **Same behaviour either way.** Reads, writes, password sets, detection, health and Test connection all behave the same. Nothing outside the AD card knows which way was chosen.
- **Same service account and password.** No keytab or extra secret: Compass gets its Kerberos ticket from the account and password already saved.
- **Always encrypted.** Kerberos encrypts the whole connection, not just the sign-in, and a DC that won't encrypt is refused. NTLM and plain LDAP stay out. NTLM doesn't prove the server is a genuine DC. Plain LDAP sends the password readable, and AD refuses password sets over it.
- **What the network needs:** TCP 389 (LDAP) and TCP 88 (Kerberos) from the worker to each DC, instead of 636. DCs are listed by their full DNS names, because Kerberos identifies a server by name and IP addresses won't work. The worker's clock must be within 5 minutes of the DCs'.

## Notes (technical)

- **ldap3 2.9.1 can authenticate with GSSAPI but can't encrypt.** `protocol/sasl/kerberos.py` only ever negotiates `NO_SECURITY_LAYER` (verified 2026-09-30). The options:
  - (a) Add a SASL confidentiality layer on top of ldap3: negotiate `CONFIDENTIALITY_PROTECTION`, then `gssapi` wrap/unwrap every LDAP PDU after the bind.
  - (b) Move to python-ldap (libldap + cyrus-sasl-gssapi), which has sealing built in.
  - **Recommend (a).** With (a), `core/ad_reader.py`, `core/ad_writer.py` and `tests/fake_ad.py` (ldap3 MOCK_SYNC) stay as they are. (b) rewrites all three. Record the rejected alternative.
- **Ticket:** `gssapi.raw.acquire_cred_with_password` into an in-memory ccache per process.
  - The realm is the domain upper-cased. The KDCs are the listed DCs, with no SRV lookups.
  - Set `rdns = false`, and TCP only (`udp_preference_limit = 1`) so a tunnel only needs one port per protocol.
  - krb5.conf is generated from the settings, not put in the chart.
- The SPN is `ldap/<dc fqdn>`.
- Amends ADR 0083 §8 ("LDAPS only") and the chart README's reach section.

**Done when:** the ADR is merged and the remaining Kerberos tasks match it (or are updated to).