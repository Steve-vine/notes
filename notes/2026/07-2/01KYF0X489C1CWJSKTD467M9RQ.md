---
id: 01KYF0X489C1CWJSKTD467M9RQ
created: 2026-07-26T10:53:02.601014Z
updated: 2026-08-05T19:02:23.773558Z
type: task
title: 'ADR 0051 + UI brief: the GitHub repo register'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 304
sprint: siyfhjg
assignee: steve
label: null
priority: high
task_status: done
---
Write `docs/decisions/0051-the-github-repo-register.md` recording the sprint's design decisions, and extend `docs/briefs/ui-brief.md` with the Repos screen (pick-from-list register modal, freshness column, comprehension status, capability badge). No code. This is the acceptance vehicle for ISE-299 — the ADR must demonstrate the ADR 0050 ingest → comprehend → index → search contract.

**Decisions to record:**
1. Repos are a register, not estate entities (mirror ADR 0042): `repo` = pointer + cached comprehension; `repo_tag` join into the shared tag pool links repos to entities (no FK); `system_id` FK SET NULL; uniqueness `(system_id, full_name)`; register-again-is-edit.
2. ADR 0050 contract applied: comprehension at write time only — repo summary (README + deterministic tree manifest, one cheap model call); per-file summaries only for an allowlisted class (IaC, helm/k8s manifests, Dockerfiles, `.github/workflows/*`, `*.md`) with size cap + per-sweep cap (~25) so big repos drain across sweeps; lockfiles deterministic-only; commit history stored and FTS-searchable, no model call per commit.
3. Change-driven sweep: Beat task polls default-branch head SHA; on change, compare API → re-comprehend only touched allowlisted paths; two-commit durability; never raises (documents-scrape pattern).
4. Polled push/release events reach the Events screen via a managed internal WebhookSource (`owner_system_id` FK, `enabled=False` so the token is never a live ingest URL; server calls `store_event` directly). Rejects generalising the event store.
5. Alert semantics: `actions-workflow:{full_name}:{workflow_id}` (latest completed default-branch run failing, recovers via reconcile), `dependabot:{full_name}:{n}`, `code-scanning:{full_name}:{n}` with severity mapping; signals hang off the GitHub System (`entity_key` deliberately unresolved); repo tags give estate context. Deleted workflow ⇒ silent recover (mirrors DataDog monitor deletion) — state it.
6. `open_pull_request` is T2 (reversible, merges nothing, second human gate at GitHub review — deliberately cheaper than direct infra mutation); **no `merge_pull_request`**, say why; `target_fields=["repo"]`; protection via per-System `risk_policy.protected_targets`; atomic multi-file commit via Git Data API; refuse head==base.
7. Credentials: account-wide fine-grained PATs through the existing read/write split (`credential_ref` read PAT, `write_credential_ref` write PAT); field key `api_token` (already in the redaction list).
8. New capability string `repos` appended to `CONNECTOR_CAPABILITIES`.

**Acceptance:** ADR merged; brief covers the Repos screen; ISE-299's constraint is demonstrably met by the task slicing.