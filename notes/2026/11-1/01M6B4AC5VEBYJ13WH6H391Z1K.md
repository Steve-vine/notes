---
id: 01M6B4AC5VEBYJ13WH6H391Z1K
created: 2026-11-01T08:41:19.29119Z
updated: 2026-11-01T08:41:38.853477Z
type: task
title: Adding a vendor asks who owns it — a vendor no longer starts with nobody accountable
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1499
sprint: scpaa6p
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Sprint 100, Actions. Follows COM-1482 (an owner is required on manual create). Steve chose this on 1 Nov 2026 over two alternatives: leaving new vendors unowned, or making whoever adds one its owner.

## Why

Asking for a new vendor through a request already makes the requester its owner. A vendor added straight onto the register still starts with **no owner**. COM-1482 deliberately left it that way, because a vendor's owner isn't just a name:
- they sign off every engagement and amendment request on that vendor, alongside the approval areas;
- a request they raise on their own vendor counts as owner-approved;
- the vendor appears under My Vendors in their portal, and its review reminders go to them.

So defaulting the owner to the creator would quietly make an admin doing data entry the vendor's approver. Instead, the person adding the vendor **chooses** its owner.

## Behaviour

- On the register's **Add vendor** form, **Owner** is a required field. It starts empty, and the form can't be saved until someone is picked. The picker offers only people who can be owners, the same list as Transfer ownership.
- Polaris adding a vendor has to name an owner too. If it doesn't, it's told to ask who should own it.
- Anywhere else a vendor is created (an import, say) also needs an owner, or says plainly why it doesn't.
- Vendors that already have no owner stay as they are. Their actions keep going to the people who manage the register until someone takes ownership. Nothing is back-filled.
- A new-vendor request is unchanged: the requester still becomes the owner.

**Chain:** on the chain (the vendor create API makes the owner required).

**Done when:**
- The Add vendor form won't save without an owner, and the vendor saves with the chosen owner.
- The API refuses a vendor with no owner, with a message that says so.
- Polaris's add-vendor tool requires an owner.
- Existing unowned vendors are unaffected, and their actions still go to the register managers.
- Pre-UAT in E2E Test Company: add a vendor as E2E Vendor Admin. It's refused without an owner, and saves with one.