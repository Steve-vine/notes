---
id: 01KYJN48TRJSF294W14TGFZAN5
created: 2026-07-27T20:44:11.480805Z
updated: 2026-08-07T10:57:35.172256Z
type: task
title: GitHub App authentication for the GitHub connector (replace PATs)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 341
sprint: siyfhjg
assignee: steve
label: null
priority: low
task_status: backlog
---
Move the GitHub integration off personal-access tokens onto an org-owned **GitHub App** — the production-grade fix for the credential being tied to a human account (ADR 0051 §7 chose account-wide PATs; the interim mitigation is a machine user, which is ops-only and needs no task).

**Why**: an App is owned by the organisation outright (no seat, survives any person leaving), has fine-grained permissions per installation, auto-expiring installation tokens (~1h) instead of long-lived static secrets, clean bot attribution on PRs, and higher effective rate limits.

**What changes** (this is a connector change, not a swap-the-secret rotation):
- **Credential shape**: `credential_spec()` gains an App variant — App ID, Installation ID, private key (PEM, `multiline` + `secret` field). Decide whether App auth replaces the PAT fields or sits alongside as an either/or (spec-driven form renders whatever we declare). Read/write split to preserve ADR 0051 §7's principle: either two Apps, or one App with the write permission gated — decide and record.
- **Token exchange seam** in `connectors/github.py`: sign a JWT with the private key → exchange for an installation token → cache until near expiry → refresh. All API paths (listing, sweep, detect, `open_pull_request`) go through the seam; `build_client` stays the test monkeypatch point.
- **Supporting bits**: `validate_credential` structural checks for a PEM key; `health_check` via the App's installation; private-key field name added to `REDACTED_KEY_PARTS` if not already caught; Rotate flow semantics (rotating = replacing the PEM).
- **Docs**: short ADR (or recorded amendment to 0051 §7) — App supersedes PATs and why; update the integration-connectors brief row.

**Acceptance**: a GitHub integration authenticates via App credentials end-to-end (register picker, sweep, alerts, PR action) with tokens visibly short-lived; PAT-based instances keep working until migrated (or an explicit cutover is decided and recorded).

**Files**: mod `connectors/github.py`, `logging_setup.py` (redaction), possibly `credentials.py`/Settings UI only via spec; tests `test_github_connector.py` + a token-refresh unit test; docs `docs/decisions/`, `docs/briefs/integration-connectors.md`.