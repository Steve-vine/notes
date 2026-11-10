---
id: 01M738TDP2RCFA4KACRVYF7JEV
created: 2026-11-10T17:41:45.794441Z
updated: 2026-11-10T17:43:06.574343Z
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
**Why.** The review (COM-1684..1688) judges every criterion against its points of focus (rules in COM-1682), so it needs a complete, numbered list of them.

**Where they come from:**
- **Carbide (37 criteria).** Carbide's SOC 2 framework gives the points of focus for 37 criteria: 216 points across CC2–CC9, A1 and C1.
- **The AICPA document (24 criteria).** Carbide has none for CC1.1, P1.1–P8.1 or PI1.1–PI1.5. Those come from the AICPA's *2017 Trust Services Criteria (With Revised Points of Focus – 2022)*.

**What changes:**
- Add `audit/mapping/soc2-points-of-focus.json`. It holds, for each of the 61 criteria, its points numbered (e.g. `CC6.1-03`), each with a title and the AICPA wording.
- Mark the supplemental points the AICPA flags as applying only in particular circumstances. The reviewer decides on each one rather than skipping it silently.

**Where.** `audit/` only; no app change. **Independent.**

**Done when:**
- All 61 criteria have their points of focus listed.
- The count per criterion matches the AICPA document.
- The source is recorded in `audit/README.md`.