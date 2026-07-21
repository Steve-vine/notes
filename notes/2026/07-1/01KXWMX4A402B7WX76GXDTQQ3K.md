---
id: 01KXWMX4A402B7WX76GXDTQQ3K
created: 2026-07-19T07:36:59.972758383Z
updated: 2026-07-21T08:28:24.10722Z
type: task
title: 'Stopgap: disable the scheduled AI loops (summarise/analyse)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 122
sprint: scxrykd
assignee: steve
priority: high
task_status: done
---
**Spend relief (stopgap).** The timer-driven AI loops (`dispatch_summaries` @15m, `dispatch_analyses` @30m) still run and still spend on idle timers — the original Sprint 10 concern is mitigated (caching/tiering/ISE-109) but not eliminated. Incidents are now created deterministically from signals (ADR 0025), so the idle-timer AI is redundant.

- Add `ai_scheduled_jobs_enabled` setting (default **False**); gate both dispatchers so they no-op (human-triggered AI — diagnose/propose/chat — unaffected).
- The Obs Loop (Sprint 14) replaces these loops outright; this flag stops them until then and can be flipped back on.

Tests: dispatchers no-op when disabled. No migration.