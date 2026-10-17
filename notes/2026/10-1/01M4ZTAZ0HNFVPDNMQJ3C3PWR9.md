---
id: 01M4ZTAZ0HNFVPDNMQJ3C3PWR9
created: 2026-10-15T12:59:32.241181Z
updated: 2026-10-16T07:29:08.625344Z
type: task
title: The assistant can read and change Frameworks — the requirements, the crosswalk to controls, and what applies to a company
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 976
sprint: sadf3j6
blocked_by:
- 01M4ZTA4GTXVEB7VCA28HW24TV
comments:
- id: 01M50TT3DCQ9HM6FVC4VB64SBZ
  author: Steve Vine
  at: 2026-10-15T22:27:02.7001Z
  text: |-
    On staging 2026-10-15 23:26 BST (PR #971). 22 tools: frameworks, requirements (paged, filter by words/level/mapped), mappings both ways, unmapped on either side, version compare, a company's scope/level/applicability/SoA; add/edit/delete frameworks and requirements, map/re-grade/unmap, set scope and target level, applicability with justification, addressable answers, carry forward.
    My calls: "coverage suggestions waiting for a decision" turned out to be an Access Control feature (business-role suggestions), so it isn't included; instead the Frameworks screen's own "these controls fully cover this requirement" judgement is offered. A framework named without a version (e.g. "CIS") means the current one.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 70, Content - Build MCP (ADR in COM-974). Built on COM-975. Playbook batch.

## What people can ask of it

- **Read:**
  - the frameworks and their levels;
  - a framework's requirements;
  - which controls a requirement maps to, and the reverse;
  - what is unmapped on either side;
  - a new version's differences from the old one;
  - the coverage suggestions waiting for a decision;
  - a company's scope, target level, requirement applicability and Statement of Applicability.
- **Write (whatever the person's role allows on the Frameworks screen):**
  - add and edit a framework and its requirements, and delete them;
  - map a requirement to a control, change the mapping, remove it;
  - accept or dismiss a coverage suggestion;
  - carry a new version forward;
  - set a company's scope and target level;
  - mark a requirement as applicable or not, with its justification, or as addressable.
- **Example:** "Which ISO 27001 requirements have no control mapped?" Then: "map A.5.23 to the cloud services control."
- A licensed framework that ships as a skeleton (ADR 0100) stays one. The assistant reads what the screen shows, nothing more.

## Notes (technical)

- These wrap `frameworks.py`, `mappings.py`, `coverage_proposals.py`, `requirement_applicability.py` and `soa.py`.
- References: framework slug plus requirement ref, and control ref. Tools resolve these to ids before calling the routes that need them.
- Requirement lists can be long (HITRUST has hundreds), so page them and filter by text, level and mapped/unmapped.
- Company-scoped tools take the company by name or slug (COM-975's `list_companies`).
- Tests: tool shapes for each write, a role without framework write sees no write tools, and a delete is annotated destructive.

**Done when:** on staging, the assistant answers the unmapped-requirements question, makes a mapping, and the mapping shows on the Frameworks screen with "via assistant" in Activity.