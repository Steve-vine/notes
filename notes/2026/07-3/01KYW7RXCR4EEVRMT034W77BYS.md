---
id: 01KYW7RXCR4EEVRMT034W77BYS
created: 2026-07-31T14:03:12.152607Z
updated: 2026-08-05T19:29:53.468491Z
type: task
title: Teams notifications foundation — ADR, channel model, channels API
project: 01KX671DATY39VW6GWK3M2T3DN
number: 419
order: -1.0
sprint: s7qg63g
task_status: done
---
Foundation for the outbound notification layer (first in the platform — no notifier abstraction exists).

- ADR 00NN (notification channels & delivery): Power Automate Workflows webhook URL as the Teams mechanism (classic O365 incoming-webhook connectors retired; Bot/Graph channel-send rejected — Graph won't send channel messages with application permissions); URL in the credential store; in-transaction delivery row + Beat sweep reliability; channel-level min_severity + event toggles (no rules table v1).
- Migration: `notification_channel` (name, kind='msteams', credential_ref, enabled, min_severity, event toggles: incident_opened / incident_escalated / incident_resolved / action_pending / integration_broken) + `notification_delivery` (channel_id, event_type, subject refs, payload summary, status pending|sent|failed, attempts, last_error, timestamps).
- Channels CRUD API (AdminUser, new `notifications_api.py` in router.py): the Workflows URL is stored via `credentials.store()` (first non-connector consumer — `CredentialWrite.connector_type` is already optional) and is WRITE-ONLY: never returned by any GET.
- Settings env block (`# ---- Notifications (ADR 00NN) ----`): enable flag, sweep interval, attempt cap, anti-flap window.