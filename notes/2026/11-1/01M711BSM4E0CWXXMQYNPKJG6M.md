---
id: 01M711BSM4E0CWXXMQYNPKJG6M
created: 2026-11-09T20:52:57.604302Z
updated: 2026-11-09T20:59:26.629032Z
type: task
title: A failed Collection test says what the service said, and an assistant can run an account's test — so a wrong setting can be told apart from a wrong key, on screen and in chat
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1662
sprint: sjvqrdg
blocked_by:
- 01M711A9RCC3BXNEBD320M5PK4
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Part of the change recorded in COM-1659. On 2026-11-09 Steve's Cloudflare account failed its test with "The service refused the sign-in (401). Check the key." The key was fine; the test read was wrong for that kind of key (COM-1658). Compass had thrown away Cloudflare's own answer, so neither Steve nor an assistant could tell a bad key from a bad setting without someone reading the code and the database.

## What the person sees

- **A failed test keeps the service's own words** after Compass's sentence, on screen and in chat. For example: "The service refused the sign-in (401). Cloudflare said: Invalid API Token (1000)." For a 401 the advice becomes "Check the key, or that the test read suits this kind of key" rather than just "Check the key".
  - Where the service answers in JSON, Compass takes its error message fields (`message`, `error`, `error_description`, `errors[].message` and their codes). Otherwise it takes the first line of text.
  - It's trimmed to a sentence or two (about 300 characters).
  - Anything shaped like a key or token is blanked, using the same judgement as ADR 0142's capture rules.
  - A service that says nothing useful (an HTML page, an empty body) adds nothing.
- **The same words show** wherever the test result does: the account row, the integration's state, the owner's Fix sign-in action, and Polaris's "Why did the test fail" job, which reads them too.
- **An assistant can run an account's test:** "Test the Cloudflare account again." It runs the same test as the **Test** button and reports Connected and what came back, or why it failed, with the service's words. That's one GET of the test read, so nothing in the service changes. With COM-1661, the assistant can then fix a wrong setting and test again until it passes.
- **Accounts stay on screen:** the tool only tests. It never adds, renames or removes an account, and never takes or returns a key, username or key hint.

## Done when

- A failed test's message carries the service's own words as above, saved with the account's health.
- A new chat tool tests one account, chosen by integration and account name with the company. It needs Manage integrations. It isn't `always_ask` (it reads; its description says so) and is recorded in Activity like a Test button press, if that is recorded today.
- `posture_list_collection_integrations` shows the fuller message.
- Tests:
  - a 401 with a JSON error body keeps the message and code;
  - a token-shaped value in the body is blanked;
  - an HTML or empty body adds nothing;
  - it's trimmed;
  - the chat tool returns the result;
  - the chat tool is hidden without Manage integrations;
  - no tool output contains a key hint or username;
  - the pinned tool-count and tool-name tests are updated.
- **Pre-UAT on staging**, in E2E Test Company:
  - break the "E2E GitHub public (test)" account's sign-in on screen (switch it to bearer with a bad key);
  - ask a connected assistant to test it, and check it reports GitHub's own words;
  - put it back on screen.
- **For Steve:** a Cloudflare account token against a user-only test read now shows Cloudflare's message.

## Notes

- **Independent:** the message is still a string. No migration, no API shape change.
- Where:
  - `core/collection/client.py` (`_answer`: read and trim the body before raising `CollectionError`; the token-address errors around line 522 too);
  - `core/collection/accounts.py` (`test_account`);
  - the tool in `assistant/tools/posture_collection.py` or COM-1661's module, calling `POST /collection-integrations/accounts/{id}/test`.
- Respect the log-redaction list: don't log the raw body.