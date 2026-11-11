---
id: 01M73QE9TJMFFNE7J3AVNAYR5B
created: 2026-11-10T21:57:17.266215Z
updated: 2026-11-11T03:09:17.069871Z
type: task
title: Polaris and assistants use the new capabilities, and say exactly which capability is missing when a service can't be described — a list Steve can read to decide what to build next
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1712
sprint: sj4f1kj
blocked_by:
- 01M73QC5JFEQX7MZGKRC9RF4N6
- 01M73QCHFKHNH35P0021RQ8YQT
- 01M73QCWRE14AT6SKFVHMRFSHK
- 01M73QD7FW4QGMCMGM1R24RAG9
- 01M73QDH6S86WH4VMHAXD2DJ98
- 01M73QAGXCRZFKEJN7CNVVMYPH
- 01M73QAYASWGP8BW1R931RKWXW
comments:
- id: 01M747ZNTYZ4RWJ3ZM5C9SB0Q3
  author: Steve Vine
  at: 2026-11-11T02:46:23.838689Z
  text: |-
    Merged to main in #1711.

    What it does:
    - Polaris's three jobs (define a service, design a check, set up a feed) and the assistant's service and feed tools now get one shared description of what Compass can express: follow-on reads, choosing items (newest or oldest), a read's own limits, "only what changed", parts for several companies, scope, and App sign-in. Their proposals are checked by the same rules as the form. A define proposal can use App sign-in, and the "Add with Polaris" screen carries it into the form. A feed proposal can carry parts and scope. A check can choose items and set limits. The define job is told which internal addresses are approved.
    - When something can't be described, Polaris names the missing capability in general terms, never "service X needs…".
    - Admin ▸ Polaris has a new card at the bottom, "What Compass couldn't describe". Every such answer is grouped by what's missing, with how many times, for which services, sample reasons and when it last came up. It's a list to read, not an action.
    - Also fixed: an assistant changing a feed no longer drops its parts or scope, and an assistant changing a service no longer drops its App sign-in or CA certificate.

    Tests: test_polaris_capabilities.py (integration, a scripted model: the contracts, App sign-in kept and refused, a proposal with choose, limits and parts going all the way to a feed waiting for approval, grouping), CouldntDescribePanel test.

    For Steve on staging: needs Polaris's AI provider. I can check the card renders. A real "can't describe" entry appears after a Polaris run.
- id: 01M7499JWDGRYADZH01MRCTZ8S
  author: Steve Vine
  at: 2026-11-11T03:09:17.069577Z
  text: 'Pre-UAT on staging (74c7156f), as E2E Admin A: Admin ▸ Polaris shows the new "What Compass couldn''t describe" card, with "Nothing yet: Polaris has described everything it was asked to." **Couldn''t check** Polaris proposing the new settings: that needs a real Polaris run, which uses the AI provider and spends. Steve, try "Ask Polaris to set up a feed" on a service and check the proposal, or the card if it can''t.'
assignee: steve
label:
- feature
priority: medium
task_status: review
---
ADR 0146 (COM-1705). The capabilities in this sprint only help if Polaris's define and design jobs, and the assistant tools, can propose them.

**Chain:** on the chain — API

## What the person sees

- Polaris's **define a service**, **design a check** and **set up a feed** jobs (ADR 0142 §9, COM-1702) can propose:
  - follow-on reads (COM-1706);
  - App sign-in settings (COM-1707);
  - parts for several companies (COM-1708);
  - per-read limits and incremental reads (COM-1709);
  - run choosing and scope (COM-1710);
  - an approved internal address, if COM-1711 lands.
- The assistant tools that set up a service or a feed (ADR 0142 COM-1659, COM-1703) accept and validate the same settings.
- **When something can't be described,** Polaris's answer names the missing capability in general terms, e.g. "the service only answers in XML", "results must be requested with a POST and collected later", or "paging by a token in a response header". It never says "GitHub needs…".
- **Admin ▸ Polaris ▸ What Compass couldn't describe:** every such answer, grouped by capability, with how often it came up and for which services. It's a list for Steve, not an action.

## Done when

- The job contracts and tool schemas include each new capability, and are validated by the same schema as the form.
- Tested with a fake model: a proposal using each capability round-trips; a "can't describe" answer is stored and grouped.
- The pinned tool tests are updated. No service name in code (COM-1696).