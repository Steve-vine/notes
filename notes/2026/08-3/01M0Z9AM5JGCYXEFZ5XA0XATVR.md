---
id: 01M0Z9AM5JGCYXEFZ5XA0XATVR
created: 2026-08-26T14:59:28.050217Z
updated: 2026-09-01T13:55:52.015304Z
type: task
title: The domain list becomes 23, and Identity splits into Identity Management and Access Control
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 423
sprint: s8cjs5n
blocked_by:
- 01M0Z97CSYY5PCWNAXCXVM05XX
comments:
- id: 01M10E6KCJ7YGQ0EM92HKCB0JC
  author: Steve Vine
  at: 2026-08-27T01:43:53.490177Z
  text: |-
    Done — PR #426.

    Thirty-five domains become 23, and every domain now sits under one of the six NIST CSF functions — Govern, Identify, Protect, Detect, Respond, Recover — so the domain view and the CSF view answer the same question.

    Identity splits properly: Identity Management holds who someone is and how they prove it, Access Control holds what they may reach and who approved it. Those were one domain, and the two halves have different owners and different evidence.

    The ten domains holding four controls or fewer are absorbed into the domain they belong to. 203 controls change ref as a result — and that is exactly why COM-417 landed first. Every one of them keeps its immutable key, so the crosswalk and every assessment follow the control rather than the number, and each shows "was ACC.8" on its page.

    Deviation worth flagging: the migration's slugs had to be realigned in eleven places. The seed derives a slug from the domain name ("Compliance & Internal Audit" gives compliance-internal-audit), and the brief's slugs were written by hand and did not match. The derived form wins.
assignee: steve
label:
- feature
priority: urgent
task_status: done
---
Thirty-five domains for 269 controls, ten of which hold four or fewer: Capacity
Management (2), Data Retention and Disposal (2), IT Acceptable Use (2), Wireless
Communication (2), BYOD (3), Removable Media (3), Internal Audit (4), Patch
Management (4), Technology Risk Management (4), Equipment Handling (4). Together
they hold 11% of the controls and a third of the navigation.

The list is shaped like one organisation's policy index rather than a risk
taxonomy — which is why there is a domain for wireless and none for people, and
why the nearest thing to cloud is called "Data Centre Architecture Standards".

## The new list

Organised on the NIST CSF 2.0 functions — the same spine CIS adopted in v8.1, so
the domain view and the CIS view answer the same question.

**Govern** — Information Security Governance `INS` · Technology Risk Management
`RIM` · Compliance & Internal Audit `INA` · **People Security `PEO`** (new) ·
Supply Chain & Third Party `VEM` · Security Awareness & Training `SEA`

**Identify** — Asset & Configuration Management `ASM` · Information
Classification `INC` · Privacy & Personal Data `PDH` · Threat & Vulnerability
Management `VUM`

**Protect** — **Identity Management `IDM`** (new, from the split) · Access
Control `ACC` · Cryptography & Key Management `KMC` · Endpoint & Mobile Security
`END` · Network & Remote Access `NES` · **Cloud & Infrastructure Security `CLD`**
(reframed from Data Centre Architecture) · Secure Development `SOD` · Change &
Release Management `CHM` · Physical & Environmental Security `PES` · Threat
Protection `THP`

**Detect** — Logging, Monitoring & Detection `EVM`

**Respond** — Incident Management `IMA`

**Recover** — Business Continuity & Backup `BCR`

## The merges

Fourteen domains fold into survivors, keeping every control: BYOD, Mobile Device
Management and Removable Media → Endpoint. Wireless and Remote Access → Network.
Data Backup → Business Continuity. Data Retention → Information Classification.
Equipment Handling and Workspace Security → Physical. External Network Equipment
→ Network. Patch Management → Threat & Vulnerability. User Credentials →
Identity Management. Capacity → Logging & Monitoring. Acceptable Use →
Governance.

## The Identity split

Access Control plus User Credentials is 33 controls after the new ones land —
the largest domain by some margin, and really two things:

- **Identity Management** — who exists and how they prove it. Accounts,
  credentials, the directory, joiner and leaver provisioning, service and machine
  identities, authentication strength. Roughly 19.
- **Access Control** — what an identity may reach. Authorisation, least
  privilege, privileged rights, segregation of duties, recertification,
  restriction to source code and privileged utilities. Roughly 14.

The split is worth making because they are assessed by different people and
evidenced differently — identity by whoever runs the directory, access by the
asset owner.

## What changes for the reader

Twenty-three domains, each with a function, none with fewer than five controls.

**A domain has at least one policy, not exactly one.** The old rule was a
convention created by the seed, not something the model enforces —
`content_items.domain_id` is a plain nullable FK with no unique constraint, and
there are already five content types. Keeping it as a **floor** is the part worth
having: every control gets a document home, every policy an owner and a review
cycle, and "show me the policy governing this control" keeps one answer.

Dropping it as a **ceiling** means the BYOD, Mobile Device and Removable Media
policies **do not have to merge**. They can sit under Endpoint Security
alongside the build standards and runbooks that domain will want. Merge them if
they read better merged — not because the model demands it. That removes what
would otherwise have been the largest hidden cost of this task.

This also matches ISO 27002's own guidance on `A.5.1`: an information security
policy plus *topic-specific* policies. Cross-cutting topics — AI, remote working,
data protection — can have a policy without owning a domain.

## The orphan

**A policy with no domain is currently silent, and that is a defect.** The
Artificial Intelligence Policy is the only one of 36 with `domain_id` null: it
appears under no domain, counts toward no coverage, and nothing anywhere flags
it. It is published, so it looks fine.

Fix it here — either require a domain on publish, or surface domainless content
somewhere it will be seen. Do not leave it as it is. (The AI Policy's own
resolution is COM-430, which gives it a standard to answer to; this task is about
making sure the next orphan is not invisible for a year.)

## Implementation

- Depends on the control identity ADR. Domains gain `function` (the six CSF
  functions) as an enum with a display order.
- `domains.code` is `String(3)` and unique — `END`, `IDM`, `CLD` are new codes,
  `DBC` and `CRD` retire. Retiring a code while controls still carry its ref
  prefix is the ordering trap here: renumber inside the same migration.
- Merged domains are **not** deleted — they are soft-deleted after their controls
  move, so history and the audit trail resolve (ADR 0023).
- Content: re-point every policy at its surviving domain before the merge, or the
  playbook loses its anchors. With 1:many allowed this is a re-point, not a
  rewrite — no policy bodies need combining unless someone chooses to.
- Display order follows the function order, not alphabetical.

Tests: every control has a domain after the merge; no domain has zero controls;
a domain may hold several policies and several content types; soft-deleted
domains still resolve in the audit trail; content links survive; domainless
content is discoverable.
