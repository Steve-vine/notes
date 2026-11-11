---
id: 01M73QBB97RXXF7VVZ2GTZN0EV
created: 2026-11-10T21:55:40.455609Z
updated: 2026-11-11T03:09:28.678229Z
type: task
title: 'Prove feeds on staging with configuration only: GitHub''s Dependabot, code-scanning and secret-scanning alerts into Vulnerabilities, its repositories into Inventory, and Cloudflare and MongoDB Atlas keys into Secrets'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1704
sprint: sep79bz
blocked_by:
- 01M73Q824SWZRYHWVQQVY02Z4E
- 01M73Q911761481VZ9JRJ6MHJ1
- 01M73Q9CWJM5FTKEC82YET8PH4
- 01M73Q9S96V19DX5JNC9G9GYXP
- 01M73QA5Z6XPW6WZQ29GD1ZZ6D
- 01M73QAGXCRZFKEJN7CNVVMYPH
- 01M73QAYASWGP8BW1R931RKWXW
comments:
- id: 01M7499Y76A1RZ599HCX7WNXKG
  author: Steve Vine
  at: 2026-11-11T03:09:28.678051Z
  text: |-
    Staging is ready for this proof (74c7156f, deployed 2026-11-11 03:01 GMT). **Couldn't check** it myself. Staging already has GitHub, Cloudflare and MongoDB Atlas connected in Test Company, but each feed must be approved on screen by someone who manages its area, and that's a person's decision. Steps for Steve:
    1. On GitHub ▸ Feeds, use "Ask Polaris to set up a feed" (or Add a feed) for Dependabot alerts, code scanning and secret scanning into Vulnerabilities, and repositories into Inventory. Then do Cloudflare's and MongoDB Atlas's keys into Secrets.
    2. Preview each one, then approve.
    3. The first run lands in the registers. Compare it with the coded GitHub tile's view.
    GitHub's org-wide alerts need a token that can read them. The current account's test read is /user (a personal token).
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