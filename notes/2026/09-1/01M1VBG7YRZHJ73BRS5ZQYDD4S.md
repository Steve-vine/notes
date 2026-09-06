---
id: 01M1VBG7YRZHJ73BRS5ZQYDD4S
created: 2026-09-06T12:36:13.400189Z
updated: 2026-09-06T17:01:23.938741Z
type: task
title: 'the SharePoint site grant cannot complete: the popup comes back from Microsoft and Compass says "Not authenticated"'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 585
sprint: s2fcksg
comments:
- id: 01M1VPB8HN9TZCHK4EEZXHNAXE
  author: Steve Vine
  at: 2026-09-06T15:45:44.501094Z
  text: |-
    Done — PR #600 merged to main.

    The grant callback no longer needs the session cookie. It authorises itself from the one-time state the wizard wrote at start: that state names who started the attempt, and they must still be active and still allowed to manage integrations. If not, the popup says so politely and the state is spent. The grant is attributed to that person. The cookie stays SameSite=strict — nothing about the app's CSRF posture changed.

    Tests: the full wizard flow now completes the callback with no cookie at all; a replay fails politely; a user disabled between start and callback is refused before anything reaches Microsoft.

    The README already names the shipped callback path (/api/v1/integrations/m365/grant/callback), so no wording change there.

    To smoke-test on staging: with the redirect URI from COM-584 registered on the Microsoft 365 app, Admin → Integrations → Microsoft 365 → Site access → "Sign in & grant" should now complete in the popup.
assignee: steve
label:
- bug
priority: high
task_status: done
---
**The Site access wizard cannot grant anything on a deployed environment.** The admin signs in at Microsoft, the popup returns, and Compass rejects its own callback:

```json
{"error":{"type":"http_error","message":"Not authenticated","detail":null}}
```

Seen on staging 2026-09-06 12:02 (two attempts). The API log shows Microsoft returning a valid code and the callback refusing it:

```
POST /api/v1/integrations/m365/grant/start                200
GET  /api/v1/integrations/m365/grant/callback?code=…      401
```

## Why

`site_grant_callback` requires a signed-in admin (`Depends(require_manage_integrations)`), and the session cookie is issued `SameSite=strict` (`AUTH_COOKIE_SAMESITE=strict` — the chart default since the first commit, and what is live on staging). A browser will not send a strict cookie on a navigation that arrives from `login.microsoftonline.com`, so the callback sees no session and 401s before it can spend the code.

Not a regression. The callback has required a session since the wizard was built (COM-135, 2026-07-02) — COM-549 only swapped `require_admin` for `require_manage_integrations`, which would 403, not 401 — and the cookie setting has never changed. The wizard was closed the same day it was written; the headless `scripts/m365/grant_site.py` is the path that has actually been granting site access, and it never touches a browser session.

The sign-in callback is unaffected: it creates a session rather than requiring one.

## Fix

Authenticate the callback by its own one-time state, not by the cookie:

- [ ] Drop the `require_manage_integrations` dependency from `GET /m365/grant/callback`.
- [ ] Authorise from the Redis state instead — it is already per-attempt, single-use (`getdel`), 10-minute TTL, and already records `user_id`. Load that user, confirm they are still active and still hold `manage_integrations`, and refuse through `_popup_result` (not a raw 401) if not.
- [ ] The audit actor for the grant comes from that user, not from the request session.
- [ ] Test: a callback with no cookie and a good state succeeds; a stale/replayed state fails politely in the popup.

Nothing is weakened by this. The grant only proceeds if Microsoft returns a valid delegated admin token, and that token — not the Compass session — is what authorises the change in SharePoint. PKCE still binds the code to the request that started it.

**Rejected alternative:** relaxing the session cookie to `SameSite=lax`. It would fix the symptom, but it changes the CSRF posture of the whole application to accommodate one popup.

## Related

- COM-584 — the same panel doesn't show the reply URL the registration needs. Found in the same session; that one is discoverability, this one is the flow being broken.
- COM-135 — the wizard this was introduced by.
- The registration also needs its Web reply URL: `https://compass.citops.net/api/v1/integrations/m365/grant/callback`. Note COM-135's brief specified `/m365/callback`; the code shipped `/m365/grant/callback`, so the README wording is worth a look while in here.
