---
id: 01M4ZT9F0SREYB9XD9W4P814C6
created: 2026-10-15T12:58:43.09709Z
updated: 2026-10-15T18:15:13.748979Z
type: task
title: 'ADR: an AI assistant can work in Compass — connected with a personal token, across Overview, Playbook and Posture, as the person and only if their role allows it'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 974
sprint: sadf3j6
comments:
- id: 01M504RWRKEPPK1PYYTYD1THD7
  author: Steve Vine
  at: 2026-10-15T16:01:54.451386Z
  text: |-
    Done 2026-10-15. ADR 0109, "An AI assistant works in Compass as the person", is on main: decisions/0109-an-ai-assistant-works-in-compass-as-the-person.md (PR #966, squash 3811dd2f).

    It records Steve's decisions:
    - scope by screen;
    - a personal token, not browser sign-in;
    - the Connect an AI assistant grant;
    - deleting and publishing the same as on screen.

    It also records the build calls:
    - the assistant answers at /api/mcp, which the existing /api/ proxy already passes through and the vendor-portal hostname refuses, so no chart change is needed;
    - tools call /api/v1 in-process with the person's own token;
    - each person sees only the tools their role allows;
    - an activity_log.via marker that only the in-process path can set.

    One change from the task text: the address is /api/mcp, not /mcp.
assignee: steve
label:
- brief
priority: high
task_status: done
---
Sprint 70, Content - Build MCP. Scoped with Steve on 2026-10-15. This record is the first task, and the rest wait for it.

Compass is API-first (ADR 0004) and the UI has been its only consumer. This sprint adds a second: an AI assistant (Claude Code, Claude Desktop, any MCP client) that a person connects to Compass, which then reads and changes the governance core on that person's behalf.

## What Steve decided (2026-10-15)

- **Sections:** Overview, Playbook and Posture. Modules (Vendors, Access, Inventory), Portals and Admin are out, apart from the one grant below.
- **What the assistant can do, by screen:**
  - Actions — read
  - Reports — generate
  - Frameworks, Domains, Controls, Content — read and write
  - Assessments, Gaps, Risks, Decisions — read and write
  - Compliance — read
  - Dashboard is not listed, so it is left out. Compliance already shows the same figures.
- **Connecting:** a personal token pasted into the assistant's settings. No browser sign-in or claude.ai connector this sprint.
- **Who can connect:** only people whose role holds a new grant, *Connect an AI assistant*. An administrator ticks it on the roles screen. Admin holds it, as it holds everything.
- **Deleting:** the same as on screen. If your role can delete it, the assistant can too.
- **Content review and publishing:** the same as on screen. The assistant can record a review and publish if the person's role can.
- The whole list is in this sprint, run in batches.

## What the record has to settle (Claude's calls, not confirmed by Steve)

- **It acts as the person.** Every tool runs with exactly the person's permissions, and a person who can see only the playbook gets no Posture tools. The assistant can never do more than the screen allows that person.
- **"Write" means what the screen offers today**, no more. Nothing new is invented for the assistant.
- **Company-specific tools name the company.** A tool lists the companies the person can see, and an unnamed company is an error, not a guess.
- **Every change it makes is marked "via assistant"** in Activity and in each item's own history, beside the person's name.
- **No file uploads.** Evidence attachments and uploaded policy documents stay on screen. Links to evidence are fine.
- **Reports come back as data, with a link** that downloads the file from Compass. Saving and scheduling reports stay on screen.
- **Removals are flagged as destructive** to the assistant, so a client that asks before acting asks before those.
- **Served by Compass itself, on the same address.** There is nothing new to deploy and no new service.

## Notes (technical)

- **The tools are a thin layer over the public `/api/v1`, called in-process** (an ASGI transport inside the backend, carrying the caller's token). Permissions, validation, audit, revision history and the OpenAPI contract stay single-sourced in the routes, and no service-layer refactor is needed. The record should say this and what it costs: an extra serialisation hop, which is acceptable at this scale.
- **Transport:** the official `mcp` Python SDK, streamable HTTP, mounted on the FastAPI app (proposed at `/mcp`; check the chart's ingress paths). It is stateless, so it is safe under several API replicas.
- **Auth:** `Authorization: Bearer <token>` against the existing `api_tokens` (ADR 0007), plus a check for the new permission. A token whose owner lacks the grant gets a plain refusal naming the grant.
- **The tool list is filtered per person** at list time, from their permissions.
- **Tool count:** about 70–90 across 11 areas. Consolidate (one `update_*` per object, not per field), prefix by area (`playbook_`, `posture_`, `overview_`), and write each description for the assistant (when to use it, how references are written). Server instructions give the vocabulary: domain → policy → control, maturity, applicability, the company switcher.
- **Readable references:** tools take the identifiers people see (control refs, framework slugs, decision numbers, content slugs), not UUIDs, wherever the API allows.
- **The "via assistant" marker:** a new column on the activity log and on revision rows, set from request state only on the in-process path, so an outside REST client cannot set it.
- Next free ADR number at the time of writing (0108 is the latest on main; COM-959, sprint 67, may take 0109 first).

**Done when:** the record is accepted and the tasks below match it.