---
id: 01M72E6DFF0RMNH4621YGB3GGN
created: 2026-11-10T09:56:27.247457Z
updated: 2026-11-10T22:49:03.31115Z
type: task
title: An area address's instructions read "Secrets's tools" — say "the Secrets tools"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1666
sprint: s0mep0u
assignee: steve
label:
- bug
priority: low
task_status: todo
---
Found in the COM-1654 pre-UAT (2026-11-10). An area address tells the assistant "This is Compass's Secrets address: it offers only Secrets's tools, plus whoami…". The possessive reads badly for names ending in s (Secrets, Incidents, Vulnerabilities, Attestations, Contracts, Initiatives, Data Subject Requests, Risk Assessments).

**Done when:** it reads "it offers only the {name} tools, plus whoami, list_companies and search", and the unit test in `test_assistant_areas_unit.py` checks the wording.

**Where:** `assistant/instance.py` `instructions_for`. **Independent**, cosmetic. Only the assistant reads it.