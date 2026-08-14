---
id: 01KZXKYB7ENK595VDAK6DC6KM7
created: 2026-08-13T13:10:49.326415Z
updated: 2026-08-14T08:49:16.417488Z
type: task
title: The guided view's "resolve on green" button has also been dead since ISE-642
project: 01KX671DATY39VW6GWK3M2T3DN
number: 687
sprint: sevhjex
comments:
- id: 01KZY0M84Q690W1BEXW7VWXWBF
  author: Steve Vine
  at: 2026-08-13T16:52:29.974974Z
  text: |-
    2026-08-13 — DONE, PR #638 merged to main.

    **It does not prompt, as the task directed.** The note is composed from the completed run: `Resolved by the playbook "<name>", which ran here and passed its validation checks. <run summary> Run <id>.`

    To make that accurate, `playbook_name` joins the `playbook_run` evidence pointer — it was not there before, and "a playbook ran" is not an account of what was done; the name is the part that teaches. Runs that predate the key have no name to quote and get "Resolved by a playbook that ran here…" rather than an invented one. A test covers that path explicitly.

    **On the note standing alone.** The task asked that it read correctly in Recall and on the timeline. It is written with no deixis — it never says "this", "above" or "the card below", and a test asserts the absence, because what makes a resolution note fail months later is that it was written as a caption for a screen nobody is looking at any more.

    **Failure now reports the server's `detail`.** "Try again." was advice rather than a reason, and wrong for every refusal this endpoint issues — including the 422 that was firing.

    **The sweep, completed.** Every caller of `PATCH /issues/{id}/status`:

    | caller | note? |
    |---|---|
    | `IssueDetailPage` | yes, since ISE-642 |
    | `IssuesPage` bulk | was broken → ISE-686 |
    | `GuidedIncidentView` | was broken → this |
    | MCP `update_incident_status` | yes, and re-raises the refusal as a ToolError |
    | AI `ticket_tools.set_status` | yes, and returns "ISE refused the transition: …" |
    | merge cascade (`cascade_status_to_children`) | transitions children internally; never reaches the check |

    The two frontend callers were the only broken ones. Both fixed.

    **One thing I found and did NOT change, worth a decision later:** `silence_alert` (`severity_api.py`) resolves live incidents by setting `issue.status = "resolved"` directly, bypassing `apply_status_change` — so those incidents end up resolved with `resolution_note` NULL. It is not broken (no 422; the "why" is written to the timeline as an `alert_silenced` audit row per ISE-557), but Recall has nothing to serve for them, which is the same gap ISE-642 existed to close. Composing a note there — "resolved automatically: the alert '<title>' was silenced by <actor>" — would be a small, clearly-right follow-up. Left out to keep this scope honest.

    **Test note.** The new tests drive the real sequence — run the playbook, then let the incident come back carrying its verdict — because the resolve button only exists once a run started in *this session* has landed. A bare RTL `rerender()` cannot be used to swap the issue prop: `renderWithProviders` wraps the element rather than passing a `wrapper`, so rerendering drops MantineProvider and the component explodes. A small stateful harness swaps it instead.

    3 new tests, all green; ruff, mypy strict, prettier, eslint, build green; PR CI green including the 9m26s integration job.
assignee: steve
label:
- bug
priority: high
task_status: done
tech: null
---
Same root cause as ISE-686, different surface and a different right answer.

`GuidedIncidentView.tsx:109` — the resolve button shown after a playbook run lands green — sends `body: { status: 'resolved' }` with no note. Since ISE-642 made the note mandatory in `apply_status_change` (2026-08-10, PR #588), it 422s on every click. Found while diagnosing ISE-686; not separately reported, which is worth noting — a button at the end of the guided workflow has been failing for three days without a report.

**This one should NOT prompt.** Unlike the bulk case, the account of what was done already exists: a playbook ran, it went green, and the run is the answer to "what was done". Composing the note from the run — the playbook's name and the run's verdict — is both more accurate than anything an operator would type at that moment and true to why ISE-642 exists, which is that Recall should serve the next operator something that teaches. A prompt here would collect "ran the playbook", which the timeline already knows.

**Scope**
- Compose the note from the completed run (playbook name + verdict + run id) and send it with the transition.
- Verify the note reads correctly in Recall and on the timeline — the composed sentence is what a future operator sees as this incident's resolution, so it must stand alone without the surrounding UI.
- Surface the server's `detail` on failure rather than the generic "resolve failed"; the mutation currently throws a fixed string.
- A test that asserts the composed note reaches the request body. The existing guided-view tests stub the API and never inspect it — the same gap that hid ISE-686.

**Sweep before closing.** Two of three callers of `PATCH /issues/{id}/status` were broken by one backend change and both stayed green. Enumerate every caller of that endpoint (frontend, MCP action tool, merge cascade, any playbook step) and confirm each supplies a note where the transition requires one.