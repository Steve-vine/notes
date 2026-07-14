---
id: 01KXGWH561SDHTKM2WK4ZNS4TX
created: 2026-07-14T17:59:23.073068752Z
updated: 2026-07-14T18:05:44.58297004Z
type: task
title: 'Linked content: external URL kind'
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 129
sprint: ssdk92z
label: null
---
The `linked` kind (M23) — a content item that is simply a URL to a remote document / web page. Smallest new kind; proves the per-kind branching end to end.

**Model / API**

* Nullable `external_url` on content; required (and validated as an absolute http/https URL) when `kind=linked`, rejected otherwise.
* Linked items skip the templated machinery: no sections/body/template, no PDF generation (404/409 on the PDF endpoint for this kind).

**Frontend**

* Create/edit: choosing kind Linked swaps the editor for a URL field.
* List + detail: an **Open** action that follows the URL in a new tab (`rel="noopener noreferrer"`).
* Detail page hides Read/Edit tab machinery that doesn't apply; governance panel (reviewers, cadence, review record) works exactly as for other kinds.

Blocked by <issue id="b485e441-4fea-4751-a073-e770fe3ab46d" href="https://linear.app/stevevine/issue/DEV-755/content-kinds-foundation-sourcekind-migration-kind-column-domain">DEV-755</issue>.

---
*Migrated from Linear [DEV-756](https://linear.app/stevevine/issue/DEV-756/linked-content-external-url-kind) · created 2026-07-02 · completed 2026-07-02*