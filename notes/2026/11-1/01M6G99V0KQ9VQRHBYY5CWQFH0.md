---
id: 01M6G99V0KQ9VQRHBYY5CWQFH0
created: 2026-11-03T08:44:36.755594Z
updated: 2026-11-03T08:44:40.734122Z
type: task
title: Polaris's "anything new that affects us?" puts a High above a Critical
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1539
sprint: s6xh9g1
assignee: steve
priority: medium
task_status: active
---
Found in the sprint 102 pre-UAT (2026-11-03), checking COM-1526.

## What people see

Asked "anything new this week that affects us?", Polaris listed a High item scored 9.0 before Critical items scored 8.8. COM-1526 says most urgent first: known exploited, then severity, then score.

## Fix

Order by known exploited, then severity, then score.

**Cause (technical):** `security_feed_whats_new` re-sorted the page by `(not known_exploited, -cvss_score)` after fetching it by severity, so severity was lost.

**Chain:** independent (assistant tool only).

**Done when:** a test puts a Critical 8.8 above a High 9.0, and a known-exploited Medium above both.