---
id: 01M8GRZ7GJ21N0GEESWV09P8NG
created: 2026-11-28T09:49:49.970815Z
updated: 2026-11-28T14:23:41.81703Z
type: task
title: 'The Event log: a record of what happens in Compass (time, type Info/Warning/Alert, entity, detail), kept in OpenTelemetry JSON so it can be sent to Datadog later'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2234
sprint: s09wwd3
comments:
- id: 01M8H8MNHYK0EC026MWA8H4E41
  author: Steve Vine
  at: 2026-11-28T14:23:41.118693Z
  text: |-
    Done in PR #2241 (merged). Admin ▸ Event log is a new page, after Activity in the menu. Events are listed newest first, each with:
    - when it happened;
    - its type (Info, Warning or Alert, each a coloured pill);
    - what it's about, linked where Compass has a page for it;
    - the detail;
    - its company;
    - who or what caused it.
    You can filter by type, by what it's about, by company and by dates, and search the words. Opening an event shows its full record. Export downloads the filtered events as JSON lines, one event per line.
    Each event is kept in the OpenTelemetry log format: severity INFO 9, WARN 13, ALERT 21, plus event.name, entity.type/id/name, compass.company.id and compass.actor, with service.name=compass. That way it can be sent to Datadog later as it is (sending isn't part of this task).
    Nothing can change or delete an event, Admin included. An event is written only once the work behind it is saved, and writing one never fails that work.
    Who can read it: whoever can see the Activity log. Compass doesn't limit people to particular companies, so they see every company's events, as with the Activity log.
    Polaris reads it with COM-2237.
assignee: steve
label:
- feature
priority: high
task_status: review
---
**On the chain** (a new table and API). After the Scripting phase 2 ADR (COM-2225). Steve, 28 Nov 2026: Compass has no event log today. The Activity log records changes people make to records; this records what happens.

## What people see
- **Admin ▸ Event log**, a new page listing events newest first. Each shows:
  - **Date and time**.
  - **Type**: **Info, Warning or Alert**, each as a pill in its own colour.
  - **Entity**: what it's about, linked, e.g. "Script: Create CRM user", "Script run 28 Nov 00:13", "Workflow: WFL-14", "Request: ACR-213", "Person: Ada Lovelace".
  - **Detail**: in words, e.g. "Create CRM user failed: That sign-in name is already in the CRM".
  - **Company**, where it has one.
  - **Caused by**: a person, a workflow, or Compass itself.
- Filter by type, entity kind, company and date range; search the detail. Opening an event shows its full JSON.
- **Export** the filtered events as **JSON lines**, one event a line, in the same format.
- Events are **append-only**. Nobody can edit or delete one, Admin included. They're kept like the Activity log (retention follows the backup and restore rules, ADR 0169).
- **Who can read it:** anyone who can see Admin's Activity log. Each company's events are seen only by people who can see that company.
- Polaris can read it ("what alerts were logged this week?").

## The format (standard, for sending elsewhere later)
- Each event is stored and exported as an **OpenTelemetry log record** in JSON:
  - `timestamp`;
  - `severity_text` (INFO, WARN, ALERT shown as "Alert") and `severity_number` (9, 13, 21);
  - `body` (the detail);
  - `attributes`:
    - `event.name`;
    - `entity.type`, `entity.id`, `entity.name`;
    - `compass.company.id`;
    - `compass.actor`;
    - anything specific to the event, e.g. `script.run.outcome`;
  - `resource`: `service.name=compass`, plus the environment.
- Datadog, Splunk, Elastic and others take this format as it is, so sending it on later is configuration, not a change of format. Sending is **not** in this task.

## Notes (technical)
- One `event_log` table (JSONB attributes, indexed by time, type, entity and company); a single `events.record(...)` function every caller uses; no FK on entity (events outlive what they're about). Writing never fails the work that caused it: it's best-effort, after commit.

**Done when:** on staging, events written by scripts and workflows (their own task) appear in Admin ▸ Event log, filter by type, open as JSON in the OpenTelemetry shape, and export as JSON lines; and nobody can change one.