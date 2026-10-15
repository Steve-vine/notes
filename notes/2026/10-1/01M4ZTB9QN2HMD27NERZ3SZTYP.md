---
id: 01M4ZTB9QN2HMD27NERZ3SZTYP
created: 2026-10-15T12:59:43.221566Z
updated: 2026-10-15T18:13:08.406994Z
type: task
title: The assistant can read and change Domains and Controls — the control library, each control's text and the domain it sits in
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 977
sprint: sadf3j6
blocked_by:
- 01M4ZTA4GTXVEB7VCA28HW24TV
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 70, Content - Build MCP (ADR in COM-974). Built on COM-975. Playbook batch. **Do this one first in the batch.** The Posture tasks find controls through the lookup it adds.

## What people can ask of it

- **Read:**
  - the domains, each with its policy and its controls;
  - the control library, searchable by text, domain and framework;
  - a control in full: its text, its domain, the requirements it meets and the content linked to it;
  - for a named company, that company's status and maturity beside each control, as the Domain page shows it.
- **Write (whatever the person's role allows on screen):**
  - add, edit and delete a domain;
  - add, edit and delete a control;
  - edit a control's wording, and its revision history records the change as via assistant.
- **Example:** "Which controls in Access Management have no linked procedure?" Then: "draft a clearer wording for AC-04 and save it."

## Notes (technical)

- These wrap `domains.py` and `controls.py` (slug and ref). `GET /controls/export` stays on screen; the assistant already reads the data.
- **The shared lookup:** a `find_control` (text/ref → control) that COM-976 and the Posture tasks reuse, rather than each inventing one.
- Per-company status beside controls reads from the assessments list, so the company is optional here and required only for that view.
- Tests: ref resolution; the write tools are hidden without library write; delete is annotated destructive; a control edit is recorded via assistant.

**Done when:** on staging, the assistant edits a control's wording, and the control's history shows the edit as via assistant.