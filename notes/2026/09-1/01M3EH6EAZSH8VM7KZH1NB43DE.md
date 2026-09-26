---
id: 01M3EH6EAZSH8VM7KZH1NB43DE
created: 2026-09-26T09:36:59.743106Z
updated: 2026-09-26T09:43:20.579431Z
type: task
title: System status (Admin) — admins can see what Compass's background workers are doing, what's waiting, and how long a job waits to start
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 759
sprint: s3nfes0
comments:
- id: 01M3EH98RNF3RNJZKT1Q51FX7D
  author: Steve Vine
  at: 2026-09-26T09:38:32.341687Z
  text: 'ADR 0077 written and committed on feature/com-759-system-status. Draft PR #765 holds only the ADR for now; the implementation follows on the same branch. COM-760 and COM-761 stack on it. COM-755''s ADR takes the next number, 0078.'
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
**Carries ADR 0077** (Compass shows admins the state of its own background work), adapted from ISE ADR 0091.

**Why.** Background jobs share a small pool of worker slots. When a long job such as the 4½-minute shared-mailbox read overlaps a directory sync, other jobs (a PDF, Test connection, emails) wait, and nothing in Compass shows it. Discussed 2026-09-26 after connecting Exchange.

**Behaviour.**
- A new **System status** screen in the sidebar's **Admin** section, after Activity. **Admin only** (Steve, 2026-09-26): it's shown to whoever the Admin section is shown to (holds any `admin.*` permission), and the API applies the same test, so the sidebar never offers a screen that refuses.
- **Running now:** each job in progress, by its plain name ("Reading shared mailboxes", "Syncing the directory", "Rendering a PDF") and how long it has been running. No arguments, people, companies or tenant content, so widening who can see it later stays a permission change.
- **Lanes:** for the general lane and the access-changes lane, how many jobs are waiting and **how long a job currently waits before it starts**.
- **Workers:** how many are online, jobs finished per minute, and the average job time.
- **Integrations:** one line each for Entra, Exchange and email, with its current verdict, linking to Admin ▸ Integrations.
- Every figure can read **Unknown**. If Compass can't reach the queue, the screen never shows a confident 0.

**Mechanism (ADR 0077 §1–2).**
- Workers write their state to Valkey as they go (Celery `before_task_publish` / `task_prerun` / `task_postrun` / `task_failure` handlers): running-now hash, recent durations, completed counter, and a publish-time header, so each job's wait is measured. Telemetry writes are wrapped and never raise.
- The API reads those keys directly. There is no `celery inspect`, so the screen works when the workers are stuck.
- A heartbeat per lane every minute (the existing `heartbeat` moves from 5 min to 1 min; a twin is routed to `execution`), so an idle lane still has a fresh wait figure.
- New `GET /api/v1/system/status`, guarded by the same "holds any admin permission" test as the Admin nav gate (`AppLayout.tsx`). The response carries its verdict thresholds so the screen and any future warnings can't disagree.
- Nav: a `System status` item with `section: 'Admin'` in `components/nav.ts`, after Activity.

**Not in this task:** the scheduled-job table (COM-760) and trend charts, the separate recorder and expiring ticks (COM-761).

Draft PR #765 on `feature/com-759-system-status` holds the ADR.