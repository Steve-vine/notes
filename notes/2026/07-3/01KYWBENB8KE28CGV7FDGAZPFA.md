---
id: 01KYWBENB8KE28CGV7FDGAZPFA
created: 2026-07-31T15:07:30.5364Z
updated: 2026-08-07T10:09:35.730421Z
type: task
title: Freshservice create_ticket action (T1) + ActionResult.external_ref
project: 01KX671DATY39VW6GWK3M2T3DN
number: 442
order: 2.0
sprint: s5pft6a
blocked_by:
- 01KYWBD140W250K7BY89WVRB2Z
comments:
- id: 01KYX6EDMGF200TN1ECA2RZD57
  author: Steve Vine
  at: 2026-07-31T22:59:14.19282Z
  text: |-
    Done — PR #389 (stacked on #388), CI green including frontend.

    `create_ticket` at **T1**. The argument, for the record: T2 is "config change or hard to reverse" and this changes no configuration; GitHub's `open_pull_request` is T2 because a PR carries a diff whose merge *mutates infrastructure* — it sits on the mutation path, a ticket sits on none; DataDog's `ack_event` is T0 as additive-and-unremovable, but a ticket is outward-facing and seen by people, so not free. T1 is also the only tier a per-integration policy may later open for auto-apply, which is the door a future "auto-raise on a critical incident" needs.

    **Two invariants enforced by the schema, not by trusting callers:**
    - The `ise-generated` tag is stamped unconditionally and is *not* a parameter. Because the schema is closed, passing `tags` is **rejected** rather than silently ignored — an operator who could suppress the tag could re-open the feedback loop.
    - The requester comes from `ticket_requester_email` in integration config, never per-call. Accepting it as a parameter would let a proposal file a ticket as a named colleague. Without it configured the action refuses and names the setting.

    **Platform improvement riding along:** `ActionResult` gains `external_ref` (`{kind, id, url, label}`). GitHub had been smuggling its PR URL through `detail` + `before`, where the timeline printed it as plain text an operator had to select and copy — GitHub now populates the same field, so **its PR links become clickable for free**. No migration: it goes into the existing `result` JSONB and is omitted when nothing was created, so old records keep their exact shape.

    **Security note worth keeping:** the href is scheme-checked in `externalRef.ts`, extracted as a pure helper precisely so it could be tested. `url` originates in a target system's API response — untrusted content by contract (ADR 0047 §3) — so an unchecked href would let a compromised integration put `javascript:` behind a link an operator has every reason to trust. Tests cover `javascript:`, `data:`, `vbscript:` and `file:`.

    Verification: 35 connector tests + 8 frontend tests; 375 related backend tests; ruff/format/mypy (468 files), eslint, prettier, `npm run build` all clean.
assignee: steve
label: null
priority: medium
task_status: done
---
The write half: a governed action that raises a Freshservice ticket.

**ActionSpec** — `create_ticket`, **tier T1**, `target_fields=["group_id"]`, parameters `{subject (req, <=255), description (req), priority (int 1-4, opt), type (opt, default "Incident"), group_id (int, opt)}`, `additionalProperties: false` and flat so `ActionsPanel` renders it for free. `reversible=True`, rollback note honest: "Close or delete the ticket in Freshservice — nothing else was changed."

**T1, not T2 — the argument for ADR 0068:** T2 is "config change or hard to reverse"; creating a ticket changes no configuration and is trivially reversible. T1 is "reversible, bounded blast radius" — one row in a helpdesk queue. Against GitHub's `open_pull_request` (T2): a PR carries a code diff whose merge mutates infrastructure — it sits on the mutation path; a ticket sits on none. Against DataDog's `ack_event` (T0): also additive and outward-facing, called "a genuine T0" because it cannot mutate or remove anything. Additive + outward-facing + reversible lands between the two. T1 is also the operationally right band: under default-deny it still queues for approval, but T1 is the only tier a per-integration policy *may* later open for auto-apply — the door a future "auto-raise a ticket on a critical incident" capability needs, opened deliberately rather than by re-tiering later.

**Feedback-loop cut** — `_execute` stamps the `ise-generated` tag **unconditionally and non-configurably**. An operator who could disable it could re-open the loop: ISE creates a ticket → the poller reads it back → it counts toward a burst, or opens an incident about a ticket describing an incident. The ingest gate drops tagged tickets before any detector or event emitter sees them. **Cover with an explicit test** — this is the failure mode a reviewer will not spot.

Secondary gate: also exclude ticket ids recorded in a `create_ticket` `ProposedChange.result` for this system — a helpdesk agent can delete a tag, but ISE's own record cannot be edited from Freshservice. That query is needed anyway for the summary card.

Named and deliberately NOT solved: a *human* filing a ticket that describes an ISE incident ("ISE says checkout is down"). That is noise, not a machine loop; any heuristic would be a text-matching guess that misfires. The scope filter and burst threshold absorb it. Say so in the ADR.

**Requester identity comes from `System.config`, never an action parameter.** Freshservice requires a requester on create; taking it as a parameter would let a proposal impersonate a named person. Admin-set once via `ticket_requester_email`, and it keeps the schema small for both `ActionsPanel` and any future AI drafter.

**Add `external_ref` to `ActionResult`** — `{kind, id, url, label}` — rather than repeating GitHub's trick of smuggling the PR URL through `detail` + `before`, where `IssueTimeline` renders it as unlinked text. `changes.mark_executed` already writes the whole result dict into `ProposedChange.result` (JSONB), so this needs **no migration and no response-schema change**. Render it as an anchor in `IssueTimeline.ExecutionResult` — **GitHub's PR links become clickable for free**, a genuine platform improvement riding along.

**Write credential** — the standard Grant-write flow: one `credential_spec` shape stored twice (read key on `credential_ref`, ticket-create key on `write_credential_ref`), the GitHub ADR 0051 §7 precedent. The executor hard-requires `write_credential_ref` with **no fallback** to the read credential (`tasks/actions/execute.py:74-86`). Use a *separate Freshservice agent* for the write key, not the same key: separate consent and revocation, and ISE-created tickets become attributable to a named ISE agent in Freshservice's own audit.

Risk-policy review; brief table row updated; regenerate OpenAPI.

UI: free via the generic `ActionsPanel` on System detail.