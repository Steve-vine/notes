---
id: 01M73QDZ1J73H29KX8BJ5VZGVN
created: 2026-11-10T21:57:06.226907Z
updated: 2026-11-10T22:31:21.414834Z
type: task
title: 'Named internal addresses: an administrator approves specific internal hosts a Collection service may reach, with its own CA certificate — cloud metadata, loopback and Compass''s own network always refused'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1711
sprint: sj4f1kj
blocked_by:
- 01M73QBT1QP9E6549CQ1C4XX5Y
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
ADR 0146 §8 (COM-1705). **Steve agreed on 2026-11-10** (comment on COM-1705), as proposed below.

Nessus Expert sits on the internal network with a self-signed certificate. Until now ADR 0142 §8 has refused every private address, deliberately (see the reasons below).

**Chain:** on the chain — migration + API

## What the person sees

- **Admin ▸ Integrations ▸ Internal addresses:** a short list of approved internal hosts and ports (e.g. `nessus.internal:8834`), each with who approved it, when and why.
  - Adding to the list needs **Manage configuration**, a right separate from defining Collection services, so the person who writes a definition can't also open the door.
  - Every change is recorded in Activity.
- A Collection service whose address is on the list may be saved and read. Any other internal address is refused, as today, with "ask an administrator to approve this internal address".
- **Always refused, whatever the list says:**
  - the cloud metadata service (169.254.169.254 and its IPv6 form) and all link-local and loopback addresses;
  - Compass's own Kubernetes service and pod ranges, its database and its cache.

  These come from deployment settings, not the screen.
- Pinning stays: the address is resolved once and the connection goes to it, and redirects are still not followed.
- **CA certificate:** a service can carry a PEM certificate to trust for its own address only (Nessus's self-signed certificate). The public CAs still apply to everything else.
- **Polaris and assistants** can't add internal addresses. They can propose a service at an approved one.

## Done when

- Tested:
  - an approved address works;
  - an unapproved private one is refused at save and at read;
  - each always-refused range is refused even when listed;
  - DNS answering a different address on the second lookup can't redirect;
  - a custom CA is trusted for its host only;
  - adding needs Manage configuration.
- The ADR records the reasons for the original rule and why this keeps them.

## Why the rule exists (for the ADR)

A Collection service is defined on screen, and its answers are stored and shown, as captures to people and as samples to Polaris. Without the rule, anyone allowed to define a service could point Compass at its own insides, then read the answer back as evidence:

- the cloud metadata service, which hands out Compass's own cloud credentials;
- the database, the cache, the Kubernetes API, or internal admin pages.

Polaris also defines services from web pages it reads, so a poisoned documentation page could steer it to an internal address too. This design keeps every one of those doors shut, and opens only addresses an administrator has named.