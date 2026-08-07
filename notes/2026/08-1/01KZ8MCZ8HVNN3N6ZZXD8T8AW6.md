---
id: 01KZ8MCZ8HVNN3N6ZZXD8T8AW6
created: 2026-08-05T09:34:45.521168Z
updated: 2026-08-07T10:09:22.198268Z
type: task
title: Settings → Integrations offers read/write credentials to every connector — declare which each needs, and fix action-link wording
project: 01KX671DATY39VW6GWK3M2T3DN
number: 553
sprint: skxht3g
comments:
- id: 01KZ92AWRP1ERPCY7DFDRQZKNH
  author: Steve Vine
  at: 2026-08-05T13:38:17.493987Z
  text: |-
    Built on feature/ise-553-credential-declarations — PR #472 (full CI green), merged to staging.

    **Declaration.** `CredentialUse` on the connector, derived from what connectors already say so none had to declare anything new: read = it declares credential fields; write = it also declares the `actions` capability. Overridable where a derivation can't cover it. Served on `/api/v1/connectors` (Type metadata, ISE-56 pattern) and resolved onto each system row as `uses_read_credential`/`uses_write_credential`, exactly as `capabilities` already is — so hidden Types work too and the list needs no join.

    **Enforced, not just hidden.** The systems POST/PATCH refuse (400) a binding the connector cannot use, naming which. Clearing (explicit null) is always allowed — refusing it would trap the very rows this came from. Result: Confluence read only, Status Page neither, Kubernetes/AWS/Azure both. Wording is now Grant read / Grant write / Rotate read / Rotate write.

    **Naming.** Defaults are `<name>-read` / `<name>-write`. And a rotation now SHOWS the bound name and lets it be corrected — it was hidden and `existing` won unconditionally, so a wrongly-named ref re-minted itself on every rotation and could never be fixed from the UI. A changed name rebinds the system.

    **Repair (migration 0099).** Six systems share the bad ref, so the ref cannot say which owns the secret — the credential's DESCRIPTION can (`kubernetes credential for mgnt-staging-uk`, machine-written by the rotate modal from the system being rotated; the one field the wrong name never corrupted). That one is renamed to `<system>-write` and repointed; every write ref left pointing at a credential that does not exist is cleared. Skipped entirely if any system uses that credential as its READ credential. Read refs untouched. Idempotent, so the five already hand-cleared in staging are fine.

    Stacked on 0098 (ISE-552): the branch is rebased onto ISE-552's, because a migration without the model change it belongs to fails the schema-drift check.

    Tests: derivation per connector + an invariant over all registered connectors; API refusal on create and patch, acceptance of the usable one, clearing still allowed; migration 0099 against a seeded estate in the live shape; four frontend tests including the `g5-write` default and rename-rebinds.
assignee: steve
label: null
priority: medium
task_status: done
---
Settings → Integrations renders the credential actions unconditionally for every system (`SettingsPage.tsx:362-375`): every integration gets both a read and a write credential slot regardless of whether the connector can use them. Confluence offers "Grant write" but has no write capability; Status Page offers both and needs neither.

**Capability declaration.** Extend the connector declaration surface so each connector states which credentials it uses — e.g. a `credentials` declaration alongside `CredentialSpec` (ADR 0018) / `capabilities()` (ADR 0027): read = needed / not needed, write = needed / not needed. Deriving write from the `actions` capability and read from "has any read capability requiring auth" may work as the default, but the declaration must be explicit enough that a no-auth connector (Status Page) can say "none". Expose it through the connector-type metadata the API already serves for the credential form (ISE-56 pattern: the UI renders from declarations, connectors get correct UI for free).

**UI gating.** Settings → Integrations only shows (and the API only accepts) the credential actions the connector declares: Confluence → read only; Status Page → neither; Kubernetes/AWS/Azure/etc. → read + write.

**Wording.** Make the action links symmetrical:
- "Add credential" → "Grant read" (paired with "Grant write")
- "Rotate" → "Rotate read" (paired with "Rotate write")

**Additional bug — write credential misnamed "Status Pages-credential" (found live 2026-08-05).**
All six external Kubernetes systems (env-staging-uk/us, env-production-uk/us-pri, mgnt-staging-uk, mgnt-production-uk-pri) have `system.write_credential_ref = 'Status Pages-credential'` — expected `<system-name>-write` (e.g. `env-staging-uk-write`). The ref was dangling until 09:35:46 on 2026-08-05, when a rotate-write on mgnt-staging-uk stored a REAL credential under the wrong name (its description, "kubernetes credential for mgnt-staging-uk", is correct — the name came from the stale ref).

Two mechanisms to fix, plus repair:
1. `RotateCredentialModal.tsx:82` builds the name as `existing || name || \`${system?.name}-${isWrite ? 'write' : 'credential'}\``. Because `existing` always wins, a wrongly-stored ref re-mints itself on every rotation and can never be corrected from the UI. "Status Pages-credential" is precisely the default this template produces for the *Status Pages* system with kind *read* — the original mis-bind was this default generated against the wrong system/kind and then bound to the six clusters (likely during their 2026-08-02 onboarding).
2. The default template itself doesn't match convention: read default is `<name>-credential` while every real read credential is `<name>-read`. Default should be `<name>-read` / `<name>-write`.

Repair (data): rename/rebind so each of the six clusters points at `<system-name>-write`; the credential currently stored as "Status Pages-credential" is mgnt-staging-uk's real write credential and must be preserved under its correct name. The other five refs are dangling and should be cleared until a real write credential is granted.

**Acceptance:**
- Confluence shows only Grant/Rotate read; Status Page shows no credential actions; a connector with actions still shows both.
- No connector shows a credential slot it cannot use, and the backend rejects setting one (not just hides the button).
- Links read "Grant read" / "Grant write" / "Rotate read" / "Rotate write".
- Default credential names are `<system-name>-read` / `<system-name>-write`; the six Kubernetes write refs are repaired; a rotation surfaces the bound name so a wrong one can be corrected rather than silently re-minted.