---
id: 01M3EKWMVKC8SKYHCHXXMKD0F2
created: 2026-09-26T10:24:04.467901Z
updated: 2026-09-26T10:24:10.988878Z
type: task
title: 'A role that points at a list or group that''s been recreated in the cloud offers the new one: Replace with the new list'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 766
sprint: ss8v7d0
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Stacks on COM-764.

There are two ways to move a list or group from on-premises AD to the cloud:
- **Converted in place.** It's the same object and only its source flips. COM-762 already handles this: roles keep working, and open to-dos are done by Compass.
- **Recreated.** A new cloud object takes over the name and email address, and the old one is removed from sync. To Compass that's a new object. The old one shows as vanished, and every role still maps the vanished one.

This task makes the recreated case a one-click fix rather than something people discover when a joiner fails.

## What people see

- **In the role editor**, a vanished list or group a role still maps carries a **Gone from the tenant** pill. When a live object has since appeared with the **same email address** (or, for a security group with no address, the same display name), the pill offers **Replace with the new list**. Replacing swaps the mapping in one go. The usual role-edit preview (ADR 0064) shows who will be added to the new one. Nobody is removed from the vanished one, because there's nothing to remove.
- **An action for the role's managers.** "Sales maps a list that's been recreated: Sales UK (sales-uk@…). Replace it." It's module work on the Actions list (ADR 0055), closed by the replacement or by unmapping.
- **Until someone replaces it**, anything the vanished mapping would grant or remove fails on the request with the reason "Sales UK has gone from the tenant; the role needs updating". It is never silently skipped.
- **No match, no offer.** The pill still says *Gone from the tenant*, and the managers' action says to unmap it.

## Notes

- The match is a suggestion, never automatic. Two live objects matching one vanished address means no offer and says why.
- The vanished object's row is kept (mirror rule: marked, never deleted). The mapping history shows the swap.

**Done when:** a role mapped to a list that is then deleted and recreated with the same address (fake directory) shows the offer and raises the action. Replacing it moves the mapping, and a joiner afterwards gets the new list.