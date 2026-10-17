---
id: 01M4ZTBNA5HZ7FT7X8J9JQDGDP
created: 2026-10-15T12:59:55.077546Z
updated: 2026-10-16T07:29:09.89024Z
type: task
title: The assistant can read, write, review and publish Content — policies, standards and procedures, section by section, with their versions
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 978
sprint: sadf3j6
blocked_by:
- 01M4ZTA4GTXVEB7VCA28HW24TV
comments:
- id: 01M50TSXBDFEX43JBT092FX0FD
  author: Steve Vine
  at: 2026-10-15T22:26:56.49349Z
  text: |-
    On staging 2026-10-15 23:26 BST (PR #969). 21 tools: list/read documents section by section, versions and a compare (summary first, full diff on request), reviews, templates and types; create from a template or blank, edit details and sections, link/unlink controls (one at a time or a whole domain), record a review, publish, revert, delete.
    My calls: revert is treated as destructive (it discards unpublished edits), so the assistant asks first. Publish refuses when nothing has changed since the last version. "Send for review" means assigning reviewers — Compass has no separate "in review" state. Uploading a Word/PDF document stays on screen.
    Worth knowing: linking controls and recording a review don't appear in Activity at all (on screen or via assistant) — that's existing behaviour, not new.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 70, Content - Build MCP (ADR in COM-974). Built on COM-975. Playbook batch.

## What people can ask of it

- **Read:**
  - the content list, by type and status;
  - a document's full text, section by section;
  - its versions and the differences between two of them;
  - its reviews;
  - the controls it is linked to;
  - the templates and content types available.
- **Write (whatever the person's role allows on the Content screen, decided by Steve on 2026-10-15):**
  - create a document, from a template or blank;
  - edit its details;
  - add, edit, reorder and remove sections;
  - link and unlink controls;
  - **record a review and publish**, if the person's role can, with the same rules the screen enforces;
  - revert to an earlier version;
  - delete a document.
- **Not through the assistant:**
  - uploading a document file (a Word or PDF upload stays on screen);
  - the Microsoft 365 version list, which it can read but not act on;
  - templates and content types, which it reads only. They are set up in Admin.
- **Example:** "Draft an Acceptable Use standard from the Standard template, link it to the controls in Human Resources Security, and send it for review."

## Notes (technical)

- These wrap `content.py` (by slug). They read `content_templates.py` and `content_types.py`. The PDF and file download come back as a link, not bytes (COM-974).
- Section text is in the same markup the editor saves. Tools describe the format to the assistant so it writes valid sections.
- Review and publish go through the same routes, so approval rules (who may approve their own draft, and so on) are enforced there, not in the tool. Add a test that an assistant cannot publish where the screen would refuse.
- The versions diff can be large, so return a summary first and the full diff on request.

**Done when:** on staging, the assistant drafts a standard from a template, links controls, and it appears in Content as a draft with every change via assistant. A role without publish is refused when it tries to publish.