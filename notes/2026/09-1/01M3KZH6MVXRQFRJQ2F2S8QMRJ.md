---
id: 01M3KZH6MVXRQFRJQ2F2S8QMRJ
created: 2026-09-28T12:23:44.539421Z
updated: 2026-09-28T12:24:28.492005Z
type: task
title: Feature-request endpoint on the check-in Worker, plus ADR 0065
project: 01KY6W9951TW0904DT0GGJVGE7
number: 467
sprint: svg0tvg
assignee: steve
label:
- feature
priority: high
task_status: todo
tech:
- cloudflare
---
The server half of in-app feature requests. It lands first, so the app has somewhere to send. ADR 0065 lands with this PR.

## ADR 0065: in-app feature requests go to the Worker (supersedes ADR 0050 and 0051)

Record these decisions (agreed with Steve on 2026-09-28):

- **Help → Suggest a Feature… sends the request to the developer** through the check-in Worker. Every install does this, including Steve's. The vault-local filing from ADR 0050/0051 (`feature_project`/`feature_sprint`, the "Where do feature requests go?" prompt) is **removed, not kept as an option**.
- **Payload (a closed list):** `install_id`, `version`, `os`, `arch`, `email` (required), `summary` (required), `details` (optional). No vault content, no note titles, no settings.
- **The email is required** so Steve can reply. It's shape-checked but not verified, so a request can carry someone else's address. That's accepted.
- **The install_id is sent**, so a request can be matched to the install's version history. Consequence to state plainly: for an install that has sent a request, its ADR 0064 check-in rows can be linked to an email. That data is pseudonymous, not anonymous. The privacy policy's description of the check-in has to change to match.
- **No IP address or request metadata is stored**, and observability stays off, the same as ADR 0064.
- **Abuse limits** work from D1 alone, with no new bindings and no IP: a per-install_id cap (e.g. 5 per 24h) and a global cap (e.g. 200 per day). Both return `429`. Bodies over 8 KiB get `413`.
- **Retention:** a request row, including the email, is deleted 12 months after it arrives, by the existing cron. The triage script can delete one sooner (for an erasure request).
- **Headless (`notuvia-mcp`) doesn't send requests.** That's out of scope for now.
- Update the Status lines of ADR 0050 and 0051 to say they're superseded by 0065. Don't change their bodies (ADR 0001).

## Agreed work

- [ ] `POST /v1/requests` on the existing `notuvia-checkin` Worker at `checkin.notuvia.net`. Keep `/v1` (check-in) exactly as it is. Move routing into `index.js` or a small router, and put the logic in `workers/checkin/src/requests.js` next to `checkin.js`.
- [ ] Strict validation. Anything that fails gets a `4xx` and **stores nothing**:
  - `install_id`, `version`, `os`, `arch`: the same rules as the check-in
  - `email`: a simple `local@domain.tld` shape, ≤ 254 chars
  - `summary`: trimmed, 1–120 chars, a single line
  - `details`: optional, ≤ 4000 chars
  - reject unknown fields
- [ ] Migration `0002_feature_requests.sql`: a `feature_requests` table with `id` (server-minted), `received` (server UTC timestamp), the payload fields, `status` (`new` | `triaged` | `closed`, default `new`) and `triaged_at`. Add an index for the rate-limit lookups.
- [ ] Returns `201` with `{ "id": "…" }`, so the app can show a reference.
- [ ] Rate limits as described above, tested.
- [ ] The cron job also deletes `feature_requests` rows older than 12 months, in the same batch as the check-in roll-up.
- [ ] Tests in `requests.test.js` on the same `node:sqlite` harness as `checkin.test.js`: validation, limits, retention, and a check that `/v1` is unaffected.
- [ ] Add a feature-requests section to `workers/checkin/README.md` covering the endpoint, the migration, and a smoke test that includes deleting the test row.

## Notes

Deploying needs Steve: auto mode blocks `wrangler d1 migrations apply --remote` and `wrangler deploy`. Hand him the commands, then smoke-test the live endpoint and delete the test rows afterwards.