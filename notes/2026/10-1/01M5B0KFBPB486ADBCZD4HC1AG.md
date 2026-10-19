---
id: 01M5B0KFBPB486ADBCZD4HC1AG
created: 2026-10-19T21:20:41.33467Z
updated: 2026-10-19T22:04:59.28675Z
type: task
title: The library's privacy controls cover every right, not just access, correction and erasure — a new control for restriction, objection, portability, automated decisions and telling recipients, and the request controls map to ISO 27001 A.5.34
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1146
sprint: ss8348q
blocked_by:
- 01M5B0BP7ZPYE928WFSPZ09ND4
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint 79, Data Privacy (ADR in COM-1129). Library data only, with no screens. It can be built in parallel with the module once the ADR is in.

## Why

The SOC 2 objective this sprint answers names **access, correction, deletion, objection, portability and disclosure recordkeeping**. Today the library's PDH controls cover access (PDH.10), correction and erasure (PDH.15), disclosures (PDH.16) and complaints (PDH.17). Nothing asks for **restriction, objection, portability, review of an automated decision**, or **telling recipients** (GDPR Art. 18, 19, 20, 21, 22; ISO 27701 7.3.4–7.3.10). And only PDH.9 maps to ISO 27001 A.5.34 ("Privacy and protection of PII").

## What changes

1. **A new control** in the PDH domain (ref PDH.18, key `s42.PDH.7`, tier specialised): *"Requests to restrict processing, to object, to receive data in a portable form, or to have an automated decision reviewed by a person are handled within the required timeframe, and recipients are told of any correction, erasure or restriction."*
   - It gets "What this means", "What good looks like" and "Evidence" text in the library's voice.
   - Mappings:
     - SOC 2 P5.2 (subset) and P6.7 (subset);
     - ISO 27001 A.5.34 (subset);
     - HITRUST 13.f / 13.n where the wording supports it;
     - NIST CSF: none.
2. **"What good looks like" for PDH.10 and PDH.15** adds:
   - identity checked proportionately, and no copies kept;
   - the clock and its extension;
   - refusals give reasons and the right to complain;
   - requests forwarded by customers when we hold the data for them.
3. **ISO 27001 A.5.34 mappings** for PDH.10, PDH.15, PDH.16 and PDH.17 (subset).
4. **PDH.17** (complaints) "What good looks like" names the UK duty since 19 June 2026 (DUAA 2025): to acknowledge a complaint within 30 days, and to tell the person the outcome without undue delay.

## Out of scope

The HIPAA Privacy Rule rights (164.524, 164.526, 164.528) aren't in Compass's HIPAA framework, which covers the Security and Breach rules only. Adding them is a separate piece of work. The module's HIPAA deadline rules work without it.

## Notes (technical)

- Follow the "adding a framework/control" checklist: five test files pin counts and rules; `test_crosswalk.py` is a unit test, so run `pytest -q` with no `-m` before pushing data.
- Seed import runs every deploy, so the new control and mappings arrive on deploy. Repair data in the importer, not a migration.
- Pick the next free PDH key and ref on main at build time.

**Done when:** the new control is in the library with its mappings; A.5.34 lists the request controls; all count tests updated and green.