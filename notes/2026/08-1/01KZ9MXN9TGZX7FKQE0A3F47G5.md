---
id: 01KZ9MXN9TGZX7FKQE0A3F47G5
created: 2026-08-05T19:03:06.810181Z
updated: 2026-08-08T11:08:46.153104Z
type: task
title: 'Servers foundation: connection profiles, server register, Servers screen with onboarding preflight'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 564
sprint: sesjg7z
assignee: steve
label: null
priority: high
task_status: active
---
The vertical foundation slice (ADR 0084 / ISE-563): an operator can register a server and see the fleet. Both platforms for connectivity from day one.

**Backend**
- Servers connector skeleton implementing the standard interface: credential spec, health check, empty-for-now sync/act surfaces to grow in ISE-565..569.
- **Connection profiles**: named credential + connection config — method (`ssh` / `winrm`), port, become/elevation settings, WinRM auth mode (Kerberos/NTLM) + TLS mode. Read/write split at the profile level (second credential, the established pattern). Land on the fixed post-ISE-553/554 credential-binding pattern — no unguarded string refs. Optional per-OS-family default profile.
- **Server register** model + migration: hostname/address, OS family, connection profile ref, state (`never_contacted` / `reachable` / `unreachable` / `error:<category>`), timestamps. Register row is *manageability config*, not an entity (entity minting/binding is ISE-565).
- **Onboarding preflight**: on register (and re-runnable per row) an `ansible.builtin.ping` / `win_ping` + minimal facts pass via ansible-runner, with **categorised failures**: unresolvable name / no route / timeout / auth refused / no Python (Linux) / WinRM not listening (Windows). The row shows *what's* missing, never a bare "unreachable".
- **Worker image**: ansible-core + ansible-runner + pywinrm + krb5 libs/realm config. Nothing is ever installed on targets.

**Frontend**
- **Servers screen** + nav entry (`components/nav.ts`): fleet list — hostname, OS, connection state, last contact, profile; FilterPanel on OS/state. **Add server** flow (hostname, OS family, profile pick) whose confirmation moment is the first successful preflight. Connection-profile management UI (list/create/edit).
- Integration card in Settings: status/health/last activity.

**Acceptance**: an operator can create a profile, add a Linux server and a Windows server in the UI, watch preflight succeed, and see a failed preflight name its category. Regenerate OpenAPI types after merge.