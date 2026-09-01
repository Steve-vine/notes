---
id: 01M1DZWZH1YF8SH8P5T8SSXCJX
created: 2026-09-01T08:03:20.225029Z
updated: 2026-09-01T08:57:57.940603Z
type: task
title: a failed save says why it failed, instead of "Something went wrong"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 554
sprint: sz42uhw
comments:
- id: 01M1E30KTRPP7FRT2HWTA2105Z
  author: Steve Vine
  at: 2026-09-01T08:57:45.048662Z
  text: |-
    Done — PR #563, merged to main (87d096f), CI green.

    New `src/api/errors.ts` is the one reader of the ADR 0004 envelope. `apiErrorMessage` reads `error.error.message`, then a plain `Error` message, then the caller's fallback; `apiError` wraps that in an `Error` and keeps the whole envelope on `cause`, so a 422's per-field detail still reaches the forms that map it back (COM-311).

    The global toast handler in `queryClient.ts` now calls it, so a mutation that throws the raw response body shows the server's sentence instead of "Something went wrong". The friendly permission line is kept and now covers the message the auth dependency actually sends — "Insufficient permissions" — as well as the older "Insufficient role"; both were unreachable through `detail`, so that line had never fired either. The 422 validation `detail` is a list and is deliberately never read, so nothing prints JSON at anyone.

    All fourteen private `errorMessage` / `extractError` / `apiError` copies are gone and their call sites use the shared pair; their specific fallbacks ("Could not save the transport") were better than the generic line and stayed.

    Three tests on the toast: the envelope's message reaches it, a permission refusal gets the friendly line, an envelope with no message falls back.
assignee: steve
company: null
label:
- bug
priority: high
task_status: review
---
Found alongside COM-553, and the reason that one needed a log dive rather than a screenshot.

**Symptom.** A save fails and the only thing the screen says is "Something went wrong". The server had in fact sent a sentence written for exactly this moment — "Vendor approver is a portal role — it is granted by the vendor and recertification screens, not here" — and the browser threw it away.

**Cause.** Every API error is the one envelope ADR 0004 settled: `{"error": {"type", "message", "detail"}}`. The single global handler that raises the red toast (`queryClient.ts`) reads `error.detail` — a plain FastAPI shape this API has never returned — so it falls through to the generic line every time. Screens that do show a real message get there by hand: roughly a dozen files each define their own private `errorMessage(error, fallback)` reading `error.error.message`. Anything that throws the raw response body instead — the Users screen's role, status and job-title saves among them — gets the generic toast, and always has.

**Why it matters more than it looks.** This is the difference between a defect Steve can report in one line and one that costs an afternoon. It is also silent: no screen is visibly broken, they just stop explaining themselves, and there is nothing to notice until something is refused.

## Fix

- Teach the one global handler the envelope: `error.error.message`, then `error.message`, then the generic fallback. Keep the friendly 403 line ("You don't have permission to do that.").
- A 422 from request validation carries a *list* under `error.detail` — the handler must not end up printing JSON at somebody.
- Lift one shared `apiErrorMessage(error, fallback)` and have the per-screen copies call it rather than each redefining the same three lines. Their specific fallbacks ("Could not save the transport") are better than the generic one and should stay.
- Frontend test: a mutation rejecting with the envelope raises a toast carrying the server's message.

Small. Worth doing before the rest of the user-admin testing, so the next thing Steve finds arrives with the server's own explanation attached.
