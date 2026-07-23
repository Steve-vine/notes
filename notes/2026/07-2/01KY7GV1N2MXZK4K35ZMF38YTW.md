---
id: 01KY7GV1N2MXZK4K35ZMF38YTW
created: 2026-07-23T12:57:36.162231Z
updated: 2026-07-23T13:03:05.176198Z
type: memo
title: SOC2 Q&A
project: 01KY4JNC6MPPNNFXN416S398SG
---
Answers to open evidence questions raised while attaching evidence to the 19 Carbide readiness tasks (July 2026).

---

**Q: What should we provide as RBAC documentation and encryption/key management records?** *(Task: Document network and access architecture supporting logical access controls)*

**A:** For RBAC, auditors want to see that access maps to job function by design, not by accident. Provide: (1) a role/permission matrix — job functions or teams mapped to Entra ID groups and the application/cloud roles those groups grant (the existing "User group mappings" and "Permissions Groups" screenshots are a start; the matrix ties them together); (2) the access request/approval workflow showing new access requires approval; (3) a completed periodic access review record. For encryption/key management, the uploaded Key Management and Cryptography Policy is the design half — pair it with implementation evidence: an inventory of keys (AWS KMS, Azure Key Vault) with rotation status shown enabled, encryption-at-rest settings screenshots for representative datastores (RDS, S3, Azure Storage, backups), TLS enforcement evidence (config or an SSL scan of key endpoints), and certificate inventory/renewal process.

---

**Q: How do we show "sample sanitized test data procedures" and "API security configurations"?** *(Task: Establish secure testing environments and API/interface security validation)*

**A:** For test data, the key artefact is a short documented Test Data Management standard stating what data is permitted in non-production. If production data never enters test environments, say exactly that, and evidence it structurally: separate cloud accounts/subscriptions, no replication paths, plus how test data is generated (synthetic/seed scripts). If any production-derived data is used, document the anonymisation method with a before/after sample. For API security, evidence the enforcement points: Kong gateway configuration showing authentication (OAuth/JWT validation), rate-limiting plugins, and TLS enforcement; Cloudflare WAF rules protecting public endpoints; and API request logging. The already-uploaded API penetration test and retest reports demonstrate the validation half — configuration evidence demonstrates the preventative half.

---

**Q: What is the expectation for recording consent?** *(Task: Implement privacy notice, consent, and lawful basis records)*

**A:** Lighter than it sounds for a B2B services business. SOC 2 Privacy criteria expect consent records only where consent is the lawful basis actually relied on. Most Moneypenny processing will rest on contract or legitimate interests — so the primary artefact is a lawful basis mapping (RoPA-style): each processing activity mapped to its basis. Consent capture evidence is then only needed at the points where consent genuinely applies, typically: website cookie consent (the consent management tool's logs/config), and marketing opt-ins (the marketing platform's timestamped subscription records). Add version-controlled privacy notice history and a documented withdrawal route (unsubscribe, cookie preference re-prompt), and that satisfies the criteria. No enterprise consent-management platform is expected.

---

*Gaps identified from these answers and the evidence comments have been raised as tasks in this project.*