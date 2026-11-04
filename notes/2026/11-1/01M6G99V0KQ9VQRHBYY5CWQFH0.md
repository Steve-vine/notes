---
id: 01M6G99V0KQ9VQRHBYY5CWQFH0
created: 2026-11-03T08:44:36.755594Z
updated: 2026-11-04T07:45:34.007546Z
type: task
title: Polaris's "anything new that affects us?" puts a High above a Critical
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1539
sprint: s6xh9g1
comments:
- id: 01M6GAZQHF599A7JEC1D4SVS4S
  author: Steve Vine
  at: 2026-11-03T09:14:02.671041Z
  text: |-
    Done: PR #1551 merged (cae18eb5), deployed to staging at 09:06.

    "What's new" now orders by known exploited, then severity, then score.

    Pre-UAT (staging, E2E Test Company): **Passed**. security_feed_whats_new for the last 7 days now lists Critical 8.8, Critical 8.8, Critical 8.8, then High 9.0, High 8.8, … (before the fix, High 9.0 came first). None of this week's matches is known exploited, so the first rule had nothing to show here; the unit test covers it.
assignee: steve
label: null
priority: medium
---
Found in the sprint 102 pre-UAT (2026-11-03), checking COM-1526.

## What people see

Asked "anything new this week that affects us?", Polaris listed a High item scored 9.0 before Critical items scored 8.8. COM-1526 says most urgent first: known exploited, then severity, then score.

## Fix

Order by known exploited, then severity, then score.

**Cause (technical):** `security_feed_whats_new` re-sorted the page by `(not known_exploited, -cvss_score)` after fetching it by severity, so severity was lost.

**Chain:** independent (assistant tool only).

**Done when:** a test puts a Critical 8.8 above a High 9.0, and a known-exploited Medium above both.