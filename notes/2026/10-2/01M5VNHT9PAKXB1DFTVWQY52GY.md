---
id: 01M5VNHT9PAKXB1DFTVWQY52GY
created: 2026-10-26T08:34:38.006335Z
updated: 2026-10-26T09:25:32.105284Z
type: task
title: 'ADR 0127 — Polaris works inside Compass: a window on every page, the organisation''s own AI provider, acting as the person, asking before each change, within a spend limit'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1326
sprint: s9ls6e7
comments:
- id: 01M5VREZYJZ8H5WHKDMSWD8K3Q
  author: Steve Vine
  at: 2026-10-26T09:25:31.21794Z
  text: |-
    Done — merged to main (PR #1342): decisions/0127-polaris-works-inside-compass.md, plus an "Amended by" line on ADR 0109.

    - §1 records your four decisions: everything the role allows and DDQ-aware first; ask before each change; conversations kept with a list; a new Use Polaris grant.
    - The technical notes carry the API the rest of the sprint is built to.

    Two decisions changed from the plan while I wrote it:
    - **A turn runs in the API process, not in Celery.** The tools call Compass in-process, so they need the running app. And a model call spends money, so it can't be a task that is safely re-run.
    - **The window long-polls for Polaris's words rather than using a stream.** So nothing has to pass through nginx or the ingress, and any replica can answer.

    Two more things changed during the build:
    - **History is never trimmed.** Current Claude models refuse a conversation whose earlier turns were changed. Instead, a single tool result is capped at 60,000 characters, and Polaris is told to ask for less.
    - **A conversation's tool list is fixed when it starts**, so the provider's prompt cache holds. Polaris reaches every other tool through "find a tool" and "use a tool".

    My calls are listed in the ADR's "Calls made in planning" section.
assignee: steve
label:
- brief
priority: high
task_status: review
---
## Behaviour

Records sprint 88's shape. Builds on ADR 0109 (the assistant acts as the person) and ADR 0125 (Polaris does the interpreting on a DDQ).

- **Polaris is in Compass.** A button in the top bar opens a window that slides up over the page. You type, and Polaris answers. It is the same Polaris that people reach today from their own assistant through the MCP: the same tools, the same rules and the same name.
- **It acts as you.** It can do exactly what your role allows on screen, and nothing more. Everything it changes appears in the activity log as made by you, via Polaris.
- **It asks before each change.** Reading is free. Before any change, the window shows "Polaris wants to …" with Allow / Allow for this conversation / Deny.
- **It reaches everything your role allows, from any page.** On DDQ screens it also knows which questionnaire and question you're looking at. Other screens get that awareness in later sprints.
- **It runs only when someone asks.** It doesn't pick up questionnaires or "with Polaris" questions by itself. Working unprompted would mean acting as itself rather than as a person, which needs its own decision later.
- **The organisation brings its own provider.** An administrator enters an Anthropic or OpenAI key and chooses the model. One provider is active at a time.
- **Spend is capped.** There is a maximum per hour and per day for the whole organisation, and Polaris can't be switched on without both. When a limit is reached, Polaris pauses until the hour or day turns over.
- **Spend is an estimate**, worked out from token counts at each model's list price. The providers don't report cost per reply.
- **Conversations are kept and private to the person.** They're listed in the window and kept until the person deletes them.
- **Two new grants:** *Use Polaris* (gives you the button) and *Manage Polaris* (gives you Admin ▸ Polaris). The built-in Admin role holds both. Portal accounts can never hold either.
- **What Polaris reads is sent to the chosen provider.** The Admin page says so.

## Steve decided (2026-10-26)

- Everything the role allows, DDQ-aware first.
- Ask before each change.
- Conversations kept, with a list.
- A new "Use Polaris" grant.

## My calls (awaiting Steve)

- One active provider at a time. Limits are organisation-wide, in US dollars, on the clock hour and the calendar day in Compass's time zone (ADR 0121).
- No file attachments in the prompt this sprint.
- The page gets extra space at its foot, as tall as the window, so nothing is hidden behind it.

## Notes

- **Independent** (docs only).
- Technical section:
  - where a turn runs and how it streams;
  - how tools are offered without sending all 628 definitions on every call;
  - key storage in `core/secretbox`;
  - the spend ledger.
