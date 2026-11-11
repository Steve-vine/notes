---
id: 01M74YVJA3Q7HVXWT5499PWFM1
created: 2026-11-11T09:26:06.40352Z
updated: 2026-11-11T17:31:38.51359Z
type: task
title: A feed's Preview reads a sample when it has many follow-on reads, a refused app sign-in says which step failed, and a key made of several parts gets a box for each
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1722
sprint: sj4f1kj
comments:
- id: 01M75CFYREN2GK6GVC26F4G9Z5
  author: Steve Vine
  at: 2026-11-11T13:24:25.998222Z
  text: |-
    Built and merged to main (PR #1721, 2026-11-11). On the chain: migration 0809 adds a service's key format. Goes to staging with the sprint.

    1. Preview reads a sample. A feed with many follow-on reads previews only the first 25 per read. The note says so, e.g. "Preview read a sample: the follow-on reads for 25 of the 247 items /installation/repositories listed. A run reads them all. Nothing is counted as closed for being missing." Scheduled runs are unchanged.
    2. A refused app sign-in says which step failed:
       - Lookup 404: "The app sign-in's lookup was refused: /orgs/acme/installation answered 404. The service found no installation of this app for acme. Install the app on acme, then test again."
       - 401 or 403: check the app's ID and private key, or the app may lack a permission.
       - The service's own words follow, as before.
    3. A key made of several parts:
       - On Settings, a service with "API key in a header" has "How the key is put together (optional)", e.g. accessKey={Access key}; secretKey={Secret key};.
       - The account form then shows a box per part, when adding and when replacing a key.
       - Compass puts the parts together and keeps only the result, encrypted, with no hint. Parts are never shown, returned or repeated in an error.
       - Without a format, an account has one key, as before. Polaris and the assistant tools can propose the format.

    Tests: a fake service for the step messages; a 247-repository feed previewing 25 through the API and closing nothing; key parts (needed, assembled into the header the service receives, never returned, replacing needs every part, format removed later); account form screen test.

    Still to do on staging after the deploy:
    - Me: set Nessus's key format.
    - Steve: re-enter the Nessus account as two keys (Access key, Secret key), on screen only. Until then the existing key keeps working.
- id: 01M75EHM7WXZCPZMF40W8T9S05
  author: Steve Vine
  at: 2026-11-11T14:00:17.915881Z
  text: |-
    Pre-UAT on staging (bb59b9a2), 2026-11-11:
    - **Key in several parts: Passed.** I set Nessus's key format to accessKey={Access key}; secretKey={Secret key}; through the assistant tools. Its account still signs in with the existing key. As E2E Admin A, Nessus ▸ Accounts ▸ Add an account shows an "Access key" box and a "Secret key" box, and no single "API key" box. Nothing was saved. Screenshot: ~/compass-uat/sj4f1kj/COM-1722/.
    - **Preview sample: Passed.** Nessus's Findings preview came back within the request with "Preview read a sample: the follow-on reads for 1 of the 22 items /scans listed. A run reads them all. Nothing is counted as closed for being missing." Before, it timed out.
    - **App sign-in step messages: Couldn't check on staging.** It needs an app that isn't installed. Covered by tests with a fake service.

    Steve: re-enter the Nessus account as two keys on its Accounts tab (Replace secret now asks for both).
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Found setting up the GitHub App, Aikido and Nessus on staging (COM-1713/1714/1715), 2026-11-11.

**Chain:** on the chain (3 adds a setting to a service's definition and the account's key parts: migration + API)

1. **Preview times out on a big follow-on feed.** The GitHub App's "Deploy keys" and "Actions secrets" feeds make one follow-on read per repository: 247 for Moneypenny-Development. Nessus's Findings reads through 69 scans. Preview runs within the web request, so it times out. Scheduled runs on the worker aren't affected.
   - Preview should read the first 25 follow-on reads, say "Preview read 25 of 247 repositories", and show the records from those.
   - A partial preview counts nothing as closed.
2. **"The service refused the app sign-in (404)" doesn't say which step.** The lookup and the exchange give the same sentence. It should name the step and what it asked for, e.g. "GitHub has no installation of this App for Moneypenny-Development (the lookup /orgs/Moneypenny-Development/installation answered 404). Install the App on it, then test again."
3. **A key made of several parts gets a box for each.** Nessus signs in with one header holding two keys, `X-ApiKeys: accessKey=…; secretKey=…;`. Today the account form shows a single "API key" box, and the person must know to type both keys into it in that exact format.
   - A service using "API key in a header" can say how its key is put together, e.g. `accessKey={Access key}; secretKey={Secret key};`. Each `{…}` names a part.
   - The account form then shows one box per part, labelled with its name. Compass assembles the header from them.
   - Every part is kept encrypted and is write-only, like any key: never shown again, and no hint. Replacing the key asks for every part again.
   - No service name in code: the format is the service's setting. Polaris's define job and the assistant tools can propose it.
   - Existing accounts keep working: with no format set, the box is the whole header value, as today.

## Done when
- A feed with hundreds of follow-on reads previews within the request, with the sample stated, and nothing counted as closed.
- A refused lookup and a refused exchange each say which step, the path and the service's words. Tested against a fake service.
- A service with a key format shows a box per part on the account form, and a fake service receives the assembled header. Parts are never returned, logged or shown. An account without a format behaves as before.
- Nessus on staging is moved to the format, and its account is re-entered as two keys.