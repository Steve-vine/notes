---
id: 01M7ARW001J7P59EC5YEMR0AA2
created: 2026-11-13T15:36:55.553652Z
updated: 2026-11-13T19:18:52.620043Z
type: task
title: 'Activity log: remaining wording leftovers (old section bodies, pinned pages, ISO dates, stored values)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1798
sprint: spsp226
comments:
- id: 01M7B5J9RHKG14FWAPTZ4TQHPR
  author: Steve Vine
  at: 2026-11-13T19:18:49.361516Z
  text: |-
    Built — PR #1793 (feature/com-1798-activity-leftovers), auto-merge set. Independent: no migration, no API change. Everything is worked out when a line is shown, so old rows read correctly too.

    What you'll see (Admin ▸ Activity and every History card):
    - Old section and item bodies with raw Markdown, ids or {{page-break}} read "Text changed".
    - Pinned pages read by the menu's names: "Pinned pages: — → Initiatives, Dashboard, Evidence" (a long list ends "and N more").
    - Dates in summaries follow your date format: "valid until 27 Nov 2026", "CIS Controls v8.1, 1 Jan 2025 to 31 Dec 2025", "on 11 Nov 2026", "by 5 Nov 2026". Dates inside file names are left alone.
    - Stored values read as the screens write them: "Root cause addressed: Yes", "Form: Virtual → Physical", "Min severity: High", "Mail cadence: Daily → Weekly", "Closing: When the source says so → When a complete read no longer has it". Also fixed: Date format, Clock, Criminal activity, Data held for, People locations, collection sign-in method, Template.
    - Labels: "DPO advice", "DPO", "NDA expires on", "BCDR notes", "Estimate (US$)".
    - "Decided by name", "Rule approved by name", "DPO name" and "Closed by name" are dropped when the person line above exists (kept if that person can no longer be named).
    - Free text over 80 characters is cut short at a word.
    - Also found: role grants read as the Roles screen does — "granted Vendor Approver (portal) to …" instead of "granted vendor_approver to …".

    Left as they are (say if you want them):
    - The 2 old "granted vendor_approver" rows on staging keep the internal name — fixing them needs a migration.
    - Software product links ("microsoft sql_server") and discovery-rule resource types ("aws.elb.load_balancer") still show the scanner's own keys.

    Checks: ruff/mypy clean, unit 2216 passed, grant integration tests 9 passed, activity + screen-conventions vitest pass. To be checked on staging by me in the pre-UAT pass.
assignee: steve
label:
- improvement
priority: low
task_status: review
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