---
id: 01M3KZH6MVXRQFRJQ2F2S8QMRJ
created: 2026-09-28T12:23:44.539421Z
updated: 2026-09-28T12:54:16.53051Z
type: task
title: Feature-request endpoint on the check-in Worker, plus ADR 0065
project: 01KY6W9951TW0904DT0GGJVGE7
number: 467
sprint: svg0tvg
comments:
- id: 01M3M0YE58H1DQNRGCVKERWCPB
  author: Steve Vine
  at: 2026-09-28T12:48:26.790096Z
  text: |-
    Built. PR #472 (brief-467-feature-request-endpoint), in Review. ADR 0065 lands with it, and ADRs 0050/0051 are marked superseded.

    What landed:
    - POST /v1/requests on the notuvia-checkin Worker, with the logic in src/requests.js. /v1 is unchanged.
    - The payload is closed. Anything invalid gets a 4xx and stores nothing. A valid request gets 201 with a 10-character Crockford base32 id.
    - Limits: 5 per install in any rolling 24 hours and 200 per UTC day overall. Both are checked inside the INSERT, so they hold under concurrent requests, and both return 429.
    - Migration 0002_feature_requests.sql adds the table, with status new/triaged/closed.
    - The cron now prunes requests older than 12 months as well as running the check-in roll-up. The two jobs are independent (allSettled), so one failing doesn't stop the other.

    Changed from the task text:
    - The body limit is 16 KiB, not 8 KiB, so the largest valid request (4000 emoji of details) still fits. This is measured in UTF-16 units, the same way the check-in measures.
    - The prune runs next to the roll-up rather than in the same D1 batch. Nothing links the two jobs, and a failed roll-up shouldn't keep emails past retention.
    - The test harness moved to src/fakeD1.js. It applies every migration and returns D1-shaped run() results.
    - .wrangler/ is now gitignored. Its local D1 file had test rows in it.

    Verification: 403/403 npm tests passed (18 new). The pre-push hooks all passed. In a local wrangler dev run, five requests got 201 and the sixth 429, {} got 400, GET got 405, /v1 got 204, and the cron ran. The wrangler dry-run build succeeds.

    Not done: the deploy. Steve needs to run `npx wrangler d1 migrations apply notuvia-checkin --remote` and then `npx wrangler deploy` from workers/checkin/. Then smoke-test and delete the test rows as the README describes.
- id: 01M3M192BQXBAZ5QQ4K7HPDVY4
  author: Steve Vine
  at: 2026-09-28T12:54:15.159108Z
  text: |-
    Deployed on 2026-09-28. Steve applied migration 0002 remotely and ran wrangler deploy.

    Live smoke test:
    - a valid POST to /v1/requests gave 201 with id VM44H3AHXA, and the row was stored with status new and details null
    - {} gave 400, and a GET gave 405
    - /v1 check-in still gave 204
    - the test rows in feature_requests and checkins have been deleted, and feature_requests is empty

    Merged as db946a1 (squash, PR #472), with CI green. The branch is deleted.
assignee: steve
label:
- feature
priority: high
task_status: done
tech:
- cloudflare
---
The server half of in-app feature requests. It lands first, so the app has somewhere to send. ADR 0065 lands with this PR.

## ADR 0065: in-app feature requests go to the Worker (supersedes ADR 0050 and 0051)

Record these decisions (agreed with Steve on 2026-09-28):

- **Requests are written in Settings → Request a feature**, a pane listed directly under About with the `lightbulb` icon. **Help → Request a Feature…** opens Settings on that pane. The request goes to the developer through the check-in Worker. Every install does this, including Steve's. The vault-local filing from ADR 0050/0051 (`feature_project`/`feature_sprint`, the "Where do feature requests go?" prompt) is **removed, not kept as an option**.
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