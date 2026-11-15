---
id: 01M7FM542TQJFW6X3AYZ5GWB6X
created: 2026-11-15T12:50:43.930137Z
updated: 2026-11-15T12:52:18.164663Z
type: task
title: A document can hold a named list (a table marked as a list, each entry with a reference) that workflows read from the latest published version
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1852
sprint: s7nqsy0
blocked_by:
- 01M7FM37RNKW81E5SQ1QDQA2MN
assignee: steve
label:
- feature
priority: high
task_status: todo
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