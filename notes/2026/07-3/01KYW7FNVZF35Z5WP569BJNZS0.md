---
id: 01KYW7FNVZF35Z5WP569BJNZS0
created: 2026-07-31T13:58:09.535406Z
updated: 2026-08-05T19:02:28.615637Z
type: task
title: 'Integration docs: Microsoft 365'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 417
order: 1.0625
sprint: sp3en5k
comments:
- id: 01KYW8EZ09AMTS9TW0DY79DC5N
  author: Steve Vine
  at: 2026-07-31T14:15:14.697319Z
  text: |-
    Done on feature/ise-417-docs-m365 — PR #15, left OPEN for the PR-preview test.

    Full M365 page: read-only-by-design framing; service discovery into the estate; stateful Service Health alert signals (recover on Microsoft's isResolved, no time window); licence observations (pool ≥90%, SKU warning/suspended) with the "Microsoft raises no alarm" rationale; evidence service_health_issue (incl. post-incident report) / message_center (pull-only, never a signal) / license_detail; explicit no-actions-no-write-credential statement. Setup: dedicated app registration with ServiceHealth.Read.All + Organization.Read.All, separate from Entra ID with the operational-independence rationale, standalone with opportunistic joins. Examples: Exchange degradation→incident with advisory evidence, licence-pool exhaustion caught early. Facts from connectors/m365.py + ADR 0066. Build/lint green.
assignee: steve
label: null
priority: medium
task_status: done
---
Replace the M365 stub (`src/content/docs/integrations/m365.md`) with full operator documentation:

- **Capabilities** — read-only integration: M365 services in the estate via service health overviews; Service Health issues as stateful alert signals (resolve when Microsoft resolves them); licensing on the System card with detectors for pool ≥90% consumed and SKU warning/suspended; evidence (service health issue incl. post-incident report, Message Center, licence detail). No actions — deliberately an empty catalogue.
- **Setup** — dedicated read app registration (standalone — works without the Entra ID integration; opportunistic joins if both configured); ServiceHealth.Read.All + Organization.Read.All, admin consent.
- **Examples** — an Exchange service incident arriving as a signal; licence-pool exhaustion surfacing as an observation.

Ground in ADR 0066; rewrite for operators, released capability only.