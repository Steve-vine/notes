---
id: 01M1PKQQAYYZRSP0Q20X8194BC
created: 2026-09-04T16:23:54.97484Z
updated: 2026-09-04T16:30:11.946136Z
type: task
title: An expired session looks exactly like an empty estate
project: 01KX671DATY39VW6GWK3M2T3DN
number: 774
sprint: s7nj09w
assignee: steve
label:
- bug
priority: high
task_status: todo
tech: null
---
Smoke finding, 2026-09-04. Reported as "nothing appears in the Search the estate
box" in the Capabilities editor. The search box is fine; the session had expired.

**Evidence — `kubectl logs -n ise deploy/ise-api -c api`:**

```
15:50:34  GET /api/v1/entities?q=deepgram-license-proxy&limit=25&sort=name&dir=asc  200
16:16:08  GET /api/v1/entities?q=chinwag&limit=25&sort=name&dir=asc                 401
16:16:14  GET /api/v1/entities?q=chinwa&...                                          401
16:16:33  GET /api/v1/entities?q=a&...                                               401
```

Same request shape, same deployed image (`staging-20260904-1509`), 200 at 15:50
and 401 from 16:16 on. `EntitySearchSelect` itself was reproduced green in a
throwaway vitest against a stubbed fetch: it issues
`/api/v1/entities?q=…&limit=25&sort=name&dir=asc` and renders the results.

**The defect is that a 401 is invisible.**

1. `EntitySearchSelect.tsx:44-53` destructures only `.data` from `api.GET` and
   discards `error`. A 401, a 500 and a genuinely empty result all leave `data`
   undefined, `isError` false, and the dropdown reading **"Nothing matches"**.
   The operator is told the estate has no such entity — a confident wrong answer
   about their data, from an auth failure.
2. Nothing re-checks the session. `useCurrentUser` (`auth/hooks.ts:8-17`) caches
   `/api/v1/auth/me` and is only refetched by react-query's own rules, so once
   the cookie expires server-side the whole app keeps rendering as logged in:
   nav, page, modal, the admin-gated *Edit capabilities* button. There is no
   global 401 handler anywhere in `app/frontend/src` — the only mention of 401
   is the one that maps it to `null` inside that hook.
3. Writes are better but not good: a mutation checks `error` and shows a red
   notification, so *Save* would have said something — but only "failed", and
   only after the author had typed the whole capability list into a modal whose
   contents are about to be thrown away.

This is not scoped to Capabilities. Every read-only typeahead and every polled
panel behaves the same way against an expired session.

**Proposed**

- A single place that recognises a 401 from any API call and treats it as the
  session ending: invalidate `CURRENT_USER_KEY`, and let the existing
  unauthenticated path take over. An expired session should return the operator
  to a login prompt, not to a UI that lies about the estate.
- `EntitySearchSelect` must distinguish the three cases: read `error` from
  `api.GET`, and render "Could not search — try again" rather than
  "Nothing matches" when the request failed. "Nothing matches" is a claim about
  the estate and should only be made when the estate actually answered.
- Preserve the modal's draft across a re-login, or at minimum warn before it is
  lost.

**Also confirmed while looking**

- `EntitySearchSelect` has **no test at all**, in either of its two usages
  (`CapabilityEditorModal.tsx:176`, `ruleDrafts.tsx:159`). Neither
  `BusinessApplicationDetail.test.tsx` nor any component test opens the
  capability editor or exercises a provider search — which is why nobody saw
  what an empty search does.
- After a selection is made, the Select sets its search value to the chosen
  option's label and the debounce fires a fresh query with the whole label:
  `GET /api/v1/entities?q=deepgram-license-proxy · in deepgram-flux on cluster-envstaginguk-ekscluster`
  (15:51:03, 200, no matches). A wasted round trip that leaves the dropdown
  reading "Nothing matches" immediately after a successful pick.
- `EntitySearchSelect` and `ImpactPanel`'s AddAffected share the react-query key
  `['entity-search', debounced]` while sending different params (`sort=name,
  limit=25` vs `sort=relevance, limit=20`). Same key, different queries — one
  can serve the other's cached page.
