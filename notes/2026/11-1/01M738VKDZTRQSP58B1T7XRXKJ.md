---
id: 01M738VKDZTRQSP58B1T7XRXKJ
created: 2026-11-10T17:42:24.447728Z
updated: 2026-11-10T19:20:33.816377Z
type: task
title: 'SOC 2 exact set, part 5: Processing Integrity (PI1) — one control per point of focus, so the framework is consistent even though PI is out of this audit''s scope'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1688
sprint: s6acz3m
blocked_by:
- 01M738TDP2RCFA4KACRVYF7JEV
comments:
- id: 01M73EF9RK92NN8FP74D0PD8NJ
  author: Steve Vine
  at: 2026-11-10T19:20:32.787304Z
  text: |-
    Done, merged as #1687. Part 5 of the exact set is in `audit/soc2-exact-set/part5-pi1.md`, with the data in the matching `.json`.
    - **Coverage:** 5 criteria and 19 points of focus, all assigned. None is marked not applicable.
    - **Kept:** 3 existing controls:
      - INS.22, the system description stating the service commitments;
      - INC.11, records protected against loss and deterioration;
      - KMC.5, encryption in transit.
    - **Removed:** 30 of today's 32 links. They were about code security, change, monitoring and backups, none of which makes inputs, processing or outputs complete and accurate.
    - **5 new controls proposed (G-P5-1 to G-P5-5).** The library has no processing-integrity controls:
      - published data definitions for customers;
      - defined input, processing and output specifications;
      - validating and processing inputs completely and accurately;
      - checking output and delivering it to the right recipients;
      - records of what each service received, processed, delivered and stored.

    PI is out of this year's audit scope. It's done so SOC 2 means the same for every company.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
**Why.** Processing Integrity is out of scope for the Moneypenny audit, but SOC 2 in the library is shared by every company. Leaving PI on the old rules would make its figure mean something different from the rest. It has 5 criteria, with 32 links to 26 controls today, against 19 points of focus (AICPA 2022, from COM-1683). It's lowest priority: do it last, and if time runs short it can move out of the sprint without blocking the rest.

**Method.** As in COM-1684. The output goes in `audit/soc2-exact-set.md`.

**Where.** `audit/` only. **Independent.** Blocked by COM-1683.

**Done when:**
- All 5 criteria have every point of focus assigned to one control, recorded as a gap, or recorded as not applicable with a reason.
- Every current link is either kept or listed for removal with a reason.