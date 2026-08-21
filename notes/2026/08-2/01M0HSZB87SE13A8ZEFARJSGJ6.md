---
id: 01M0HSZB87SE13A8ZEFARJSGJ6
created: 2026-08-21T09:21:02.215397Z
updated: 2026-08-21T09:22:17.444667Z
type: task
title: Investigate uplink DNS failures from CI; add node-local DNS cache
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 328
sprint: sspwpgk
assignee: steve
label:
- chore
priority: medium
task_status: todo
---
Repeated `getaddrinfo EAI_AGAIN` (nodejs.org, files.pythonhosted.org) from runner pods under load — cluster DNS or NAT wobbling, same neighbourhood as the historical MTU issue. Diagnose CoreDNS/forwarder behaviour under CI load; consider NodeLocal DNSCache on g5. Largely mitigated once the runner image bakes its toolchain, but the uplink itself should be steady.