---
id: 01M6G8YEH8K2SEJTRRX2Z6NJ26
created: 2026-11-03T08:38:23.52801Z
updated: 2026-11-04T07:46:09.208173Z
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
- id: 01M6GHM7EP2410TM04DXE5W99X
  author: Steve Vine
  at: 2026-11-03T11:10:05.782303Z
  text: |-
    Done: PR #1554 merged (4e18c3f2), deployed to staging at 11:00.

    What people see on Sources:
    - **CISA CSAF advisories** (new, on by default): CISA's ICS advisories and the vulnerability advisories CISA coordinates, read from CISA's own CSAF repository on GitHub every 3 hours. The first read takes 12 months. Each advisory is its own item, with products under their own vendors, versions and fixes, linked to its CVEs and to CISA's page.
    - **CISA advisories** (the cybersecurity alerts) reads "Unavailable" with the reason: "cisa.gov turns away Compass's requests for these alerts, so they can't be read. CISA's ICS and vulnerability advisories come from CISA CSAF advisories, and CISA known exploited is unaffected." It fetches nothing, and it's off by default on new installs.
    - CISA's campaign advisories (the "AA" series) aren't in that repository, as discussed.

    Pre-UAT (staging, E2E Test Company): **Passed**
    - CISA CSAF advisories finished its first read at 11:03: 4,949 items, 18 in the last 7 days.
    - ICSA-26-302-03 "Hitachi Energy CoreTec Product": Hitachi Energy · CoreTec4 and CoreTec5, "3.4.0 and earlier", "who says so: CISA CSAF advisories", a Vendor advisory link to cisa.gov, and its two CVEs under Related.
    - The CISA advisories row shows Unavailable with the reason above.

    Screenshots: ~/compass-uat/sprint-102/COM-1537/
assignee: steve
label: null
priority: medium
task_status: done
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