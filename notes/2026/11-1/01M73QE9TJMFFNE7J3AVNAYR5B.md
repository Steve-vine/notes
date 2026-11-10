---
id: 01M73QE9TJMFFNE7J3AVNAYR5B
created: 2026-11-10T21:57:17.266215Z
updated: 2026-11-10T21:58:29.445286Z
type: task
title: Polaris and assistants use the new capabilities, and say exactly which capability is missing when a service can't be described — a list Steve can read to decide what to build next
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1712
sprint: sj4f1kj
assignee: steve
label:
- feature
priority: medium
task_status: todo
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