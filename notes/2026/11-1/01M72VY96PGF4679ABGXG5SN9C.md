---
id: 01M72VY96PGF4679ABGXG5SN9C
created: 2026-11-10T13:56:40.790062Z
updated: 2026-11-10T15:37:07.746656Z
type: task
title: New library controls for what SOC 2 auditors test that Compass had no control for — conduct, whistleblowing, board oversight, performance, job descriptions, customer contracts, fraud risk, insurance, system description
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1670
sprint: s6acz3m
blocked_by:
- 01M72VY1M5PA31R98EQ62QGGBB
assignee: steve
label:
- improvement
priority: high
task_status: review
---
**Why.** The SOC 2 gap check (`audit/soc2-mapping.md` §2, 2026-11-10) found topics that A-LIGN's requests and Carbide's controls ask about but that no Compass library control covers, so evidence for them has nowhere to live in Compass.

**What changes.** New core controls, each with a statement, a "what good looks like" description, a domain and a tier, linked to **every framework they serve** (not only SOC 2), with graded mappings:
- Code of conduct / employee handbook, acknowledged by staff (CC1.1)
- Confidential whistleblowing and ethics reporting channel, with non-retaliation (CC1.1, CC2.3)
- Board or governing body oversight of security, its independence and the information it receives (CC1.2)
- Performance reviews, plus competence and training-needs assessment (CC1.4, CC1.5)
- Job descriptions with security responsibilities (CC1.3)
- Customer commitments: contracts, SLAs and DPAs where we are the processor, with a customer register (CC2.3, C1.1, P6.x)
- Fraud risk assessment (CC3.3)
- Cyber insurance considered as a risk treatment (CC9.1)
- System description of the in-scope service (CC2.2, CC2.3)
- Communicating changes in commitments or the system to customers (CC2.3)

The control wording is drafted by Claude and reviewed by Steve in the PR and on staging.

**Where.** `data/controls.csv` plus mapping rows in each relevant `data/mappings/*.csv`. The deploy-time importers add them everywhere. Data only: no migration, no API change. Stacks on the crosswalk task (same SOC 2 file).

**Done when:**
- Each control shows in the library on staging with its frameworks.
- SOC 2 CC1.1, CC1.2, CC1.4, CC2.3, CC3.3 and CC9.1 list them.
- Crosswalk, tier and count tests are green.