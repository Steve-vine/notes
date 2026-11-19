---
id: 01M7QV1M06BT06WRAZ0ASEEWVT
created: 2026-11-18T17:25:04.646932Z
updated: 2026-11-19T00:17:18.153024Z
type: task
title: Pin documents and folders to the top of the Library
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1968
sprint: s2q1gxe
blocked_by:
- 01M7QV18EEP76MSWB8XSZ5F814
- 01M7QV0XWQ5RFSZ6A4EWXE6AG5
comments:
- id: 01M7RJMA8HGXACZT117G4C9XV9
  author: Steve Vine
  at: 2026-11-19T00:17:14.513355Z
  text: |-
    Merged: PR #1975, sha 05002b41. Migration 0880_library_pins (on 0879). New API: GET/PUT /library/pins.

    What changed: a Pinned section on the Library home above Recently viewed, shown when anything is pinned, newest first. Its tiles look like Recently viewed's, with an unpin icon top right. Pin/Unpin is in the "…" menu on every folder card (your own folders, domain folders, Not in a folder) and every document card, in the reading pane and in the reader's top bar. Everyone who can see the Library can pin, Viewers included. Pins are personal and follow the person to any browser. Something pinned that's unpublished, deleted or no longer visible drops out on its own.

    For Steve to overturn:
    - A Pinned document tile opens the reader, and its ⓘ opens the details pane, following COM-1972 rather than this task's "opens the pane".
    - "Open in Content" stays editor-only in a card's menu.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve, testing the Library on staging (18 Nov): a "Pinned" section above "Recently viewed", with a Pin action wherever a document or folder is.

**What a person sees**
- **Pinned section:** on the Library home, above Recently viewed. The tiles look like Recently viewed's: a type or folder icon, the name, and a line under it. A document shows its type and when it was reviewed; a folder shows "N documents". Each tile has an **unpin** icon in its top right corner. Clicking a tile opens the document in the reading pane, or opens the folder.
- **Pin action:**
  - in the "…" menu on every folder card: your own folders, domain folders and "Not in a folder";
  - in the "…" menu on every document card;
  - in the reader's top bar.
  It reads **Pin**, or **Unpin** when the item is already pinned. Everyone who can see the Library can pin, Viewers included, so every document card now has a "…" menu. The arranging actions in it still show only to people who can edit Content.
- **Pins are personal.** Pins belong to the person and follow them to any browser, like their pinned pages. They don't change the Library for anyone else.

**Choices, for Steve to overturn**
- The Pinned section is hidden when nothing is pinned.
- The newest pin comes first, with no reordering.
- There's no limit on pins. The section wraps like the others.
- A pinned document that's unpublished, deleted or no longer visible, or a folder that's deleted, drops out of Pinned on its own.
- The reading pane gets Pin/Unpin too, beside its other actions, for the same reason as the reader's bar.

**Done when**
- Pin and unpin work from a folder card, a document card, the reading pane and the reader's bar. The Pinned section updates at once.
- Pins persist across sign-out and another browser, and one person's pins never show to another. A test pins this.
- The unpin icon works from the keyboard, and its name says what it unpins.
- On a phone, the Pinned section wraps with no sideways scroll.
- Polaris: not in scope. It doesn't pin for people.

On the chain: a migration (each person's pins) and API (list, pin, unpin). Builds on COM-1967 (the home's new sections) and COM-1966 (domain folders, which can be pinned).