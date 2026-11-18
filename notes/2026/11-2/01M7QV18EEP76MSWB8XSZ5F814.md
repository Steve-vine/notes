---
id: 01M7QV18EEP76MSWB8XSZ5F814
created: 2026-11-18T17:24:52.814141Z
updated: 2026-11-18T22:17:27.910703Z
type: task
title: 'Library home: a plain count, no Try row, "Recently viewed", then "Folders" and "Domains"'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1967
sprint: s2q1gxe
blocked_by:
- 01M7QV0XWQ5RFSZ6A4EWXE6AG5
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Steve, testing the Library on staging (18 Nov): changes to the Library home page.

**What the home shows, top to bottom**
1. **Title and count.** Under "Library", only the count: "58 documents in 24 folders". The words "Every policy, standard, procedure, runbook and decision — " go. The folder count includes domain folders and your own folders. "Not in a folder" isn't counted.
2. **Search box and type chips**, as now, with **no "Try" row**. The suggestions under the search box go. Searching by tag still works.
3. **Pinned**, when anything is pinned (COM-1968).
4. **Recently viewed**, renamed from "Pick up where you left off". It works the same.
5. **Folders**, renamed from "Browse". It holds your own folders first, in their arranged order, then **"Not in a folder"** as the last card. New folder stays with this section. With no folders of your own yet, it shows only "Not in a folder".
6. **Domains**, a new section. It holds every domain's fixed folder (COM-1966), in the domains' order, with the same card style as Folders. Domain cards have no arranging actions.

**Done when**
- The home reads as above for an editor and for a Viewer. A Viewer sees no New folder.
- With no documents or folders, the count and sections read sensibly. Empty sections are left out, apart from Folders, which always holds "Not in a folder".
- The Try row and its code are gone. If nothing else uses the Library tags endpoint (COM-1948), it goes too. Content's own tag suggestions are unaffected.
- On a phone, sections stack with no sideways scroll.
- Polaris's Library browse describes the home in the same terms: Folders, Domains and Not in a folder.
- Tests and the e2e Library crawl are updated for the new section names.

Frontend mostly. Builds on COM-1966 (domain folders).