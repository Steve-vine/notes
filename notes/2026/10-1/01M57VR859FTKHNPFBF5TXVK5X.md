---
id: 01M57VR859FTKHNPFBF5TXVK5X
created: 2026-10-18T15:58:11.625622Z
updated: 2026-10-18T20:59:47.546545Z
type: task
title: The User Portal gets Attestations — what you need to sign and by when, read the document, sign it (tick and type your name), and see everything you've signed before
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1095
sprint: s7s7mn9
blocked_by:
- 01M57VQQ6XGNJ86QW7CNXP1XBM
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 78, Attestations (ADR in COM-1092). Builds on who-is-due (COM-1094). Who can sign in comes in COM-1096. This task works for anyone who can already reach the portal.

## What people see

**Attestations** in the User Portal, for anyone who has something to sign or has signed something. It holds two lists:

- **To sign**: each document with its title, type, version, **due date** ("Due in 5 days", or "Overdue by 2 days" in red), and why it's asked ("Service Desk Analyst" or "3 of your roles"). Overdue items come first, then by due date. When the list is empty it says "Nothing to sign".
- **Signed**: what they have signed, with the version and date, and "late" where it was.

**Clicking a document** opens it read-only, as published, in the house style, with a **Download PDF** button. Below it sits the signing panel:

- a tick box: **"I have read and understood this document and agree to follow it."**;
- **Your full name**, typed;
- **Sign**, enabled once both are filled in.

After signing, the page confirms "Signed on 18 Oct 2026 at 16:02 — version 4" and returns them to the list. The document leaves **To sign** for every role that asked for it.

A signed document can be reopened from **Signed**. It shows the version they signed, with the signature details. If a newer version exists it says so, but they're only asked to sign it if a cycle asks.

## Rules

- A signature can't be edited, withdrawn or deleted, by anyone.
- Signing is always of the version the person was shown. If a new version is published while the page is open, Sign refuses and asks them to reload.
- A person sees only their own attestations. Nobody else's are visible in the portal.

## Notes (technical)

- Signature table: person (directory user and Compass account), content item, version, signed at, typed name, the statement text as shown, and sign-in method. Insert-only, audited.
- `POST /api/v1/portal/attestations/{id}/sign`. Add it to the exact-set portal write-routes test in `tests/test_portal.py` (integration-only, so a red shows in CI only).
- Reuse the content Read rendering and the content PDF endpoint, for the version signed, not the latest.
- The portal landing route (`App.tsx`, `/portal`) must send a person whose only portal reason is attestations to this page.

**Done when:** a portal user can see what they owe, read it, sign it, and find it again under Signed. Signing clears it for every role that asked.