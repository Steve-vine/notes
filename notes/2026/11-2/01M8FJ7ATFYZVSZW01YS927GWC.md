---
id: 01M8FJ7ATFYZVSZW01YS927GWC
created: 2026-11-27T22:32:41.039196Z
updated: 2026-11-27T22:34:21.602976Z
type: task
title: 'Windows exact matching: each Windows server''s full build is compared with Microsoft''s fixed build for every security update, so a server lists exactly which fixes it''s missing'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2213
assignee: steve
label:
- feature
priority: high
task_status: todo
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