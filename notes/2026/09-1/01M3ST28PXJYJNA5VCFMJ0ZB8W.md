---
id: 01M3ST28PXJYJNA5VCFMJ0ZB8W
created: 2026-09-30T18:43:38.845127Z
updated: 2026-09-30T22:32:31.609732Z
type: task
title: The rest of the Playbook in the new layout — Domains, Frameworks, Content and Decisions, lists and pages
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 804
sprint: s0zzctz
blocked_by:
- 01M3ST04QGV1F3BH3F9J4XDZXK
- 01M3ST1F3ESST3M1MYYREH38Y0
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Part of sprint 65, UI Upgrade (ADR in COM-794). The prototype doesn't draw these screens, so they follow its patterns: lists like the Controls list, and pages like a control's page. Nothing they do changes, only how they're laid out.

## What people see

- **Domains** (`/domains`):
  - page header;
  - filter bar;
  - a grouped list with each domain's controls count and its policy;
  - the CSF function column as today.
- **A domain's page:**
  - detail layout, with the domain's name and its facts (controls, documents);
  - the documents and controls in the main column;
  - its policy and owner in a side card.
- **Frameworks** (`/frameworks`): summary cards per framework (coverage %), then the list.
- **A framework's page:**
  - detail layout with fact cards (requirements, coverage, out of scope);
  - requirements grouped by section, with the coverage pills as today.
- **Content** (`/content`): page header with New, filter bar (type, domain, review state), and a grouped list by type.
- **A document's page:** detail layout.
  - Its tabs stay as they are: Read, Links and the rest.
  - The facts it carries today (version, owner, review dates, approval) move into the side column.
  - The Read tab's reading width and PDF are unchanged.
- **Decisions** (`/decisions`): page header with New decision, filter bar, and a list with number, title, status and date.
- **A decision's page:** detail layout, with its status and supersession in the side column.
- **Pop-ups** (New decision, edit dialogs) take the new look but keep their fields.

## Notes (technical)

- **Pages:**
  - `pages/DomainsPage.tsx`, `DomainDetailPage.tsx`;
  - `FrameworksPage.tsx`, `FrameworkDetailPage.tsx`;
  - `ContentPage.tsx`, `ContentDetailPage.tsx`;
  - `DecisionsPage.tsx`, `DecisionDetailPage.tsx`;
  - the `library/` components they share.
- **Keep** every URL, tab param and trail label. The domain-policy payload from the Controls list task can be reused here.
- **Ratchet.** Empty these pages' entries from the page-header ratchet.
- **Tests.** Existing page tests must pass. Add tests only where layout changes behaviour, e.g. a tab moving or a filter becoming a chip.

**Done when:** on staging, every Playbook list and page is in the new layout, and nothing a user could do before is missing.