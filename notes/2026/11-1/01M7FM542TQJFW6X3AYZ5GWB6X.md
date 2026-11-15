---
id: 01M7FM542TQJFW6X3AYZ5GWB6X
created: 2026-11-15T12:50:43.930137Z
updated: 2026-11-15T22:08:14.243929Z
type: task
title: A document can hold a named list (a table marked as a list, each entry with a reference) that workflows read from the latest published version
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1852
sprint: s7nqsy0
blocked_by:
- 01M7FM37RNKW81E5SQ1QDQA2MN
comments:
- id: 01M7G6A9W6WYVZT3S9BK88MMD7
  author: Steve Vine
  at: 2026-11-15T18:08:08.070832Z
  text: |-
    Done — PR #1846 merged (4f77360a, no migration). In the Content editor a table's Table options menu has "Use as a list…": name it ("Approved standard changes") and choose its reference column from the headings; "List settings…" renames, re-points or stops it. The table looks exactly the same on the Read tab, PDF / Word / plain-text exports and the user portal; only editors see a note above it ("List: Approved standard changes · reference Ref · used by 2 workflows"), which also says what's wrong when the list can't be read.

    Marking is an ordinary edit: it counts once published, and workflows read only the latest published version (with its version number). Publish… checks the lists: one that can't be read stops the publish with the reason; a publish that would break a workflow (list removed or renamed, reference column changed, a column it reads gone) names those workflows and needs "Publish anyway" ticked. The Read tab shows "Workflows that read this" (nothing when none). Uploaded, linked or SharePoint documents say on the Edit tab that only a document written in Compass can hold a list workflows read.

    Polaris: reads a document's lists (published version, entries, problems, which workflows read each); marks a table through the ordinary section edit; is refused a breaking publish naming the workflows, until the person agrees.

    Calls: the reference column is chosen by heading, not position (a renamed heading shows a problem until re-chosen); a row with no reference or a duplicated reference only warns; deleting a document isn't blocked — workflows reading it fail their next run with the reason. Real workflow usages are wired in by COM-1853 (until then the warning is proven with a test registration).
- id: 01M7GM1NXFN212E21N1F33VPQV
  author: Steve Vine
  at: 2026-11-15T22:08:05.551046Z
  text: |-
    Couldn't check: everything that needs a published document (pre-UAT, 2026-11-15, build f8665615). The editor side passed.

    Why: the testing rules say never to publish Playbook content on staging, because the Playbook is shared by every company. The only document with standard changes, "Approved Standard Changes" (Steve's, v1), is published without a list, so the builder correctly says it "holds no list".

    What I checked (E2E Admin A, on a throwaway draft "E2E UAT 20261115 list draft", deleted afterwards):
    - I put a table (Ref / Change / Owner) in the draft. Table options has "Use as a list…". The dialog asks for a list name and a reference column, picked from the headings (Ref was preselected). After saving, an editor note sits above the table: "List: E2E UAT approved changes · reference Ref", and the table looks unchanged.
    - Opening Publish… with a healthy list showed no list warning.
    - I renamed the Ref heading. The note changed to "… reference Ref — No column is called 'Ref'.", and Publish… showed "Its lists can't be published yet — The list … has no column called 'Ref'". I cancelled without trying to publish, so nothing was published.
    - The published document's Read tab shows no "Workflows that read this" section, which is right because no workflow reads it.

    For Steve to try: mark the table in "Approved Standard Changes" as a list (reference column: add one such as Ref, or use Change), publish it, and check:
    1. the builder's "A document's list" step then offers the list and its columns;
    2. the PDF and the user portal look unchanged;
    3. after a workflow uses it, renaming the list or the reference column and opening Publish… names that workflow and asks for "Publish anyway".

    Screenshots: ~/compass-uat/s7nqsy0/COM-1852/
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint "Automation - Workflows" (ADR in COM-1848). Needed for Steve's first case: compare the changes a service reports against the approved standard changes held in a Content document.

## What people see

- In the Content editor, a **table** can be marked **"Use as a list"** and given a name ("Approved standard changes"). One column is the **reference** (e.g. SC-014). The others are whatever the document needs (name, description, owner, conditions).
- The table looks the same in the document, on screen, in the PDF and in the user portal. A small "List: Approved standard changes, used by 2 workflows" note shows only to editors.
- Workflows read the **latest published version** only. Unpublished edits don't count until published, the same rule as reviews (ADR 0149).
- If an editor changes a list's reference column, renames the list or removes it, and a workflow uses it, the editor is warned before publishing and told which workflows will break.
- Content ▸ the document's page lists the workflows that read it.
- Polaris can read a document's lists, and can mark a table as a list when asked (as an ordinary content edit, which still needs publishing).

## Notes for the builder

- Lists are part of the document's content and versioned with it, so a workflow run can record "Approved standard changes, version 7".
- Entries need a stable reference so matching isn't on free-text wording. Workflows can still match on another column (see the Compass sources task).
- Templated and SharePoint-backed content (ADR on templated content): if a SharePoint-sourced document can't carry a marked table, say so in the editor rather than half-supporting it.

## Done when

- An editor can mark a table as a named list with a reference column, publish it, and a workflow can read its entries from the published version.
- The warn-before-publish check names the workflows that would break.
- The list renders unchanged in the PDF and portal.
- Tests for versioning, reading the published version only, and the warning.

**On the chain** (content structure + API).