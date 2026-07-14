---
id: 01KXGWWGCFD44EMRW6QDEVH7DR
created: 2026-07-14T18:05:34.991205833Z
updated: 2026-07-14T18:48:17.6475Z
type: task
title: Decide the future of Markdown (templated) authoring
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 138
label: null
order: 1.0
---
Split from <issue id="6775eddc-ed1e-46f6-8320-100b0cca996c" href="https://linear.app/stevevine/issue/DEV-760/content-library-follow-ups-review-record-on-all-pdfs-release-tracking">DEV-760</issue> — a **decision**, not a build.

---

## Decision (2026-07-03): **Keep templated authoring first-class.**

All four content kinds remain peers. ADRs 0030 (templated pipeline) and 0035 (kind taxonomy) stand unchanged — no superseding ADR needed since nothing changes. Rationale for not demoting/retiring now: the replacement kinds (managed/uploaded) have zero real usage while the M365 tenant is unwired, the carrying cost of templated is low (~900 stable/tested lines), and retirement is a one-way door that can be reconsidered later with real data if the conceptual surface ever becomes a problem.

---

**Decision brief that informed it (2026-07-03):**

**Evidence**

* All 36 real content items are templated *shells* (placeholder bodies from the M2 policy import); no policy was ever re-authored in the pipeline — it has provided structure + governance, not writing.
* Managed/uploaded also have zero usage (tenant not wired), so no data on the replacement either.
* Carrying cost of templated is low; the real cost is conceptual surface (4 kinds, 3 content tabs).
* Retiring would not remove LibreOffice (uploaded Office→PDF needs it) nor pypdf/ReportLab (provenance).

**Options considered:** keep first-class · demote (create modal defaults to Managed) · retire (migrate shells → managed, delete machinery, supersede ADR 0030) · defer with criteria. **Chosen: keep.**

---
*Migrated from Linear [DEV-784](https://linear.app/stevevine/issue/DEV-784/decide-the-future-of-markdown-templated-authoring) · created 2026-07-02 · completed 2026-07-03*  
*Related to (Linear): DEV-760*