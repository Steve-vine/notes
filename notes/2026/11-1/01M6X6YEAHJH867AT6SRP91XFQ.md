---
id: 01M6X6YEAHJH867AT6SRP91XFQ
created: 2026-11-08T09:13:33.777565Z
updated: 2026-11-08T09:29:53.348808Z
type: task
title: A Collection integration can set its own Accept header when the service picks its API version that way (MongoDB Atlas) — and a header Polaris can't use is left out and flagged, not a failed definition
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1640
sprint: s5khbev
assignee: steve
label:
- bug
priority: high
task_status: active
---
Raised by Steve while testing sprint 107 on staging (2026-11-08). Adding a new integration for MongoDB Atlas with Polaris, the define step stopped with:

> Polaris couldn't finish
> Polaris's extra headers can't be used: Compass sets Accept itself

## The problem

Two things go wrong together:

1. **Atlas picks its API version from the Accept header.** The Atlas Admin API v2 needs `Accept: application/vnd.atlas.<date>+json` (e.g. `application/vnd.atlas.2025-03-12+json`). With plain `application/json` it won't serve v2. COM-1624 put Accept on the list of headers nobody may set, because Compass sends `Accept: application/json` itself. For services like Atlas, that rule is wrong.
2. **One unusable header sinks the whole definition.** Polaris proposed a header Compass refuses, and instead of dropping that one header, the whole define step failed. The person is left with nothing, and the message talks about Compass's internals.

## Done when

- **Accept can be set** on an integration, but only to a JSON media type: `application/json`, or any `application/<something>+json`, with or without parameters (`application/vnd.atlas.2025-03-12+json`, `application/vnd.github+json`). Compass sends it instead of its own `application/json` on every request: the test read, samples, every collection and every page. Anything that isn't JSON is refused in words ("Compass reads JSON, so Accept must be a JSON type"). The other reserved headers (Host, Authorization, the sign-in key header, Cookie, Content-*) stay reserved.
- **A header Polaris proposes that Compass can't use is left out**, not fatal. The rest of the definition is kept, and the left-out header shows under "Check before you save" (COM-1621), saying what was left out and why in plain words. The form still refuses such a header outright when a person types it in.
- **Polaris's define prompt** says that Accept may be set to a versioned JSON type when the docs ask for it, and that the other reserved headers may not.
- **The definition form** accepts Accept as an extra header under the same rule.
- **Tests:**
  - an Accept override is sent on every page of a paged read in place of `application/json`;
  - a non-JSON Accept is refused;
  - a Polaris proposal with a reserved header (e.g. Authorization) keeps the rest of the definition and yields a "Check before you save" note.
- **On staging:** defining MongoDB Atlas with Polaris fills in the versioned Accept header and finishes. The test read against a real Atlas project needs Steve's Atlas key, so that part is Steve's to check.

## Notes

- This is independent: no migration, since headers are already kept on the definition (COM-1624, 0792). It changes no API shape, only what's accepted.
- Where:
  - `core/collection/client.py`: `RESERVED_HEADERS`, `check_headers`, `_headers` (the token request's own Accept stays as it is);
  - `core/collection/polaris_define.py`: the `headers` handling around `check_headers` (raises `NotFilled` today), plus `_notes` and DEFINE_SYSTEM;
  - `integrations/collection/DefinitionForm.tsx` (ExtraHeaders).
- It relates to COM-1624 (extra headers) and COM-1621 ("Check before you save").