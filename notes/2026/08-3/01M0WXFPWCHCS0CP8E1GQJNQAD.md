---
id: 01M0WXFPWCHCS0CP8E1GQJNQAD
created: 2026-08-25T16:54:02.892203Z
updated: 2026-08-25T16:54:09.386944Z
type: task
title: An admin can reset a local user's password — a one-time password, shown once
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 405
sprint: sbph5q5
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
There is no admin path to a user's password today. Creating an account takes an initial password, and after that the only route is the user's own Forgot password email — so an admin faced with someone locked out has nothing to offer.

**Decided with Steve, 2026-08-25:** Compass generates a strong password, shows it to the admin **exactly once**, and that is the only time it exists in readable form. Same shape as the joiner one-time passwords in the Access section (`access_requests.view_onetime_passwords`), and it works when email doesn't.

**One deliberate difference from the JML flow:** that one stores the passwords encrypted so they can be viewed once *later*, because provisioning happens asynchronously. Here the admin is the one performing the act, so the password is returned in the response to their own request and **never persisted in any form** — not encrypted, not queued, not emailed. Nothing to leak afterwards, and "shown once" is then a fact rather than a policy. Say so in the code, or someone will later "fix" it into matching JML.

## Backend

- [ ] `POST /users/{user_id}/reset-password`, `require_admin`. Generates a strong password, writes the argon2id hash, returns the plaintext in the response body and nowhere else.
- [ ] **Refuse for Entra-provisioned accounts** — they never hold a local password (ADR 0046 §7). 422 naming the reason, not a silent no-op.
- [ ] **Invalidate every session the user holds** (`core/sessions.py`). A reset that leaves an existing session alive is not a reset — this is the case where the account is suspected compromised.
- [ ] Leave API tokens alone, and say so in a comment: they are a separate credential with their own lifecycle, and revoking them silently would break integrations the admin was not thinking about. Worth a follow-up if it turns out to be wanted.
- [ ] Allowed against a **disabled** account — resetting before re-enabling is the normal recovery order.
- [ ] Activity log row attributed to the admin: "Reset the password for <user>". **The password must never reach a log line** — check it against the redaction list, and assert that in a test rather than by reading the code.

## Frontend

- [ ] "Reset password" on the Users admin screen, beside Disable.
- [ ] A modal showing the generated password once: a copy button, and unambiguous wording that closing the dialog loses it for good. No second chance to view, because there is nothing left to view.
- [ ] The Entra refusal surfaces as an explanation on the screen, not a raw error — "This account signs in with Entra ID and has no Compass password."

## Tests

- [ ] The returned password logs in; the previous one does not.
- [ ] Existing sessions for that user are rejected immediately after a reset.
- [ ] An Entra-linked account is refused.
- [ ] Non-admins are refused.
- [ ] The generated password appears in no log record (caplog at INFO across the call).