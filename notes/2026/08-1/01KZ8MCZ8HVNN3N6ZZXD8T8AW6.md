---
id: 01KZ8MCZ8HVNN3N6ZZXD8T8AW6
created: 2026-08-05T09:34:45.521168Z
updated: 2026-08-05T09:34:45.521168Z
type: task
title: Settings → Integrations offers read/write credentials to every connector — declare which each needs, and fix action-link wording
priority: medium
assignee: steve
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 553
---
Settings → Integrations renders the credential actions unconditionally for every system (`SettingsPage.tsx:362-375`): every integration gets both a read and a write credential slot regardless of whether the connector can use them. Confluence offers "Grant write" but has no write capability; Status Page offers both and needs neither.

**Capability declaration.** Extend the connector declaration surface so each connector states which credentials it uses — e.g. a `credentials` declaration alongside `CredentialSpec` (ADR 0018) / `capabilities()` (ADR 0027): read = needed / not needed, write = needed / not needed. Deriving write from the `actions` capability and read from "has any read capability requiring auth" may work as the default, but the declaration must be explicit enough that a no-auth connector (Status Page) can say "none". Expose it through the connector-type metadata the API already serves for the credential form (ISE-56 pattern: the UI renders from declarations, connectors get correct UI for free).

**UI gating.** Settings → Integrations only shows (and the API only accepts) the credential actions the connector declares: Confluence → read only; Status Page → neither; Kubernetes/AWS/Azure/etc. → read + write.

**Wording.** Make the action links symmetrical:
- "Add credential" → "Grant read" (paired with "Grant write")
- "Rotate" → "Rotate read" (paired with "Rotate write")

**Acceptance:**
- Confluence shows only Grant/Rotate read; Status Page shows no credential actions; a connector with actions still shows both.
- No connector shows a credential slot it cannot use, and the backend rejects setting one (not just hides the button).
- Links read "Grant read" / "Grant write" / "Rotate read" / "Rotate write".