---
id: 01M73QCHFKHNH35P0021RQ8YQT
created: 2026-11-10T21:56:19.571521Z
updated: 2026-11-10T21:58:57.632757Z
type: task
title: 'App sign-in: a service''s account can sign in with a private key that signs a short-lived token exchanged for an access token — every step declared in the integration''s settings, the key write-only'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1707
sprint: sj4f1kj
blocked_by:
- 01M73QBT1QP9E6549CQ1C4XX5Y
- 01M73Q8M80365XPSJR7G8BG302
assignee: steve
label:
- feature
priority: high
task_status: todo
---
ADR 0146 §2 (COM-1705). Some services only open their fullest read-only view to an "app" rather than a person's token. GitHub is the first: an organisation's fine-grained tokens and its Actions secrets can only be listed by a GitHub App.

**Chain:** on the chain — migration + API (a new sign-in method, and the account gains a write-only private key)

## What the person sees

- **App sign-in** joins the sign-in methods on a Collection integration. Its settings:
  - the token's **claims**, as name and value pairs: the app's ID from the account, the issued and expiry times (from now and a lifetime), and fixed values;
  - the **algorithm** (RS256 or ES256);
  - an optional **lookup** step: a GET, signed with the short token, whose answer gives a value for the next step (e.g. the installation's ID found from the organisation's name);
  - the **exchange** address that takes the short token and returns the access token, and where the token and its expiry are in the answer;
  - how the access token is then sent (bearer, or a named header).
- **On the account** (on screen only, ADR 0142 COM-1659): the app's ID, and the **private key** pasted once. It's never shown again, and the key's hint is never returned.
- The access token is cached until shortly before it expires and fetched again after that. A replaced private key takes effect at once.
- The exchange is the one write-like request allowed, as the client-credentials token request already is (ADR 0142 §7): a POST to the declared exchange address only.

## Done when

- Tested against a fake service: signing, the lookup, the exchange, caching and expiry, a replaced key, a refused exchange (with the service's words, COM-1662's pattern), and a private key that never appears in logs, errors, Activity or tool output.
- Polaris's define job and the assistant tools (COM-1702, COM-1703, ADR 0142 COM-1659) can set up App sign-in from a service's documentation. The key stays on screen.
- No service name in code (COM-1696). The GitHub specifics live in the GitHub service's settings, not in `client.py`.

## Notes

- `core/github.py` is today's coded version. Read it for the edge cases (cache keyed by the stored key, Link header host check), but don't import it.
- `models/collection_integration.py` `SignIn` enum. The private key goes with `core.secretbox`, like other account keys. PyJWT is already a dependency.