---
id: 01M3T2J0776H4TM32KJ3TGSJMR
created: 2026-09-30T21:12:03.047372Z
updated: 2026-09-30T21:12:19.474425Z
type: task
title: 'Admin ▸ Integrations: the Active Directory card offers LDAPS or Kerberos'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 819
sprint: sme8esk
blocked_by:
- 01M3T2HQH8VZJ5J5PV0P2DJW9A
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Part of the on-premises AD sprint (Kerberos, ADR in COM-816).

## What people see

- **Connection security** on the Active Directory card, with two choices. Each one says what the domain controllers and the network need:
  - *LDAPS: needs a certificate on each domain controller, port 636.*
  - *Kerberos: no certificate; ports 88 and 389, and domain controllers listed by full name.*
- **The CA certificate field only shows for LDAPS.** Switching to Kerberos keeps the saved certificate, so switching back needs no re-paste.
- **Test connection says in plain words what's wrong** with a Kerberos connection:
  - *"dc01's clock is 7 minutes off Compass's"*
  - *"Kerberos doesn't know dc01. List domain controllers by their full name."*
  - *"Can't reach dc01 on port 88"*
  - *"dc01 wouldn't encrypt the connection"*
- **The card, health badge and System status say which method is in use**, e.g. *Connected to corp.example.com through dc01 with Kerberos*.
- **Changing the method is recorded in the audit trail.** A method set from the environment is labelled *Configured via environment*, as today.

## Notes (technical)

- **API:** `connection_security` on the AD settings in and out; the certificate is required on save only when it's `ldaps`. Run the OpenAPI drift script.
- **Frontend:** a radio group on the card. Every Radio needs `w="fit-content"`, and only the full vitest run catches a missing one (screen-conventions test).

**Done when:** on a dev stack, an admin can switch the card between LDAPS and Kerberos. Test connection and the health badge follow the choice, and each Kerberos failure above shows its message.