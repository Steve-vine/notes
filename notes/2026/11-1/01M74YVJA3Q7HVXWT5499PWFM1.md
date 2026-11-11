---
id: 01M74YVJA3Q7HVXWT5499PWFM1
created: 2026-11-11T09:26:06.40352Z
updated: 2026-11-11T12:29:23.551345Z
type: task
title: A feed's Preview reads a sample when it has many follow-on reads, a refused app sign-in says which step failed, and a key made of several parts gets a box for each
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1722
sprint: sj4f1kj
assignee: steve
label:
- bug
priority: medium
task_status: active
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