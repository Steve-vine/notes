---
id: 01M87NQFSEBPW8TSMXJ091KHM8
created: 2026-11-24T21:00:00.686156Z
updated: 2026-11-25T04:06:22.721267Z
type: task
title: An incident's "services affected" can name business services
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2154
sprint: ss3ttbb
blocked_by:
- 01M87NPDZVSSZPHJ5EJ6KND9G9
comments:
- id: 01M88657PRCZJZ36ZCJNBVHFQB
  author: Steve Vine
  at: 2026-11-25T01:47:08.376837Z
  text: |-
    Built and merged to main: PR #2150 (d8343d8dc), migration 0918_incident_business_services.

    What people see:
    - Service impact card: "Add a service" opens one picker, with the company's active business services first, then systems. "Type a service" still adds a name. A linked service shows its SVC number, opens its page, and is marked Retired once retired.
    - Older incidents: a typed name matching a service's name (ignoring case and spaces) shows "This is the name of a business service. Link to SVC-3 TAS". Accepting replaces the typed entry and writes on the timeline ("Linked affected service: SVC-3 · TAS, in place of the typed name "tas""). Nothing is stored until accepted.
    - Adding or removing a business service is on the incident's timeline.
    - A service's page has an Incidents card: every incident that named it, newest first, with outage start, end and length (or "still going"), and status. Restricted incidents are counted, not listed.
    - The incident register has a Business service filter (server-side, kept in the address).
    - A service named on an incident counts as in use ("1 incident").
    - Polaris adds a service to an incident (business service first, then system, then typed name) and answers "which incidents hit LiveChat this year?".

    Tested: backend integration for linking and refusals, timeline, in-use count, suggest and accept, the service's incident list, the register filter, and migration up → down → up. Vitest covers the card, the suggestion, picker order, the Incidents card and the filter. CI green after adding the new route to the "closed incident refuses writes" test list (the route already refused correctly).

    For Steve to decide:
    1. The suggestion needs an exact name match (ignoring case): "TAS outage" doesn't suggest TAS.
    2. Without View inventory, people (and Polaris for them) can't read business services, so adding falls back to a system or a typed name.

    Not checked yet: seen in a browser (staging pre-UAT).
- id: 01M88E4681C4RAN40M1Q0R16HF
  author: Steve Vine
  at: 2026-11-25T04:06:22.720997Z
  text: |-
    Pre-UAT on staging a63d542b2: **Passed**.
    - INC-144: "Add a service" lists business services first, then systems. TAS, AST-54 and a typed name were added.
    - On INC-125, typing "tas" shows "This is the name of a business service. Link to SVC-1 TAS". Accepting replaces it, and the timeline reads "Linked affected service: SVC-1 · TAS, in place of the typed name "tas"".
    - TAS's Incidents card lists both, and the register's TAS filter returns both.
    - The Analyst's picker made a failed services request; that's fixed in COM-2160.
    Screenshots: ~/compass-uat/ss3ttbb/COM-2154/
assignee: steve
label:
- feature
priority: medium
task_status: review
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