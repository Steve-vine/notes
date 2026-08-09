---
id: 01KZK6S5TGJP24H7GNJV7PMDK4
created: 2026-08-09T12:08:24.144019Z
updated: 2026-08-09T12:08:24.144019Z
type: task
title: Cloud VM discovery candidates have no platform — AWS and Azure never record the OS on a host entity
priority: medium
task_status: backlog
label: improvement
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 622
---
Found on the ISE-621 smoke test, 2026-08-09. Live counts:

```
arc       os_family=windows   39
entra     os_family=windows   1114
azure_vm  os_family=None      12    <-- every one
```

Every discovery candidate derived from an existing cloud ENTITY arrives with no platform. Arc and Entra are fine — they report an OS string ISE reads.

**Root cause is not the coverage layer.** `servers_coverage.collect_entity_candidates` sets `os_family: None` because there is nothing to read: neither connector records the operating system on the entity it creates.

- `aws.py` EC2 attributes: `aws_service`, `region`, `instance_id`, `instance_type`, `state`, `availability_zone`, `private_ip`, `vpc_id`
- `azure.py` VM attributes: `azure_service`, `location`, `resource_group`, `vm_size`, `power_state`, `computer_name`

Both APIs return it and both connectors drop it — AWS as `PlatformDetails` / `Platform` on the instance, Azure as `properties.storageProfile.osDisk.osType`.

**Why it matters here.** The operator has to declare the platform at Manage time for every cloud VM, and a wrong pick is the most expensive mistake this integration allows: a Linux profile on a Windows machine dials SSH at a WinRM listener and fails as `auth_refused`, which sends someone to check an account that was never the problem. ISE refuses to guess (correctly), so the cost lands on a human who also has to go and look it up.

**Why it matters beyond here.** The estate cannot currently answer "which of our VMs are Windows". That is a question worth being able to ask of a single pane of glass, and the answer is already in the payloads both connectors parse.

**Proposal**: AWS and Azure record the OS as an entity attribute during discovery; the coverage layer reads it into `os_family` the way it already reads Arc's and Entra's. Nothing else changes — candidates that still cannot say keep the current behaviour, which is to make a human choose rather than have ISE pick.

Touches two connectors outside the Servers integration, which is why it was flagged rather than folded into ISE-621.