---
id: 01M6G8YEH8K2SEJTRRX2Z6NJ26
created: 2026-11-03T08:38:23.52801Z
updated: 2026-11-03T10:25:02.932502Z
type: task
title: 'CISA advisories can''t be read: cisa.gov refuses Compass''s requests'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1537
sprint: s6xh9g1
comments:
- id: 01M6GF1QYMCGHQJJZFNNZ1B1MB
  author: Steve Vine
  at: 2026-11-03T10:25:02.932387Z
  text: 'Steve chose the recommendation (2026-11-03). Option 1: read CISA''s ICS advisories from CISA''s own CSAF repository. Option 3 in the meantime: the blocked cybersecurity-alerts feed is switched off by default, with the reason on its Sources row. Starts after COM-1536.'
assignee: steve
priority: medium
task_status: active
---
1537Found in the sprint 102 pre-UAT (2026-11-03). Needs Steve's call.

## What people see

The **CISA advisories** row on Sources says "The source refused the request (403)" and has read nothing. CISA's site turns away automated requests to its advisory feeds from staging, although the known-exploited list (a JSON file on the same site) reads fine. NCSC and the vendor sources are unaffected.

Compass won't present itself as a browser to get round the block.

## Options

1. **Read ICS advisories from CISA's own machine-readable repository** (CSAF documents CISA publishes on GitHub). These are structured, with products and versions, but cover ICS advisories only, not CISA's cybersecurity alerts.
2. Ask CISA to allow Compass's requests, or use their email subscription. That's slow and outside our control.
3. Leave it off by default with the reason on the row. Known-exploited (the most important CISA source) is unaffected.

My recommendation is 1, with 3 meanwhile.

**Chain:** independent (a reader change), unless option 1 adds a new source row.

**Done when:** the CISA row on Sources either reads, or says plainly why it's off.