---
id: 01M73QBB97RXXF7VVZ2GTZN0EV
created: 2026-11-10T21:55:40.455609Z
updated: 2026-11-10T21:58:19.521515Z
type: task
title: 'Prove feeds on staging with configuration only: GitHub''s Dependabot, code-scanning and secret-scanning alerts into Vulnerabilities, its repositories into Inventory, and Cloudflare and MongoDB Atlas keys into Secrets'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1704
sprint: sep79bz
assignee: steve
label:
- feature
priority: high
task_status: todo
---
The sprint's acceptance: real services, set up only as configuration, with no code change for any of them (COM-1696).

**Chain:** independent (configuration and checking on staging; any gap found becomes a new task in this sprint, or a capability for sprint sj4f1kj)

## What gets set up (E2E Test Company first, then Test Company with Steve's accounts)

- **GitHub → Vulnerabilities:** three feeds from the organisation-wide lists, each paged by GitHub's Link header (already supported):
  - Dependabot alerts: state open, fixed or dismissed, with the dismissed reason;
  - code-scanning alerts;
  - secret-scanning alerts.

  Repositories are the targets. Matching rules place them.
- **GitHub → Inventory:** the organisation's repositories, as kind *Repository*, with visibility, default branch and archived as facts.
- **Cloudflare → Secrets:** account API tokens as keys at their source, with expiry and last used.
- **MongoDB Atlas → Secrets:** the organisation's service accounts' secrets as keys at their source, with expiry.

## Done when

- Each feed was set up by Polaris (COM-1702) or an assistant (COM-1703), previewed, approved on screen by the area's manager, and has run on schedule at least twice.
- **Vulnerabilities:**
  - alerts appear as vulnerabilities on the systems their repositories are placed on, and the rest wait on Unmatched;
  - a Dependabot alert dismissed in GitHub comes in as Accepted by GitHub, with the reason;
  - a fixed one closes.
- **Inventory:** repositories are on Discovered, and one made into an asset and one discarded behave as cloud resources do.
- **Secrets:** tokens are on Secrets ▸ Discovered with their expiry. One made into a secret gets expiry reminders.
- A deliberately broken mapping (e.g. state mapped from a field that doesn't exist) is **held**, not applied (COM-1701).
- Comment on this task with each feed's configuration (exported as JSON), what it brought in, and every capability that was missing or awkward. Those feed sprint sj4f1kj.
- Pre-UAT in E2E Test Company as for any sprint (ADR 0135). Steve's real accounts are for Steve to look at.

## Notes

- GitHub's organisation tokens can only be listed with GitHub App sign-in, and per-repository lists (deploy keys) need follow-on reads. Both are sprint sj4f1kj, so don't attempt them here.
- If a feed needs anything beyond COM-1697's mapping language, stop and record it. Don't add a special case.