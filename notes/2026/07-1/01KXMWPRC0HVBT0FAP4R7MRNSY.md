---
id: 01KXMWPRC0HVBT0FAP4R7MRNSY
created: 2026-07-16T07:19:24.288902627Z
updated: 2026-07-23T19:46:01.85245Z
type: task
title: Human-facing sequential Issue ID (I-number)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 84
sprint: syqgx3z
task_status: done
---
Give each issue a short human-facing ID (e.g. **I123**) so people can reference a specific issue in conversation. Today issues are identified only by UUID in the UI and URLs (`issues/:issueId`), which is unusable verbally.

**Backend:**
- Add a sequential integer to `Issue` — this is the **first Postgres sequence in the schema** (every model uses UUID PKs today; no serial/sequence pattern exists to mirror). Store the integer; keep the UUID PK.
- Migration: add column + sequence + backfill existing rows in `created_at` order so history gets stable numbers.
- Expose in `IssueRead`. Format as `I` + number for display in one shared helper (mirror the `issueSource` label pattern).

**Frontend:**
- Show the ID in the issues list (`IssuesPage.tsx`) and in the issue detail header (`IssueDetailPage.tsx`).
- Consider surfacing it in the detail breadcrumb/title. URL can stay UUID-based.

Each new issue gets the next number automatically via the sequence default.