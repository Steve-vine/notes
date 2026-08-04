---
id: 01KZ6S97N6QJN78YD6NX28EVJG
created: 2026-08-04T16:21:37.062253Z
updated: 2026-08-04T16:21:37.062253Z
type: task
title: Webhooks return to the core application — no synthetic integrations, no managed sources on the Webhooks page
priority: high
task_status: backlog
label: improvement
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 539
---
Direction from Steve 2026-08-04, after functional testing exposed the current model end-to-end: **webhooks are part of the core application, not an integration** — restore that division. His concern, verbatim in substance: the current shape "ambiguates the division between core application and integrations", and that ambiguity will bite in Sprints 47–49 (Integration Decoupling / Integration Packs), which formalise exactly what an integration *is*. A webhook-as-System must not get baked into the pack model's registry and contract.

## What testing found (the symptoms)

- Creating a webhook source in Settings → Webhooks and then receiving one `level: alert` lazily mints a **synthetic System** named after the source (`webhook_signals.ensure_system`, ADR 0048) — which then appears in Settings → Integrations and as an Overview tile, indistinguishable from Azure/EntraID. Its `connected` health is a constant (nothing is checked), and its State toggle is a decoy (the source's own `enabled` is the real switch). An operator cannot tell it's plumbing.
- **Deleting the source orphans the System** — `delete_webhook_source` (`webhook_sources_api.py:247`) has no teardown counterpart to `ensure_system`. Two live orphans exist: **"Test-Webhook"** (from today's testing) and **"ISE Estate"** (same bug, struck long ago, unnoticed — its source no longer exists; Steve re-enabled the ghost believing it was the webhook integration). No UI path removes them.
- The reverse leak: **managed sources** for polled integrations (`ensure_managed_source`, ISE-311 / ADR 0051 §4) put "FreshService" and "Moneypenny-Development" rows on the Settings → Webhooks page — integration plumbing surfacing in the core-app webhook UI. Confusion in both directions.

## Required end state

1. **Settings → Webhooks lists only operator-created inbound sources.** Managed per-integration event sources are internal — not listed (they already reject edit/delete via `_reject_if_managed`; now they also stop being shown).
2. **A webhook source never appears as an integration**: nothing webhook-synthetic in Settings → Integrations, no Overview tile, absent from any add-integration picker if `webhook` is offered there today (verify).
3. **Deleting a source deletes/retires its backing plumbing** — no orphans.
4. **Repair migration** for the two live orphan Systems (and the recovered smoke-test finding attached to Test-Webhook — decide keep-reattributed vs delete). Populated-data test per [[ise-migration-data-paths-need-populated-tests]].

## Implementation decision for plan mode — where do webhook findings hang?

ADR 0048's "ordinary Finding on a synthetic System" bought the whole signal pipeline for free: per-source severity overrides (ADR 0026 scopes by System), dedup on (system, source_key), Alerts-origin naming. Options:

- **(a) Keep synthetic Systems as pure hidden plumbing** — cheapest, preserves all three properties; every integration-facing surface filters them out. The concept disappears from the UI while the FK machinery stays. If chosen, per-source severity tuning needs a home the operator can reach (surface overrides on the Webhooks page, since the System page is no longer reachable).
- **(b) One core "Webhooks" System (hidden)** — simpler still, but per-SOURCE severity overrides and per-source dedup scoping collapse; check whether any live overrides depend on it before choosing.
- **(c) Findings reference the source directly** — the honest model but new promotion machinery, exactly what ADR 0048 avoided; disproportionate unless (a) proves leaky.

Lean (a). Whatever is chosen: **this needs an ADR** — it amends ADR 0048 (the synthetic System becomes an explicit non-integration implementation detail) and ADR 0051 §4 (managed sources stop appearing on the Webhooks page). Append-only; supersede, never rewrite.

## Why now (sequencing)

Sprints 47–49 build the integration registry/contract and declarative packs. The webhook boundary must be clean *before* that work fixes the definition of "integration" in code — retrofitting afterwards means touching the pack model. This task should land ahead of Sprint 47.

## Definition of done

An operator can create, use, and delete a webhook source entirely within Settings → Webhooks; nothing webhook-related ever appears in Settings → Integrations or Overview; FreshService/GitHub rows are gone from the Webhooks page; the two orphan Systems are gone from the live estate; alerts from sources still arrive, attribute, dedup and severity-tune exactly as today.
