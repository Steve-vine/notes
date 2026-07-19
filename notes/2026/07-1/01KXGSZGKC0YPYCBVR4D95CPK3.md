---
id: 01KXGSZGKC0YPYCBVR4D95CPK3
created: 2026-07-14T17:14:47.788022432Z
updated: 2026-07-19T21:30:29.482168032Z
type: task
title: Core↔PCI DSS starter crosswalk
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 64
sprint: s3j9yhs
blocked_by:
- 01KXGSYZZXD75HHN15DSFMFVGJ
assignee: steve
task_status: done
priority: medium
---
A conservative Core↔PCI DSS v4.0.1 crosswalk so assessments roll up to PCI coverage (ADR 0010). Mirrors the M8 CIS / M9 SOC 2 / M10 CSF mappings; bulk curation is a governance concern done via the crosswalk UI.

- [ ] Vendor `data/mappings/pci-dss-4-0-1.csv` (`core_ref,requirement_ref,note`) — a **conservative, high-confidence** starter set mapping Compass Core controls (`controls.csv` refs) → PCI sub-requirement refs, with short notes. Only unambiguous matches (per ADR 0010 / the ISO+CIS+SOC 2+CSF precedent). **No unquoted commas in notes** (DictReader spill).
- [ ] Add `("pci-dss-4-0-1", "pci-dss-4-0-1.csv")` to `_MAPPINGS` in `seed/mappings.py`.
- [ ] Tests (`tests/test_mappings.py`): PCI mappings resolve + apply; unresolved refs skipped; idempotent; cross-framework totals updated.
- [ ] Seeds on deploy (import Job already runs `import-mappings`); PCI coverage then derives from the M2 assessments via the crosswalk.

Expect Req 1 (NES firewalls/segmentation), 2 (DBC config baselines), 5 (THP anti-malware), 6 (SOD/VUM secure dev + patching), 7-8 (ACC/CRD access + MFA), 10 (EVM logging), 11 (VUM scanning/pen testing) to map densely; Req 9 → PES physical, Req 12 → INS policy. The cardholder-data-environment specifics (Req 3 stored CHD, Req 4 transmission encryption beyond KMC) and PCI program items will be the sparsest. Refs: ADR 0010, 0011. Depends on: PCI DSS v4.0.1 framework + sub-requirements.

---
*Migrated from Linear [DEV-491](https://linear.app/stevevine/issue/DEV-491/corepci-dss-starter-crosswalk) · created 2026-06-19 · completed 2026-06-19*