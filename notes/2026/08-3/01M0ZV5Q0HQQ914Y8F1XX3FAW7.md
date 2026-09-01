---
id: 01M0ZV5Q0HQQ914Y8F1XX3FAW7
created: 2026-08-26T20:11:21.489637Z
updated: 2026-09-01T13:55:52.105786Z
type: task
title: A directory role becomes something Compass holds — mirror it, and know who holds it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 444
sprint: s5gwx0s
comments:
- id: 01M11SNHFVJ5S0GWXJQRSV461Z
  author: Steve Vine
  at: 2026-08-27T14:23:31.835423Z
  text: |-
    Done and merged — PR #443, on main as 8e9caf2.

    The mirror gains directory_roles and directory_role_assignments. The Graph reads were already being made: _fetch_directory_roles read every assignment and every definition each pass and then kept only the few whose principal was a role-assignable group, flattened to names. This keeps the rest. directory_role_names on the group is now derived from the same data and unchanged for its readers — an existing test asserts the groups list and group modal still show exactly what they showed.

    The two decisions the brief asked for:

    Eligible as well as active, marked. "Who could be a Global Administrator" is the more honest answer, and an eligible holder is invisible to a mirror holding only active ones. They are separate rows and no screen may blur them. assignment_type is part of the primary key on purpose: someone permanently active who is also eligible is two facts, not a contradiction, and collapsing them would lose the eligible one.

    Degraded loudly, and per half. This turned out to matter more than expected. Eligible assignments need Entra P2 as well as the RoleManagement grant, so that half can refuse while active reads perfectly well — it now fails on its own: the active half still reconciles, the eligible rows already banked are left alone rather than reconciled away against a read that never happened, and the sync status records that it could not be read so every response carries eligible_available/eligible_reason. Same for a total failure: the role tables are left untouched, because the previous answer beats an empty one.

    Two things derived rather than stored:
    - Holders through a group are expanded at read time from effective membership. A stored holder row would go stale the moment somebody joined that group; this way nesting inherits privilege for free (tested — a person two levels down shows up, with the granting group named).
    - A holder the mirror does not carry (a service principal) is kept and counted as unresolved rather than dropped. Under-reporting who holds privilege is the one failure this data exists to prevent.

    API: GET /directory/roles and /directory/roles/{id}, browse-only on access-read. holder_count is distinct people; assignment_count is the assignments behind it.

    Migration 0127 is purely additive — two tables, two columns on the sync-status singleton, nothing transformed — so a populated database takes it exactly as a fresh one does. Verified locally against a populated DB including a downgrade/upgrade round-trip, which is the branch CI never exercises.

    No new ADR: this extends the ADR 0045 mirror rather than changing how access control works. One judgement call flagged in the PR — holding eligible assignments does slightly widen what Compass claims about privilege ("could be" alongside "is"). It is marked everywhere rather than merged, so I do not think it changes the model, but if you disagree that is the bit to record.

    Nothing visible changes from this task alone; COM-445 is the screen.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Today a directory role is only ever a word. On a group it is a name in a mirrored list of "roles this group grants"; on a person it is a name fetched live from Entra the moment you open Account details. Nothing in Compass knows a role has an identity, and nothing can answer the question that matters — *who is a Global Administrator here?*

This is the half that makes the answer possible. The screen that shows it is the task stacked on this one.

## What changes

Nothing visible yet. Compass gains a record of every Entra directory role and everyone holding it — by name, held directly or inherited through a role-assignable group — kept current by the sync that already runs.

## Scope

**The mirror.** A directory role alongside the users, groups, devices and contacts already there: its Entra id, display name, description, and whether it is built-in. Then the assignments — principal, role, and whether the principal is a user or a group.

**The sync.** `_fetch_directory_roles` already reads every role assignment and every role definition on each pass, and then throws most of it away — it keeps only assignments whose principal is a role-assignable group, flattened to names on that group. Keep the rest. The Graph reads are already being made and already paged around the `roleManagement` endpoints' `$top` quirks (COM-273, COM-314), so this is mostly a matter of storing what is already in hand.

Keep the existing `directory_role_names` on the group working while both exist — the groups list and the group modal read it, and this task should not change what they show.

**Inheritance.** A person can hold a role directly or by being in a group that grants it. Both count, and the record should be able to say which — "via Security Admins" is the useful half of the answer.

**Two decisions to make and state in the PR:**

- **Eligible vs active.** Account details already distinguishes them (PIM's assignment and eligibility schedules). Decide whether the mirror holds both and marks which, or holds active only. Holding both is the more honest answer to "who could be a Global Administrator", and it is the reason to prefer it.
- **Degraded, loudly.** Role resolution needs `RoleManagement.Read.Directory`, and the existing code returns "unknown" rather than an empty list when the grant is missing — that idiom exists precisely so a missing permission never reads as "nobody holds this role". Carry it through: a role with unresolved holders says so.

**The API.** Read endpoints for the role list and one role's holders, under the existing access-read permission. This is browse-only mirrored data, like the rest of the directory endpoints.

Follows ADR 0045. No new ADR expected — this extends the mirror rather than changing how access control works — but if holding eligible assignments turns out to change what Compass claims about privilege, that is worth recording.

## Tests

Integration tests against real Postgres for the sync, as the rest of the mirror has: a role gained, a role lost, a holder added directly, a holder added through a group, and the missing-grant case landing as "unknown" rather than empty.