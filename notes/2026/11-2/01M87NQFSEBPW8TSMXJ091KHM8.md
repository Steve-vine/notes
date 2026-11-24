---
id: 01M87NQFSEBPW8TSMXJ091KHM8
created: 2026-11-24T21:00:00.686156Z
updated: 2026-11-24T21:00:43.498741Z
type: task
title: An incident's "services affected" can name business services
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2154
sprint: ss3ttbb
blocked_by:
- 01M87NPDZVSSZPHJ5EJ6KND9G9
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint "Business Services". Follows the Business services page.

## What people see
- **An incident's Service impact card:** "services affected" can now be a **business service**, as well as a system or a name typed in (both of which stay). The picker offers the company's active services first.
- **Existing incidents keep what they have.** A typed-in name that exactly matches a service's name (ignoring case) gets a "Link to TAS" suggestion on the incident. Nothing changes until someone accepts it.
- **A service's page** has an **Incidents** card: every incident that affected it, newest first, with dates, outage length and status.
- **The incident register** can be filtered by business service.
- Each change is on the incident's timeline, as service changes already are.
- Polaris can add a service to an incident's affected services and answer "which incidents hit LiveChat this year?".

## Done when
- In E2E Test Company: add TAS to an incident's services affected. TAS's page lists the incident.
- An older incident with the typed name "tas" shows the suggestion. Accepting it links TAS and records it on the timeline.
- A system and a typed name can still be added.

## For the build
- Add `business_service_id` as a third target on `incident_affected_services`, extending the `an_asset_or_a_name` check to exactly one of the three, with a partial unique index like the container one. Logic in `core/incident_links.py` `_add_service`.
- Update `incidents/IncidentServiceImpactCard.tsx` and Polaris `incidents_link`.
- **On the chain**: migration + API.