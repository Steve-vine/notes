---
id: 01KZDRK4EMNP40HVXZRV63C9VA
created: 2026-08-07T09:24:13.908796Z
updated: 2026-08-07T12:48:18.363608Z
type: task
title: Estate query tool v2 — attribute predicates, date comparisons, counts
project: 01KX671DATY39VW6GWK3M2T3DN
number: 593
sprint: snk16ew
assignee: steve
label: null
priority: medium
task_status: active
---
Upgrade `find_estate_entities` (ai/assist_tools.py) so Assist can answer "which app registrations expire in the next 90 days" / "how many users have passwords expiring in 5 days":

- Attribute predicates on the entities' JSONB `attributes` — equality, substring, and date/number comparisons (mind the `attributes->>k` NULL trap).
- A count/aggregate mode so "how many" returns a number, not 200 truncated rows.
- Generate the type list in the docstring from `ENTITY_TYPES` — it currently hardcodes six types in prose while ~20 exist (user, app-registration, identity-group, secret, network…), so the model doesn't know it can look for identity objects.
- Result shape stays truncation-honest.

Screen: answers surface in the existing Assist page — proven by the ISE question-bank task. Pairs with the EntraID expiry-attributes task, which provides the data these predicates query.