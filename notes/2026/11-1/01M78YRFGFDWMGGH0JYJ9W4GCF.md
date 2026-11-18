---
id: 01M78YRFGFDWMGGH0JYJ9W4GCF
created: 2026-11-12T22:41:22.959784Z
updated: 2026-11-18T10:41:09.686902Z
type: task
title: Get Moneypenny's written position on Compass IP before any public release
project: 01M5DGVQF9WDNP89TXCARSYJ97
number: 17
due: 2027-03-31
sprint: spxznkf
comments:
- id: 01M7Q3FBP61KG79J2HZY6TZK9P
  author: Steve Vine
  at: 2026-11-18T10:33:09.061972Z
  text: '18 Nov 2026: contract read (reference/moneypenny-contract-2019.pdf). It has no IP clause, so s.11(2) CDPA default applies and the "course of employment" test decides. Facts weigh towards Moneypenny: repo in the Moneypenny-Development GitHub org, installed in Moneypenny production, runs Moneypenny''s SOC 2. Clause 8.5(b) would require deletion of Moneypenny information on leaving. Also check for a promotion contract or variation letter that may add IP terms. Plan for assignment-plus-licence-back or licence-to-commercialise rather than a bare acknowledgement. See memo "Employment contract review against the ten-year plan".'
- id: 01M7Q3Y11PGBSJP26A817XMNXJ
  author: Steve Vine
  at: 2026-11-18T10:41:09.68502Z
  text: 'Correction, 18 Nov 2026: the earlier comment overstated it. s.11(2) only covers work made "in the course of employment", which means work of the kind Steve is paid to do, not anything in his field (Noah v Shuba, Stevenson Jordan). The Penhallurick employee lost because the software was the central task he was paid for and he had signed an assignment. Compass is nearer the line than a hobby because it does Steve''s own job and Moneypenny runs it in production, but the outcome turns on facts not yet written down: first commit date and location, share done in working hours, other contributors, whether anyone asked for it, whether the role includes building tooling. Establish those first; if they favour Steve, the letter asks Moneypenny to confirm Compass is a personal project used under licence, not to hand over IP.'
assignee: steve
category:
- career
priority: urgent
scope:
- personal
task_status: todo
---
Hard gate for the whole plan. s.11(2) CDPA 1988 makes the employer first owner of work made in the course of employment; Penhallurick v MD5 [2021] EWHC 293 (IPEC) held code written at home, in own time, on own kit still belonged to the employer because it fell within the job. Steve's job is infrastructure and cyber security; Compass is an infrastructure and cyber-security governance platform. Steps: (1) gather the facts: when written, on what equipment, any Moneypenny use, what the contract says on IP and outside work; (2) one hour with an IP/employment solicitor (£500–£1,500); (3) ask Moneypenny for a written acknowledgement that Steve owns it, or an assignment, or a licence-back with the right to commercialise; (4) record the outcome in a memo. Do not publish, licence or build a company on Compass until done.