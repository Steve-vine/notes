---
id: 01M7K90BZDRXS47Y697QJ9HMM8
created: 2026-11-16T22:52:51.565057Z
updated: 2026-11-17T10:30:46.830414Z
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
- id: 01M7MGY9SEZSAPDYCA6WYB07DR
  author: Steve Vine
  at: 2026-11-17T10:30:46.830251Z
  text: |-
    Pre-UAT on staging 44d15b9a — Passed
    - Every risk reads RSK-n and every gap GAP-n, old numbers kept: Passed. As E2E Admin A in E2E Test Company: the Risk register (RSK-97…RSK-17) and Gap register (GAP-125, GAP-124, GAP-43…) list only the new form. So do the risk and gap pages and their trails ("Risks › RSK-96 · …"), RSK-96's linked gap GAP-124 and GAP-124's linked RSK-96, the INS.10 assessment's gaps, Initiative INI-1's Gaps, Risks and Actions tabs (GAP-36…, RSK-42/43), the SoA's "Risks treated" column (RSK-42), and the risk-register CSV and PDF and the gap-register CSV from Reports. None of them shows an R-/G- reference. Other companies, checked read-only through Polaris: Test Company reads RSK-6, RSK-47, RSK-22, and Demo reads GAP-21, GAP-22, GAP-24.
    - R-n / G-n still resolve: Passed. Admin A and the Viewer both tried the address: /risks/R-96 opens RSK-96 and /gaps/G-43 opens GAP-43, and each page settles on its own address. The top search bar finds RSK-96 for "R-96" and GAP-43 for "G-43" (one result each). The Gap register's own search box finds just GAP-43 for "G-43". Polaris finds RSK-96 for get_risk "R-96", GAP-43 for get_gap "G-43", and the right record for search "R-96" and "G-43".
    - New risk and gap are numbered RSK-(next) / GAP-(next): Passed. Admin A created "E2E pre-UAT COM-1887 risk", which became RSK-97, and "E2E pre-UAT COM-1887 gap", which became GAP-125. Both appear in the registers, the CSV and a search for "RSK-97".
    - ADR: Passed. ADR 0157 "every reference is three letters, a dash and a number" has the R-→RSK- and G-→GAP- rows.
    - Switch-over check on a copy of production: Couldn't check on staging, because it's a step before release. Steve or the builder should run the uniqueness query on the production copy before release.
    - Tests: PR #1871 changes 17 test files. Nothing in app/e2e reads a risk or gap ID, so no Browser-smoke selector needed changing.
    - Not checked: notifications and mail.
    Screenshots: ~/compass-uat/s7nqsy0/COM-1887/ (the exports are saved there too)
assignee: steve
priority: medium
task_status: review
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