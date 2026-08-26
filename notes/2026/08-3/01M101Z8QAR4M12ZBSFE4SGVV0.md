---
id: 01M101Z8QAR4M12ZBSFE4SGVV0
created: 2026-08-26T22:10:10.282385Z
updated: 2026-08-26T22:11:32.984051Z
type: task
title: Exceptions, opened from either end — from the group, or from the person
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 450
sprint: snq23hz
assignee: steve
company:
- moneypenny
label:
- feature
priority: medium
task_status: backlog
---
Stacks on COM-449, which builds the request underneath. Part 4 of COM-446, the half people see.

Two doors, because people arrive at the problem from both directions — sometimes you are looking at a group and know who should be in it, sometimes you are looking at a person and know what they need.

## What changes for the reader

**From the group.** Open a group and add or remove its members — people or nested groups. The membership list stops being read-only.

**From the person.** Open someone's Account details and add or remove the groups they belong to.

Either way you say why, it goes for approval, and it appears in the request history like every other change. Same form underneath, two entry points.

## Scope

- **`access/GroupDetailModal.tsx`** — an add/remove affordance on the members list, and on the nested-groups list. Guarded by the same write permission as raising any other request.
- **`access/UserDetailModal.tsx`** — the same, against the person's groups.
- **The Raise request menu** gains the kind, for people who start from the requests screen rather than from a thing.

**Show provenance where membership is listed.** Once COM-447 lands, a membership is role-derived, an exception, or unattributed — and a reader who cannot see which cannot tell governed access from inherited access. Mark it on the member lists, and say which role or which request where there is one. This is the surface where the whole model becomes legible, so it is worth more than a tooltip.

**Privileged groups.** Until COM-450 lands, the affordance is absent or refused on role-assignable groups, and says why rather than failing silently.

## Tests

Component tests for both entry points, the permission guard, and the provenance markers rendering all three states. The unattributed marker is the one to get right — it is what 1,500 people will be on day one, and it must read as "nobody has said why yet", not as an error.