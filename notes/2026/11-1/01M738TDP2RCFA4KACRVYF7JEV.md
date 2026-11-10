---
id: 01M738TDP2RCFA4KACRVYF7JEV
created: 2026-11-10T17:41:45.794441Z
updated: 2026-11-10T17:57:14.11011Z
type: task
title: Every SOC 2 point of focus written down in audit/, numbered, so each one can be given exactly one control
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1683
sprint: s6acz3m
assignee: steve
label:
- chore
priority: high
task_status: todo
---
**Why.** The review (COM-1684..1688) judges every criterion against its points of focus (rules in COM-1682), so it needs a complete, numbered list of them. All of them are covered, not just the ones this year's auditor tests (Steve, 2026-11-10).

**Source.** The AICPA's *2017 Trust Services Criteria (With Revised Points of Focus – 2022)*, for all 61 criteria. Steve downloads it, because it's behind a free AICPA account; the path is to be confirmed. Keep the PDF out of the repo.
- Carbide's copy covers only 37 criteria and serves as a cross-check.
- The AICPA's mapping spreadsheets (TSC → NIST CSF, NIST 800-53, ISO 27001), if Steve downloads them, are noted in `audit/README.md` as cross-checks for the review.

**What changes:**
- Add `audit/mapping/soc2-points-of-focus.json`. It holds, for each of the 61 criteria, its points numbered (e.g. `CC6.1-03`), each with a title and the AICPA wording.
- Mark the supplemental points the AICPA flags as applying only in particular circumstances. They're still covered: the reviewer decides on each one rather than skipping it silently.

**Where.** `audit/` only; no app change. **Independent.**

**Done when:**
- All 61 criteria have their points of focus listed.
- The count per criterion matches the AICPA document.
- Any difference from Carbide's copy is noted.
- The source and its version are recorded in `audit/README.md`.