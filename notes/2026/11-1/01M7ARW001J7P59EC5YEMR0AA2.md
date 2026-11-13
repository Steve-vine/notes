---
id: 01M7ARW001J7P59EC5YEMR0AA2
created: 2026-11-13T15:36:55.553652Z
updated: 2026-11-13T15:36:57.597718Z
type: task
title: 'Activity log: remaining wording leftovers (old section bodies, pinned pages, ISO dates, stored values)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1798
sprint: spsp226
assignee: steve
label:
- improvement
priority: low
task_status: todo
---
Seen in the COM-1796 pre-UAT re-check on staging (08593437, 2026-11-13). Not caused by this sprint's changes, and outside COM-1785/1796's "Done when". Not started; for Steve to decide.

**What happens (Admin ▸ Activity):**
- **Old content section rows** (16 Oct and 2 Nov, visible with "all companies") show the section's raw Markdown in "Body: …". That includes image and asset ids and template tags such as "{{page-break}}", in lines of 255–337 characters.
- **User rows:** "Pinned pages: /initiatives, /dashboard, …" shows web addresses rather than page names (from COM-1743).
- **ISO dates inside summaries:**
  - "valid until 2026-11-27" (vendor assessment)
  - "audit pack CIS Controls v8.1, 2025-01-01 to 2025-12-31"
  - "recorded a rotation of SEC-51 on 2026-11-11"
  - "asked for a rotation by 2026-11-05"
- **Stored values in lower case:**
  - "Root cause addressed: — → yes"
  - "Form: virtual / physical"
  - "Min severity: — → high"
  - "Mail cadence: daily → weekly"
  - "Closing: source → missing"
- **Labels built from stored names:**
  - "Dpo advice / Dpo name / Dpo user" should read DPO.
  - "Estimate usd" should read something like "Estimate (US$)".
  - "Decided by name" and "Rule approved by name" repeat the line above them.

**What it should do:**
- Old section bodies read "Text changed" (or a short excerpt with no ids).
- Pinned pages read as page names.
- Dates in summaries read "27 Nov 2026".
- Stored values and labels read as screen words, with no duplicate lines.

**Done when:** each of the above reads in screen words on staging, old rows included; the COM-1796 general test covers the new shapes.