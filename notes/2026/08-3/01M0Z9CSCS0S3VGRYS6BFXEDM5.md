---
id: 01M0Z9CSCS0S3VGRYS6BFXEDM5
created: 2026-08-26T15:00:38.93777Z
updated: 2026-08-26T15:00:38.93777Z
type: task
title: 'New controls: Protect — identity, cloud and the software you ship'
label: feature
assignee: steve
priority: high
task_status: backlog
company: moneypenny
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 426
---
Twenty-eight new controls across five domains, plus whatever the crosswalk
rebuild adds to cryptography.

Three of these areas are where the 2019 vintage shows most: identity predates
federation and machine identities, there is no cloud at all, and secure
development has seven numbering holes where controls used to be.

## What to write

**Identity Management `IDM` — 5 new**
Identity proofing before a credential is issued · federation and the protection
of identity assertions (SSO, SAML/OIDC, token handling) · machine and service
identity inventory, ownership and rotation · secrets management — where
credentials live, who can read them, how they rotate · break-glass and emergency
access: who, how, and what happens afterwards.

**Access Control `ACC` — 4 new**
Segregation of duties as an organisational control, with conflict analysis —
today the only SoD control is `CHM.7`, build versus deploy · least privilege
stated as a principle with a review · role change (the "mover" nobody handles —
joiners and leavers exist, movers do not) · privileged access management with
time-bound elevation.

Also add restriction of access to source code and to privileged utility
programs, and information access restriction by classification — ISO `A.8.4`,
`A.8.18` and `A.8.3`, all currently unmapped. Fold these into the four above if
they read better together; the count is a guide, not a target.

**Cloud & Infrastructure Security `CLD` — 8 new, effectively a new domain**
Security requirements for cloud services and the shared responsibility model ·
tenant and SaaS configuration baselines · cloud entitlement and permission
review · infrastructure-as-code scanned before deployment · container and
orchestration platform hardening · cloud audit logging enabled and collected
centrally · continuous cloud posture monitoring · discovery of unsanctioned SaaS.

Note the reframe: the domain was "Data Centre Architecture Standards" and keeps
its nine existing controls, which are about production environment design and
still valid. This adds the half that has been missing since the library was
written.

**Secure Development `SOD` — 9 new**
Peer code review before merge · dependency scanning and a software bill of
materials · secrets detection in source and history · hardened build templates
for application infrastructure · vetted components for security functions rather
than hand-rolled · CI/CD pipeline integrity and artefact provenance ·
authenticity and integrity of software verified before acquisition and use ·
public-facing web application protection · test data masked or synthetic (extends
`SOD.7`, which covers the obfuscated dataset but not masking as a technique).

**Physical & Environmental Security `PES` — 2 new**
Securing offices, rooms and facilities, including working in secure areas ·
visitor authorisation and logging, and tamper checks on point-of-interaction
devices where cards are taken.

## Notes

- **Cryptography will grow here too.** `KMC` shows no new controls because no
  cryptography requirement is fully unmapped — but ISO `A.8.24` is satisfied today
  by `KMC.3` alone, which is key lifetime. When the crosswalk rebuild reaches it,
  expect a cryptography policy control and an approved-algorithms-and-strengths
  control. Add them here if they surface before this task ships.
- **Cyber Essentials Danzell lands on this domain.** Cloud services are now
  explicitly in scope with mandatory MFA — make sure the cloud controls and the
  identity controls between them answer that cleanly, because it is an auto-fail.

Depends on the control identity ADR and the domain consolidation. Map as you
write.
