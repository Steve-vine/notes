---
id: 01M87NP509Q79GWHY7EYF0KVPQ
created: 2026-11-24T20:59:16.873671Z
updated: 2026-11-24T21:17:37.905341Z
type: task
title: 'ADR 0178: business services: a per-company list linking vendors, Inventory, risks, incidents and content'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2149
sprint: ss3ttbb
assignee: steve
label:
- brief
priority: medium
task_status: active
---
Sprint "Business Services" (Steve, 24 Nov 2026). Written first; the other tasks follow it.

## What it records
- **Why:** see a vendor's blast radius, meaning which business services a vendor's failure would hit and by what route, and tie risks, incidents and content to the services they concern.
- **Each company keeps its own list of business services.** Each service is **Internal** or **Client facing** (Steve). For Moneypenny: TAS, LiveChat, AI Receptionist, plus internal ones such as Payroll. Each has a reference `SVC-n`, an owner, a description and its own criticality. A service in use is retired, not deleted.
- **A service's criticality never changes a vendor's or an engagement's criticality** (Steve: not every vendor delivering part of a service matters equally). Links are shown, with their route, and nothing is raised automatically.
- **Services link to vendor engagements, not vendors.** An engagement is what a vendor does for the company. A vendor's blast radius is the union over its live engagements.
- **Services link to Inventory** (systems, software, data assets). A vendor's link to a service can also be **worked out** through Inventory: the systems a vendor supplies, software it publishes installed on systems, data disclosed to it held on systems, followed through system dependencies. Each worked-out link shows its route ("TAS → Call platform (AST-4) → supplied by Twilio"). Direct links cover what Inventory can't see.
- **Risks, incidents and content** link to one or more services. Content is shared by every company, so its service links are per company (as runbooks' "systems it recovers" are), set by people who can manage the inventory (Steve).
- **The business impact analysis assesses the business services list, replacing its own list of functions** (Steve, option 2). Approved function-based BIAs stay as they were. Continuity reads per service once a service-based BIA is approved. This amends or supersedes the relevant part of ADR 0131.
- Where it lives: a **Business services** page in the Exposure group, after Inventory.

## Done when
- `decisions/0178-business-services.md` is written (Proposed) and added to CLAUDE.md's key-ADR line. The number is whatever is next free when it's written.

Independent (docs only).