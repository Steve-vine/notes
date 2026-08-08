---
id: 01KZ9MXN9TGZX7FKQE0A3F47G5
created: 2026-08-05T19:03:06.810181Z
updated: 2026-08-08T14:00:22.212053Z
type: task
title: 'Servers foundation: connection profiles, server register, Servers screen with onboarding preflight'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 564
sprint: sesjg7z
comments:
- id: 01KZGK8ZCZZAMT8JSM7SF2CXB6
  author: Steve Vine
  at: 2026-08-08T11:49:01.471782Z
  text: |-
    DONE — merged to main 2026-08-08 as `28a8db2` (PR #548), full CI green.

    An operator can create a connection profile, register a Linux or Windows server, and watch ISE try to reach it. Every acceptance point is met except the two that need real hardware (see below).

    **What landed**

    - **`ansible_exec.py`** — the whole transport seam. ISE runs Ansible itself via ansible-runner; nothing above this module imports a runner, so the register, the API and the tests never see one (the `build_client` precedent).
    - **Connection profiles + server register** (migration 0109) with a partial unique index enforcing one default per OS family in the database rather than in whichever request got there first.
    - **Categorised preflight** — the point of the slice. `unresolvable_name` / `no_route` / `ssh_refused` / `winrm_not_listening` / `timeout` / `auth_refused` / `no_python` / `unknown`, each with a sentence served from the backend saying whose problem it is.
    - **Servers screen** + capability-gated nav entry: fleet list with FilterPanel, add-server flow that self-refreshes while a preflight is pending, and a Connection profiles tab.
    - Worker image gains ansible-core, ansible-runner, pywinrm, openssh-client, sshpass and the krb5 libraries.

    **Three decisions worth recording**

    1. **`state` + `failure_category` rather than the planned `error:<category>` string.** A category glued into a status string cannot be filtered, counted or indexed — and the register's whole job is to lead with what needs a human.

    2. **The ISE-554 guard had a hole, and this task would have widened it.** `credentials.bound_systems` only looked at `System.credential_ref`/`write_credential_ref`. Connection profiles hold the same unguarded string refs, so deleting a credential a profile still used would have succeeded silently and surfaced at a preflight days later — the exact failure ISE-554 was written to prevent, in the one place nobody would look. Now `credential_holders`, counting profiles, tested on both sides.

    3. **Kerberos is an image-only extra.** `pykerberos` compiles against the system GSSAPI headers, so `pywinrm[kerberos]` in the base dependencies would have forced an apt step into all four CI jobs that run `uv sync` — a change to the runner contract for a library CI never exercises. The Dockerfile builder installs the headers and syncs `--extra kerberos`; CI stays pure-python. Both auth modes work in the shipped image.

    **A real bug the tests caught:** making a second profile the default failed on the INSERT instead of moving the default. The clearing SELECT autoflushed the pending row into a unique index that is checked per statement. Fixed with an immediate Core UPDATE inside `no_autoflush` — the ORM-loop version is wrong twice over, since SQLAlchemy is also free to order the INSERT ahead of the UPDATEs.

    **Not yet proven, and it needs you:** the two acceptance criteria that require real hardware — "add a Linux server and a Windows server and watch preflight succeed" and "see a failed preflight name its category". Everything above the transport is tested against real Postgres with the seam faked; whether agentless Ansible from the g5 worker pod actually reaches the estate is exactly what batch 1's smoke test is for. Two test boxes reachable from the worker (native or Twingate), each with a credential pre-deployed — SSH key/account on Linux, WinRM-enabled admin account on Windows.
- id: 01KZGTSFE45NGE398HW5KD2YNR
  author: Steve Vine
  at: 2026-08-08T14:00:22.211846Z
  text: |-
    FIX-FORWARD from your smoke test — PR #551, merged as `978caf1`, staging redeployed and verified (alembic 0112).

    You reported the profile's credential pickers listing `cloudflare-read` / `cloudflare-write`. Two faults behind that one symptom, and the second was worse than the noise you could see:

    **1. No form anywhere could create a server credential.** A credential form is rendered from its connector's own `credential_spec()` (ISE-56). I had the Servers connector declare `CredentialSpec(fields=[])` — right for keeping the System-level slots off (ISE-553), wrong as a side effect: with no fields there is no form, so the only thing a profile could ever be bound to was a secret some other integration's form had created. You were not looking at a badly-filtered list; you were looking at the only list that existed.

    **2. The credential store is a flat namespace.** `Credential` recorded nothing about what a secret is shaped for, so the picker had nothing to filter on. Invisible while every credential was created and bound from the same screen; a real problem the moment something else offered a picker.

    **What changed**

    - The connector declares its credential shape — username, password, SSH private key, sudo password, with `help` on each saying which apply to SSH and which to WinRM (the GitHub two-identities pattern). `credential_use()` still returns read=False/write=False, now stated explicitly rather than derived: "has fields ⇒ has a read slot" became wrong here.
    - **The profile form asks for the credential directly.** It stores through the ordinary credential store (ADR 0018 — not a second secrets mechanism) under a derived name, `servers-<profile>-read` / `-write`, so you are not naming things in a namespace where you could collide with `cloudflare-read`. Re-entering rotates in place; leaving the boxes blank keeps what is bound, so changing a port does not mean re-typing a key. If you do want to reuse one credential across profiles, that picker is still there — scoped to servers.
    - `credential.connector_type` (migration 0112). Existing rows stay NULL rather than being back-filled from their names: a `-read`/`-write` convention would classify most correctly and some wrongly, and a wrong guess filters a credential OUT of the picker that owns it. They gain a type on their next store or rotation.
    - **Structural validation**, which matters more here than almost anywhere: a private key flattened at paste time is now refused at the moment you paste it, with a message saying so. Without it the key stores happily and surfaces as `auth_refused` against a machine — sending you to check the account when the fault is a missing newline.

    Ready to try again: create the profile, paste the key, and the preflight is the real test.
assignee: steve
label: null
priority: high
task_status: review
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