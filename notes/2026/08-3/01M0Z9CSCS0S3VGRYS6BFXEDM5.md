---
id: 01M0Z9CSCS0S3VGRYS6BFXEDM5
created: 2026-08-26T15:00:38.93777Z
updated: 2026-08-26T16:04:04.509765Z
type: task
title: 'New controls: Protect — identity, cloud and the software you ship'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 426
sprint: s8cjs5n
blocked_by:
- 01M0Z97CSYY5PCWNAXCXVM05XX
- 01M0Z9AM5JGCYXEFZ5XA0XATVR
assignee: steve
company:
- moneypenny
label:
- feature
priority: high
task_status: backlog
---
Thirty-three new controls across six domains.

Three of these areas are where the 2019 vintage shows most: identity predates
federation and machine identities, there is no cloud at all, and secure
development has seven numbering holes where controls used to be. Cryptography is
a fourth — it looked fine only because no requirement was *fully* unmapped.

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

**Cryptography & Key Management `KMC` — 4 new**
This domain was originally scoped at zero because no cryptography requirement was
fully unmapped. The PCI `x.y.z` analysis settled it — the library has **no**
control mentioning cryptoperiods, key rotation, key custodians, split knowledge
or dual control, and ISO `A.8.24` is currently satisfied by `KMC.3` alone, which
is key lifetime.

A cryptography policy stating where encryption is required · approved algorithms,
key strengths and protocols, with a review as they age · cryptoperiods and key
rotation, including what happens when a key is retired · key custodian duties,
with split knowledge and dual control for keys protecting the most sensitive
data (PCI Req 3.6–3.7).

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

**Secure Development `SOD` — 10 new**
Peer code review before merge · dependency scanning and a software bill of
materials · secrets detection in source and history · hardened build templates
for application infrastructure · vetted components for security functions rather
than hand-rolled · CI/CD pipeline integrity and artefact provenance ·
authenticity and integrity of software verified before acquisition and use ·
public-facing web application protection · test data masked or synthetic (extends
`SOD.7`, which covers the obfuscated dataset but not masking as a technique) ·
**client-side script inventory, authorisation and change detection on pages that
handle payment or other sensitive input** (PCI Req 6.4.3 and 11.6 — the
Magecart control, and one of the future-dated requirements mandatory since March
2025).

**Physical & Environmental Security `PES` — 2 new**
Securing offices, rooms and facilities, including working in secure areas ·
visitor authorisation and logging, plus **an inventory of point-of-interaction
devices and periodic tamper inspection** where cards are taken (PCI Req 9.5).

## Notes

- **Some of these are sector-specific and that is fine.** Key custodian duties,
  payment page integrity and POI tamper inspection mean nothing to a company that
  takes no cards. Add them and let per-company applicability carry it (ADR 0011);
  see COM-422 for the reasoning. Write the statement so it scopes itself — "where
  card data is handled" — rather than assuming every company is in scope.
- **Cyber Essentials Danzell lands on this domain.** Cloud services are now
  explicitly in scope with mandatory MFA — make sure the cloud controls and the
  identity controls between them answer that cleanly, because it is an auto-fail.

Depends on the control identity ADR and the domain consolidation. Map as you
write.
