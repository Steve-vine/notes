---
id: 01M6PVDTTX6KZBCPXSXY1XXDW3
created: 2026-11-05T21:56:48.605765Z
updated: 2026-11-05T22:35:03.475296Z
type: task
title: 'ADR: Collected evidence — Polaris works out how to collect a control''s evidence from a connected system, a person checks the first capture, then Compass collects it on a schedule; Collection integrations are read-only services defined on screen'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1595
sprint: s1jcke1
comments:
- id: 01M6PXKTR4S9772F7KR071GDNM
  author: Steve Vine
  at: 2026-11-05T22:35:02.276595Z
  text: |-
    Done: PR #1611 merged.

    `decisions/0142-collected-evidence.md` records the rules agreed on 2026-11-05:
    - Polaris designs a collected check, a person checks the first capture, and Compass then collects on a schedule;
    - captures go straight into the Evidence register; reads are complete or nothing; a capture is held on a change of shape;
    - Polaris looks again on demand only;
    - reads only, enforced in code (AWS allow-list and secret refuse-list, GET only for Azure, Graph and Collection services, LDAP search only);
    - Core vs Collection integrations: defined on screen by one person with Manage integrations, several accounts each, internet only, icons, the wizard;
    - Polaris jobs;
    - who sees what.

    My calls are listed in the ADR's Calls section.

    Also in the PR:
    - CLAUDE.md's key-ADR list names 0142;
    - `brief/permission-catalogue.md` widens Manage integrations and says Record assessments gates designing and approving checks;
    - `brief/information-architecture.md` describes Core and Collection.

    Nothing to test in the browser: it's a document.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint "Evidence Collection - Integrations". Write ADR 0142 recording what Steve agreed on 2026-11-05. It builds on Continuous Control Checks (ADR 0132), Evidence (ADR 0122), Polaris (ADR 0127), the Integrations library (ADR 0128) and Secrets (ADR 0141, for keys that are never shown).

## Why

Evidencing controls means collecting a lot of screenshots and data extracts by hand. Most of them come from a few systems: Azure, AD, AWS, Microsoft 365 and a handful of SaaS services such as MongoDB and SendGrid. These systems all have APIs. Coding each check by hand doesn't scale, and new SaaS services come and go too often to need a sprint and a release each.

## The rules

- **Polaris designs the collection; Compass repeats it.** For a control, Polaris works out a plan: which system and account, what it reads, and what the result should show. A person checks the first capture: that it is correct, and that it holds nothing sensitive. From then on Compass collects on a schedule, with no AI involved. The plan is shown on the control as "How Compass collects this".
- **Captures go straight into the Evidence register** once the plan is approved (Steve). Each capture keeps exactly what the system returned, when, through which account and what was asked. It shows as a readable page that replaces the screenshot, with the raw data downloadable. Polaris's note, if any, sits beside it, labelled as Polaris's reading.
- **Complete or nothing.** Compass always reads every page. A read that can't finish (throttled, timed out, too big) fails, and the check shows as Broken. A partial capture is never saved.
- **A change of shape is held for a person.** Compass compares each capture with the approved one. It holds the capture when:
  - fields appear that weren't there (an unchecked field may be sensitive);
  - fields go missing;
  - the size jumps or drops sharply;
  - the result is empty;
  - the read errors.
  A held capture stays out of the register until someone confirms it or asks Polaris.
- **Polaris looks again on demand, never on a schedule** (Steve). "Ask Polaris to check this" re-validates one or more checks. "Re-create" designs a check again, and the old one keeps running until the replacement is approved.
- **Reads only, enforced by Compass.** Every system uses a read-only credential. Compass also refuses anything but a read, and refuses reads that return secrets (AWS secret values, Azure keys, LAPS passwords…), whatever the credential allows.
- **Core and Collection integrations.**
  - *Core* integrations are today's tiles. They are coded, do more than read, and arrive with a release.
  - *Collection* integrations are read-only services defined as data on screen. They are created by a single person with Manage integrations (no second approval, Steve), usually with Polaris reading the service's API documentation.
  - The gallery shows the two kinds apart.
- **A service is defined once, with as many accounts as needed.** Each account has its own name, company, sign-in and key ("MongoDB – Production", "MongoDB – Analytics"). A plan reads every account the company has for that service and keeps one capture per account.
- **Internet only.** A Collection integration can reach public addresses only, never Compass's own network or anything on-premises. On-prem systems stay Core (AD).
- **Icons.** Polaris finds the service's own logo and Compass keeps a copy. If it can't find one, Compass draws a lettered tile. A person can upload their own, which is cleaned before it is stored.
- **Polaris jobs.** Polaris can work in the background, outside a chat: on a job a person starts, within the Polaris spend limits. Nothing it produces takes effect until a person approves it. The activity log names the person, via Polaris.

## My calls (for Steve to overturn)

- Designing plans and approving captures needs **Record assessments**, the assessor's ground, as for check settings.
- Default schedule is **weekly**; each plan can be daily, weekly or monthly.
- A capture identical to the last one isn't stored again; the last one's "still true on" date moves forward.
- "Sharply" means more than **half as big again, or less than half** the approved size, counted in items.
- Captures are visible to those who can see Evidence. Polaris sees sample captures while it designs and checks, as it already sees Compass data in chat.
- Collection integrations speak JSON over HTTPS.
  - Sign-in: API key in a header, bearer token, username and password, HTTP digest (MongoDB Atlas keys), or OAuth client credentials.
  - Paging: page number, offset, cursor, or next link (in the body or a Link header).
  - Anything else needs a release.
- Core reads cover AWS, Azure, Microsoft 365 (Graph) and AD. GCP comes later.
- A capture is capped at **50,000 items or 20 MB**. Over that, the check is Broken with "narrow the read".

**Chain:** independent (an ADR only).

**Done when:** `decisions/0142-collected-evidence.md` is merged; CLAUDE.md's key-ADR list names it; `brief/permission-catalogue.md` and `brief/information-architecture.md` (Integrations: Core and Collection) are updated.