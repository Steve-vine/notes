---
id: 01KYWAEW02QBGD2S1ZTPAG5498
created: 2026-07-31T14:50:08.770173Z
updated: 2026-08-06T07:28:35.423935Z
type: task
title: 'Docs: Getting started — introduction'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 423
order: 0.03125
sprint: sp3en5k
comments:
- id: 01KYWAXX0M4G41N3PVY3WYWZX7
  author: Steve Vine
  at: 2026-07-31T14:58:21.332773Z
  text: |-
    Done on feature/ise-423-docs-introduction — PR #18, left OPEN for review.

    Full introduction page: the three problems (fragmentation / toil / governance) framed as an operator meets them; who it is for; the four behavioural principles from the product vision (read fast act deliberately, AI proposes policy disposes, evidence over vibes, one contract) including the explicit "no mode in which AI mutates a sensitive system without a human approval on record"; a What-you-get table touring all ten surfaces (Overview, Estate, Incidents, Approvals, Dashboards, Tags, Events, Assist, Agent runs, Audit log) from the UI brief; the non-goals (not a SIEM / ITSM / vendor-console replacement / autonomous ops); next steps into installation, core loop, integrations. Build/lint/format green.
assignee: steve
label: null
priority: medium
task_status: done
---
Replace the stub at `src/content/docs/getting-started/introduction.md` with real content: what ISE is and the problem it solves (fragmentation, toil, governance), who it is for (expert infrastructure operators), the read-fast/act-deliberately principle, a short tour of the main screens, and clear next steps into installation and the core loop.

Ground in `../ise/docs/briefs/product-vision.md`; operator audience, released capability only.