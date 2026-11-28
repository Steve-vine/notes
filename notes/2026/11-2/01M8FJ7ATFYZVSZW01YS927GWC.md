---
id: 01M8FJ7ATFYZVSZW01YS927GWC
created: 2026-11-27T22:32:41.039196Z
updated: 2026-11-28T07:20:54.98199Z
type: task
title: 'Windows exact matching: each Windows server''s full build is compared with Microsoft''s fixed build for every security update, so a server lists exactly which fixes it''s missing'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2213
sprint: s51yxk5
blocked_by:
- 01M8FJ6WWYRSH35JCPA2QYF6H3
- 01M8FATYW6WHD4TY9MEYW1K252
comments:
- id: 01M8GGEH3H2CHHEX0YJCJTFPZG
  author: Steve Vine
  at: 2026-11-28T07:20:54.129072Z
  text: |-
    Built: PR #2225, merged to main (not on staging yet; it goes with the sprints' deploy).

    What's there:
    - Each Windows Server 2016, 2019, 2022 or 2025 server's full build is compared with Microsoft's fixed build for every security update. No product link is needed: the server says what it runs.
    - A server's Patch level card lists the security fixes its build is missing: "CVE-2026-21001 · Critical · exploited · KB5046616 · released 12 Nov 2026", each linking to its feed item. Otherwise it says "none missing", or "Build not known: can't tell exactly…".
    - On the Security Feed item, "Everything we run" reads "Affects us: exact match — a server's build is missing the fix". Each server shows its build and the fixed build and KB it lacks ("AST-1 SRV01 — 10.0.20348.2700 (affected; fixed in 10.0.20348.2849, KB5046616)"), or "build not known".
    - A server that already has the fix appears under "Why it doesn't match what we run": "… runs build 10.0.20348.2900, which has the fix (…): not affected, exact match."
    - When a server's build changes, its company's matches are worked out again.

    Two things differ from the task:
    - Only the ordinary Windows Server release counts, and its Server Core installation, which shares builds. Hotpatch and Azure Edition fixes have a lower revision on the same build line, so counting them would read an ordinary server as fixed when it isn't.
    - SQL Server and Exchange stay on the "possible" route. Their fixes come in two lines (GDR and CU) whose builds don't order across lines, so comparing would give wrong "not affected" answers. Say if you want them done properly as a follow-up.

    The match status still reads "Possibly affects us"; COM-2216 confirms exact matches by themselves.

    For you to look at (Couldn't check for me, no Windows server on staging): a real Windows server's Patch level and missing fixes.
assignee: steve
label:
- feature
priority: high
task_status: review
---
**On the chain** (API, possibly a table for per-server results). ADR 0188. After COM-2212, and needs the Server Agent sprint's full build (COM-2206).

## What people see
- On a Windows server's **Patch level** (COM-2206), a **Missing security fixes** list: each CVE with severity, known-exploited flag, the KB that fixes it and when Microsoft released it ("CVE-2026-21001 · Critical · exploited · KB5046616 · released 12 Nov"). Or **None missing**.
- On the Security Feed item, the server reads **Affects us — exact match** (or **Not affected — exact match**) instead of "possibly", with "build 10.0.20348.2700; fixed in 10.0.20348.2849".
- **Microsoft server products** (SQL Server, Exchange) are matched the same way when the server reports their full build; otherwise they stay on the "possible" route.
- A Windows server whose full build isn't known (some cloud servers report only the release) is never an exact match: it reads "Build not known: can't tell exactly" and stays possible.
- No vulnerabilities are raised by this task; automatic raising is COM-2216.

## Notes (technical)
- Microsoft reader (`readers/microsoft.py`) already keeps, per CVE, `details.fixes[]` = `{product, kb, fix, url, fixed_build, restart}` in `FeedItemSource.payload`, and `FeedItemAffected` rows per product with `ranges.fixed = <build>`. Use `fixed_build` per product; map a server to its Microsoft product by release (`core/security_feed/releases.py`: 2016→10.0.14393, 2019→10.0.17763, 2022→10.0.20348, 2025→10.0.26100) and edition notes (Server Core vs full installation share the build).
- Server's full build = `10.0.<build>.<UBR>` from the agent (`os_version`, COM-2205/2206). Compare with `versions.py` dotted rules: same major build, UBR ≥ fixed UBR → fixed (cumulative updates). A different major build than any fix row → not this product.
- Keep results per server per item (exact affected / exact not affected / not known), recomputed when either side changes (new feed item, new server read).
- Feeds the patch-level judgement by missing fixes in COM-2217.

**Done when:** in CI, recorded Microsoft CVRF for one month plus a server at an older and a newer UBR give "missing" and "none missing" correctly, including a fix that lists two products; on staging (no Windows server) the logic is covered by tests and Steve checks a real server (Couldn't check for me).