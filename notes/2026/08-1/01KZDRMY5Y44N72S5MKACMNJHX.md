---
id: 01KZDRMY5Y44N72S5MKACMNJHX
created: 2026-08-07T09:25:13.022499Z
updated: 2026-08-13T19:00:07.106679Z
type: task
title: Assist thread titles — auto-generate from first exchange, rename in sidebar
project: 01KX671DATY39VW6GWK3M2T3DN
number: 600
sprint: snk16ew
comments:
- id: 01KZE8J9FE9R8Q8BR7FGS62T9X
  author: Steve Vine
  at: 2026-08-07T14:03:23.501991Z
  text: |-
    Built on feature/ise-600-assist-thread-titles — PR #520.

    The design decision worth recording: THREE writers name a thread, and the interesting part is the handover, not any one of them.

    1. **The read path derives a title from the first question** (`apply_provisional_title` on `GET /threads`). Free, instant, cannot fail. This is both the lazy backfill for pre-existing threads AND the floor under everything else — once something has been asked, no row reads "New conversation" again whatever the worker does. That is why I chose lazy fill over a data migration: the same code that backfills history is the safety net for every new thread.
    2. **A worker upgrades it to six words.** New `title-thread` AI task type — cheap tier (Haiku), no tools, own 8k run cap, `ai` queue, fired after an answered turn (not inside the request — nobody should wait on a title). Enqueued after EVERY answered turn rather than just the first, because the task itself is the idempotence and a failed first turn would otherwise leave the thread unnamed for ever.
    3. **The operator overrides both** — `PATCH /threads/{id}`, owner-only under the router's same-404-for-foreign rule, plus in-place rename in the sidebar.

    **`assist_titles.is_provisional` is the whole guard**: the model may replace a title only while it is still the default or still exactly what the derivation would produce. Consequences — a human's rename is never clobbered (including by a worker already mid-run, which re-checks after the model returns); the model gets exactly one go, because re-titling a conversation somebody has learned to recognise is worse than a dull title; and the Celery task is idempotent under retry or double-enqueue. **No column records who wrote the title** — the comparison is a pure function of the first question, so it's derivable whenever needed and cannot drift out of step with the title it describes. That was the choice I'm most pleased with: the alternative was a `title_source` column that could go stale.

    Failure is designed, not incidental: a budget refusal, a provider outage, a schema-validation failure and an empty answer all end the same way — the thread keeps the question-derived title. A truncated question is a poor title and a TRUE one; "New conversation" is neither.

    **Screen**: hover-revealed pencil swaps the row for an input (a modal for three words is ceremony). Enter commits, Escape/blur abandon, unchanged-or-empty isn't sent. The list refetches TWICE after a turn — immediately for the provisional title, then after a settle delay for the model's. Without the second, the truncated question would sit in the sidebar until something else happened to refetch it, and the feature would look half-built.

    **Migration 0104** (not 0102 — a parallel session merged ISE-608/609/610 with 0102 and 0103 while I was working; caught by alembic's "revision present more than once", renumbered). Widens the `ai_model_config` task-type CHECK and DOES seed the config row, unlike cluster-tickets: an unconfigured type never runs, and this one must run on a fresh install or every thread stays titled by truncated prose. No new column — `assist_thread.title` already existed.

    Gotcha the suite caught: `test_every_task_module_is_included_in_the_worker` failed because the new task module wasn't in `ISE_api.worker`'s include list — without it the worker silently discards the task. Good test.

    Tests: unit (derivation, word-boundary truncation, model-answer cleaning, the full is_provisional handover); integration (default disappears on first ask, rename+trim+empty-refused, foreign-rename is the same 404 as missing, worker upgrades once then stops, rename beats the worker, failed model call leaves the derived title, deleted thread isn't an error); migration 0104 both ways on a POPULATED database including that the narrowed constraint bites again after downgrade; frontend rename/escape/no-op.

    Full backend suite green: 2564 passed. Frontend 666 passed. ruff, mypy strict, build, eslint, prettier all clean.
assignee: steve
label: null
priority: medium
task_status: done
tech: null
---
Every Assist thread is permanently titled "New conversation" — the sidebar is unusable past a handful. 

- Auto-title after the first turn completes: cheap model call (respects ai_limits/budget accounting) summarising the first question into ≤6 words; falls back to a truncated first question if the call fails. Set once, never regenerated.
- `PATCH /threads/{id}` rename endpoint (owner-only, same 404-for-foreign rule) + inline rename in the sidebar.
- Existing threads: backfill title from first user message on next load (no migration of prose needed — a data backfill or lazy fill, decide in implementation).

Screen: AssistPage sidebar shows real titles with rename affordance.