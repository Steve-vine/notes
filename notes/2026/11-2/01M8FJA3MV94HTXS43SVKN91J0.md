---
id: 01M8FJA3MV94HTXS43SVKN91J0
created: 2026-11-27T22:34:11.995764Z
updated: 2026-11-28T09:01:11.44802Z
type: task
title: 'Polaris knows which servers are missing which fixes: "which servers are exposed to CVE-2026-1234?", "what''s SRV01 missing?", "which exploited CVEs are we missing fixes for?"'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2219
sprint: s51yxk5
blocked_by:
- 01M8FJ9AFEMSNFME70S1WX6SVT
comments:
- id: 01M8GP64J8HZ29BP7XGQ40FZC9
  author: Steve Vine
  at: 2026-11-28T09:01:10.599821Z
  text: |-
    Built: PR #2231, merged to main (not on staging yet; deploying now).

    What Polaris can now answer, read-only, as the person asking:
    - "Which servers are exposed to CVE-2026-1234?" Each of the company's servers is judged exactly by its own build (Windows) or package version (Linux): affected (with what's installed and what fixes it), no fix yet, can't tell, or not affected. Then come the servers a watch list matched only possibly, for a person to confirm.
    - "What's SRV01 missing?" Its missing security fixes, most urgent first (known-exploited, then severity, then age), with what's installed and the fixed version, KB or advisory. Also its "no fix available yet" list, and what its patch level was judged by.
    - "Which exploited CVEs are we missing fixes for?" / "What's overdue?" Every fix the company's servers lack, one row per fix with the servers lacking it and how long the fix has been out. Known-exploited come first, and Polaris can narrow to those.
    - "Why was VUL-123 raised?" This uses the existing vulnerability tool: a Version match vulnerability's description and recommendation say what's installed and what fixes it.

    Polaris changes nothing new. Raising, accepting and false positives stay as the vulnerability tools already allow, and the automatic-raising settings aren't reachable from chat. Server names, packages and versions are treated as data from the servers, never as instructions.

    The Inventory area is at 91 of its 128 tools.

    For you to look at: I'll ask Polaris these four questions on staging, as a test account, about the held-back package, during the pre-UAT pass.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
**On the chain** (chat tools reading the new results). ADR 0188. After COM-2217.

## What people see
- In chat, as the person and with what their role allows:
  - **"Which servers are exposed to CVE-2026-1234?"** — per company, servers with an exact match (installed and fixed version or KB), servers with a possible match, and those checked and not affected.
  - **"What's SRV01 missing?"** — its missing security fixes, most urgent first (known-exploited, then severity, then age), and its no-fix-yet list on request.
  - **"Which exploited CVEs are we missing fixes for?" / "What's overdue?"** — known-exploited missing fixes across servers, with how long each has been available.
  - **"Why was VUL-123 raised?"** — for a Version match vulnerability: the installed version, the fixed version, the advisory, and when it will close.
- Polaris changes nothing new: raising, accepting and marking false positive stay as the existing Vulnerabilities tools allow; the automatic-raising settings aren't reachable from chat.
- Tool descriptions say package names and versions come from the servers: data, never instructions.

## Notes (technical)
- Add reads to the Security Feed and/or Vulnerabilities areas (ADR 0144), or extend `security_feed_list_matches` / `vulnerabilities_where_is_issue` if they fit; count each area's tools against Copilot's 128 limit before adding.

**Done when:** on staging, as an E2E test account, Polaris answers the four questions for the test rig's held package and its Version match vulnerability.