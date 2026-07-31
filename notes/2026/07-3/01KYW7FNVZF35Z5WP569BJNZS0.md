---
id: 01KYW7FNVZF35Z5WP569BJNZS0
created: 2026-07-31T13:58:09.535406Z
updated: 2026-07-31T13:58:40.310385Z
type: task
title: 'Integration docs: Microsoft 365'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 417
sprint: sp3en5k
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Replace the M365 stub (`src/content/docs/integrations/m365.md`) with full operator documentation:

- **Capabilities** — read-only integration: M365 services in the estate via service health overviews; Service Health issues as stateful alert signals (resolve when Microsoft resolves them); licensing on the System card with detectors for pool ≥90% consumed and SKU warning/suspended; evidence (service health issue incl. post-incident report, Message Center, licence detail). No actions — deliberately an empty catalogue.
- **Setup** — dedicated read app registration (standalone — works without the Entra ID integration; opportunistic joins if both configured); ServiceHealth.Read.All + Organization.Read.All, admin consent.
- **Examples** — an Exchange service incident arriving as a signal; licence-pool exhaustion surfacing as an observation.

Ground in ADR 0066; rewrite for operators, released capability only.