---
id: 01KZM1MGQHK960CCH30ZBK9670
created: 2026-08-09T19:57:43.025695Z
updated: 2026-08-10T20:49:24.947225Z
type: task
title: '"No applicable playbooks" never says why — including when matching was impossible'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 634
sprint: s1rgnyx
comments:
- id: 01KZPPZN8WTC2GEE0QJ175VBPH
  author: Steve Vine
  at: 2026-08-10T20:49:17.083711Z
  text: |-
    Built and merged to main 2026-08-10 — `87315fb` (PR #585).

    `explain_no_match(db, issue, desk_only=…)` returns `(reason, sentence)`. Four reasons, and the two that matter most are the ones an operator cannot diagnose from outside:

    - `no_subject` — the incident does not say what kind of problem it is
    - `no_playbook_of_kind` — nothing written for this kind yet
    - `scoped_elsewhere` — playbooks for this kind exist, scoped to other entities (invisible while being a perfect match for the kind)
    - `none_published` — matches exist, but none is desk-executable (invisible to the desk while visible to everyone else)

    **`desk_only` turned out to be the load-bearing distinction.** The desk asks "what can I RUN", which has one more way of coming up empty than "what applies" — and the guided page previously had no way to express that difference at all. The test asserts both halves at once: the playbook *applies* (`match_playbooks` returns it, `explain_no_match` is silent) and the desk still cannot run it.

    Surfaced on four places in one commit, since an explanation only one surface shows is half a fix: the guided desk empty state, the incident's Recall response, the MCP incident brief (where Claude Code forms its first opinion — a bare empty list there becomes "there is no playbook for this" in the next sentence it says), and the MCP `find_playbooks` tool. [ISE-631] then carried it to Assist.

    Authoring-time validation is not here — it landed in [ISE-632] as the closed vocabulary, which is the better place for it: a kind that matches nothing is now unrepresentable rather than flagged after the fact.

    Tests: 5 backend (each reason, plus a real match explaining nothing) + 2 frontend. Full CI green.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Found 2026-08-09, and it is what turned three separate faults into an hour of looking in the wrong place.

Asked whether any playbooks applied to an incident, ISE answered **no**. That single word covered four completely different situations, three of which are ISE's problem and not the operator's:

| What was actually true | What the operator was told |
| --- | --- |
| The incident is manual, so matching returns `[]` before anything is considered | "No applicable playbooks" |
| A playbook exists but its `kind` ("Not responding") matches no finding kind (`server_unreachable`) | "No applicable playbooks" |
| A playbook exists but was never published desk-executable | "No applicable playbooks" |
| There genuinely is no playbook for this | "No applicable playbooks" |

Only the last one is a fact about the estate. The other three are facts about ISE's own configuration, and each has a different fix — but they are indistinguishable, so the operator reasonably concluded the playbook they had just written did not exist.

**The principle this violates** is the one the preflight failure categories were built on: a row never says only "unreachable", it names the missing precondition, because the person who can fix it is often not the person looking at it. The same standard should apply here. "No playbooks match" is the "unreachable" of this surface.

**Scope**
- `match_playbooks` returns a reason alongside the (possibly empty) list: no finding to key on / no playbook of this kind / matches exist but none published / genuinely none.
- Surface it wherever the empty answer is rendered — the incident screen, the MCP brief, and the Assist tool from [ISE-631]. An explanation that only one surface shows is half a fix.
- Authoring-time help is the other half: a playbook whose `kind` matches no known finding kind should say so when it is saved, not stay silently inert forever. See [ISE-632] — if `kind` becomes a chosen vocabulary rather than free text, most of this disappears at source.

**Acceptance**: an incident with no matching playbooks says which of the four reasons applies; a playbook authored against a kind nothing emits is flagged at authoring time; the same explanation appears in the app, the MCP brief and Assist.