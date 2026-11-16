---
id: 01M7K90BZDRXS47Y697QJ9HMM8
created: 2026-11-16T22:52:51.565057Z
updated: 2026-11-16T23:59:36.531342Z
type: task
title: 'Risk and gap IDs use the standard three-letter form: R-n becomes RSK-n, G-n becomes GAP-n'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1887
sprint: s7nqsy0
comments:
- id: 01M7KCTK2KKG7F6XFVJ8YSC6DW
  author: Steve Vine
  at: 2026-11-16T23:59:36.531061Z
  text: |-
    Done — PR #1871, merged f50e35fe.
    Every risk now reads RSK-n and every gap GAP-n, with the same number as before, on the Risk and Gap registers, their pages and trails, every linked-risk/gap row, notifications and mail, exports, packs, the SoA and in Polaris. New ones carry on the count as RSK-(next) / GAP-(next).
    The old form still finds them: R-12 or G-40 typed into search, the Gap register's search box or a link picker, given to Polaris, or put in the address (/risks/R-12, /gaps/G-40) opens RSK-12 / GAP-40, and the page settles on its own address.
    Activity lines, comments, gap text and packs already produced keep the wording they were written with.
    New ADR 0157 "every reference is three letters, a dash and a number" records the rule and has a table each later rename adds a row to.
    Assumptions: no migration — numbers are unique across companies, so an old reference is resolved from its prefix and nothing is stored. The one-off rules→workflows comparison tool keeps G-n so old snapshots still compare.
    To check on staging: a few risks and gaps in two companies read RSK-/GAP- with their old numbers; search "R-<n>" and "G-<n>"; open /risks/R-<n>. Switch-over check run read-only on staging: every risk and gap number is unique (91/91, 116/116), so every old ID resolves to exactly one. The same query should be run on a copy of production before release.
assignee: steve
priority: medium
task_status: active
---
From Steve's testing of round 2 (staging 43d03f09). Steve: "there are a couple of areas that have a different format, risks (R-) and gaps (G-). Change these to RSK- and GAP-."

**Behaviour** (assumptions decided here, not by Steve; the same approach as COM-1886)
- **Numbers are kept.** R-12 becomes **RSK-12**, and G-40 becomes **GAP-40**. The counters carry on from where they are, so nobody learns new numbers.
- **The new form shows everywhere an ID is shown:**
  - the Risk register and Gap register;
  - risk and gap pages, and their headers and trails;
  - every place that links one: a control's gaps, a risk's linked gaps and controls, vendor, vulnerability and inventory risks, incident and audit corrective actions, audit findings, Continuity and Initiatives;
  - notifications and mail;
  - exports (CSV), audit packs and printed reports produced from now on;
  - the Statement of Applicability and overview reports;
  - Polaris's tools, answers and MCP instructions, and the Copilot areas.
- **Old IDs keep working:**
  - R-n or G-n typed into the address, searched for, or given to Polaris finds RSK-n or GAP-n.
  - Old links redirect.
  - Activity lines, comments and documents written before the change keep their wording, so free text isn't rewritten.
  - Packs and exports already produced stay as they were.
- **Sorting** by ID is unchanged: still by number.

**Done when**
- On staging, every risk reads RSK-n and every gap GAP-n, with its old number, in every company.
- R-n and G-n still resolve in the address, in search and through Polaris.
- New risks and gaps are numbered RSK-(next) and GAP-(next).
- An ADR note records the two new prefixes and old IDs resolving. Use whichever ADR holds reference numbering for risks and gaps; if none states it, write a short new ADR on "every reference is three letters, a dash and a number", which COM-1886 and any later renames follow too.
- The switch-over is checked on a copy of production data before release. The check: every risk and gap keeps a unique ID, and every old ID resolves to exactly one.
- Tests cover:
  - the formatting;
  - old IDs resolving (address, search, Polaris);
  - a new risk and a new gap;
  - an export;
  - the e2e and Browser smoke selectors that read R- or G- IDs.

**Where** (for the builder): models/risk.py (`RISK_REF_PREFIX`), models/gap.py (`GAP_REF_PREFIX`), the route or search that resolves an ID, frontend pages and lists, assistant/tools and MCP instructions, mail templates, audit pack and export builders, app/e2e. Whether it needs a migration (only if old IDs need storing to resolve them) is the builder's call. It goes with COM-1886 (check IDs).