---
id: 01M76D0RXQK1XNMT7E8JQMPYKQ
created: 2026-11-11T22:52:51.511371Z
updated: 2026-11-11T23:01:41.599169Z
type: task
title: 'ADR: the left-hand menu becomes one floating menu, eight groups, pinned pages and page search, opened from a Compass button'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1742
sprint: spsp226
comments:
- id: 01M76DGXNTNZQMCRK25Y5MJ6AK
  author: Steve Vine
  at: 2026-11-11T23:01:40.666222Z
  text: |-
    Done, merged in PR #1736.

    - ADR 0152, "One floating menu replaces the left sidebar", records your Claude Design (turn 2a/3a) as the spec, plus your four answers:
      - the top bar keeps the trail;
      - pins are saved to the person;
      - Dashboard and Actions to start;
      - any number of pins, with only the first row on 1–6.
    - My calls, recorded:
      - people see only the groups and pages they can access;
      - the menu opens on the current page's group;
      - only Actions has a count;
      - the public Trust Centre link sits in Third parties & trust;
      - M and 1–6 are ignored while typing;
      - narrow screens stack the groups above the pages;
      - the environment and build line moves to the foot of the menu.
    - Amendment notes on ADR 0017 (the shell) and ADR 0085 §5 (the folding sidebar).
    - Also updated: brief/information-architecture.md now describes the menu, and CLAUDE.md lists 0152.

    Nothing changes on screen until COM-1743 and COM-1744.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
From Steve's testing (2026-11-11): the left-hand menu has become long and hard to navigate (37 pages, 14 under Modules). Steve designed the replacement in Claude Design: project **"Compass app navigation redesign"** (`459b22e2-d5ab-45f6-91de-c5834206ff0e`), file `Navigation Concepts.dc.html`, turn 2a (dark, chosen) and 3a (light). **The design is the spec.**

Record the decision as a new ADR amending ADR 0017 (IA), the sidebar parts of ADR 0085 (the September redesign: collapsible icon sidebar) and the sidebar notes in `brief/information-architecture.md`. Update the brief to match. Nothing is built in this task. It gates the two build tasks: saved pins, and the menu itself.

**What the ADR records, with Steve's calls (2026-11-11):**
- **No sidebar.** Pages use the full width. The fold-to-icons toggle, and pages asking the sidebar to collapse (Assessments' focus mode), go.
- **One Compass ▾ button**, top left, opens a floating menu over the page. **M** also opens it; **M** or **Esc** closes it. Choosing a page closes it.
- **Eight groups** replace the seven headings:
  - **Overview:** Dashboard, Actions, Initiatives, Reports
  - **Playbook:** Frameworks, Domains, Controls, Content, Decisions
  - **Posture:** Assessments, Gaps, Risks, Exceptions, Continuity, Checks, Compliance, Risk Assessments
  - **Exposure:** Inventory, Secrets, Vulnerabilities, Security Feed, Incidents
  - **People & privacy:** Access Control, Attestations, Data Subject Requests, User Portal
  - **Third parties & trust:** Vendor Management, Trust Centre, DDQ, Contracts, the public Trust Centre link
  - **Assurance:** SAP, Audits, Evidence
  - **Admin:** Admin, Integrations, Activity, System status
- **Pinned pages** are tiles across the top of the menu.
  - A person pins as many as they like. They wrap onto more rows and are dragged to reorder, across rows as well as along them.
  - Only the **first row** (six) carries the number keys **1–6**.
  - **Pins follow the person** to any browser or computer they sign in on.
  - Someone new starts with **Dashboard and Actions** pinned.
- **Find a page…** searches every page the person can see, by name, then description, then group.
- **The top bar keeps today's trail** (the way you came, ADR 0084) beside the Compass button, not the design's "Group › Page". The rest of the top bar is unchanged.
- **My calls, stated for Steve to overrule:**
  - Groups and pages a person can't see are hidden.
  - The menu opens on the group of the page you're on.
  - Only Actions shows a count (your open actions).
  - On a narrow screen, the groups stack above the pages.
  - **M** and **1–6** do nothing while typing in a field.

**Done when:** the ADR is merged, CLAUDE.md lists it, and `brief/information-architecture.md` describes the menu, not the sidebar.