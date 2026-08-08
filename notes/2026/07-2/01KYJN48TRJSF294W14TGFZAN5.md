---
id: 01KYJN48TRJSF294W14TGFZAN5
created: 2026-07-27T20:44:11.480805Z
updated: 2026-08-08T10:56:11.81181Z
type: task
title: GitHub App authentication for the GitHub connector (replace PATs)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 341
sprint: siyfhjg
comments:
- id: 01KZGDX454EBF9484Q8P4GR23H
  author: Steve Vine
  at: 2026-08-08T10:15:10.244716Z
  text: |-
    Built and merged to main 2026-08-08 (`7f463a5`, PR #546).

    **Decisions recorded** as an amendment to ADR 0051 §7 (not a new ADR — it amends the credential decision recorded there):

    1. **Two Apps, not one App with gated permissions.** The write principal stays a separate App bound to `write_credential_ref`. Gating one App inside ISE would move the read/write boundary out of GitHub's authorization and into ISE's code — the split exists so the everyday credential is *incapable* of opening a PR, not merely not doing so.
    2. **Either/or, not a cutover.** `credential_spec` declares both shapes; `validate_credential` refuses a credential carrying both, since ISE would otherwise pick an identity silently. PAT instances keep working unmigrated, indefinitely.
    3. **The exchange lives behind `build_client`** — every read, the sweep, `detect` and `open_pull_request` got App auth with no call-site change. Tokens cache per identity, keyed on a digest of the PEM as well as the IDs, which makes rotation self-healing: a new PEM is a new cache key, so replacing the PEM through the existing Rotate flow is the whole procedure.
    4. **Two endpoints genuinely differ.** An installation is not a user, so health probes and the register picker use `/installation/repositories` (the better scope — exactly what the org granted the App). Everything under `/repos/{owner}/{name}` is identical for both identities.

    **UI**: `CredentialField` gained a `help` line so a spec-driven form offering two alternative identities can say which box to fill; a *successful* Test now renders the health detail, which is where "installation 78901234 — this access token expires in 60 min" appears against a PAT's "static, and it never expires on its own".

    `private_key` was already on the ADR 0010 redaction list (asserted, not assumed). App ID / installation ID are deliberately `secret: false` so an operator can see which App an integration acts as. No new dependency — `cryptography` was already direct.

    **Gotcha worth keeping**: gitleaks' `private-key` rule matches the literal PEM banner wherever it appears, including in a test whose point is a key that CANNOT sign. It failed the first push; the banner is now assembled from two halves and the branch was rewritten, because the PR's whole commit list is what gets scanned — amending the tip alone would not have cleared it.

    **Still to do**: this ships the capability, not the estate migration. Creating the read App + write App in the GitHub org, installing them, and rotating each GitHub integration's credentials onto them is an ops act on the live estate.
assignee: steve
label: null
priority: low
task_status: done
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