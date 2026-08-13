---
id: 01KZDRKXGZ234RPNCKBHEENEYC
created: 2026-08-07T09:24:39.583445Z
updated: 2026-08-13T19:00:30.158453Z
type: task
title: Role Matrix ADR + tier-tagged tool registry with derived parity tests
project: 01KX671DATY39VW6GWK3M2T3DN
number: 596
sprint: snk16ew
comments:
- id: 01KZDXTDRDHVJNZYP2EPG7BYNJ
  author: Steve Vine
  at: 2026-08-07T10:55:35.693466Z
  text: |-
    Done — PR #511 (branch feature/ise-596-role-matrix-tool-tiers). ADR 0090 written; Canon recorded as a CANON ADDITION comment (matching the convention already used on that memo — see below).

    **The gap was bigger than the task said.** The task named `get_affected_entity_context` as the known miss. It was actually FOUR read tools Assist lacked: `search_signals`, `find_relevant_history`, `search_events` and `get_affected_entity_context`. Assist goes 21 → 25 tools. That is the user-visible proof — "has this happened before?" and "what else fired around this?" are questions it structurally could not answer before.

    **Why the frozen list could never have caught it.** The old test asserted Assist's list WAS a particular set of 18 names. An allow-list can only say what a surface IS, never what it OUGHT to contain — so when read tools were added to issue-chat and not to Assist, nothing failed. Assist replying "I have no way to search past incidents" was, to the suite, correct behaviour. This is the same shape as the Sprint 47 finding: the two halves that had to agree lived in different files and nothing compared them.

    **What shipped.** `ai/tool_tiers.py` declares the tier once (READ / INCIDENT_LOG / GATED_EXECUTE) and each surface declares the tiers it gets. Assist declares exactly one, and that is the containment argument in full: it cannot act because no acting tool is REACHABLE, not because it was asked nicely. Derived assertions replace the frozen list — read parity across both conversational surfaces, a negative assertion that no acting-tier tool reaches Assist (guarded so it cannot pass vacuously if the tiers were ever emptied), and a strict-superset assertion for the Incident Screen. Kept the ADR 0023 writing probe: the tiers are about the surface, the probe is about the guard, and ISE-54 says a documented control nobody exercises is not a control.

    **MCP parity needed a different mechanism.** The matrix's invariant says "all three interfaces", but MCP is a separate registry with its own names and shapes (`search_estate` vs `find_estate_entities`), so name-matching parity would simply fail — and asserting nothing lets it decay silently. `MCP_READ_PARITY` maps every read tool to its MCP equivalent or an explicit None with a reason, and a test requires an entry for each. Adding a read tool now FORCES a decision about Claude Code. Every named equivalent is checked to actually be registered, so the map cannot rot into fiction.

    **One thing could not just be moved.** `get_affected_entity_context` reads `deps.db` and `deps.issue_id` — neither exists on a chat run, and Assist has no incident at all. Adding it to ASSIST_TOOLS would have crashed at first call. It now exists twice, once per session mechanism, under one model-facing name (the CHAT_EVIDENCE_TOOLS rename precedent): the chat twin takes the incident id explicitly and opens its own read-only session per call. Recorded in the ADR as a real seam rather than left to be rediscovered.

    **Scope kept honest.** The tiers cover the CONVERSATIONAL surfaces. The single-shot agents (diagnose / propose-remediation / analyse-issue) use the run's shared session and keep their lists in ai/tools.py — stated in the ADR §Consequences. The role-gate drops (Assist ask → viewer, incident status/merge → responder) are a separate task and deliberately not entangled with this one. The matrix's fourth invariant (MCP gated-write verified end to end) is explicitly NOT claimed here — that is ISE-595.

    Full backend suite 2476 passed, ruff + mypy strict clean, no api-types drift. All ADR cross-links verified to resolve — worth noting ADRs 0055 and 0089 contain pre-existing broken links to filenames that do not exist (e.g. 0022-assist-chat.md, 0067-teams-notifications.md); 0090 adds none, but those are worth a tidy-up sometime.

    Canon: the memo body is ~106KB and update_note is a full-body replacement, so I did not rewrite it — a transcription slip would corrupt a living document and other sessions may be editing it. The memo already carries several "CANON ADDITION (date) — fold into the body on next edit" comments, so I followed that convention. Say if you want it folded into the body properly.
assignee: steve
label: null
priority: medium
task_status: done
tech: null
---
Formalise the "ISE Role Matrix" memo (Notuvia, 2026-08-07) as an ADR and make its invariants structural.

- ADR: the three-interface capability matrix (Assist / Incident Screen / Claude Code-MCP × Read / Write / read-only Execute / T0–T3 / BreakGlass), the rulings (proposals under gated Execute; Write = domain writes, audit exhaust exempt), and the role axis (cumulative ADR 0015 roles; token-never-outranks-owner over MCP; BreakGlass a per-user grant).
- Refactor: tag each AI tool with its tier (read / incident-log write / gated execute) in one registry; each surface declares the tiers it gets, replacing hand-assembled lists (`ASSIST_TOOLS` etc.).
- Tests: replace the frozen Assist allow-list with a derived parity assertion — every read-tier tool reaches all three surfaces (closes the known gap: Assist lacks `get_affected_entity_context`). Keep the writing-probe test.
- Record the decision in ISE Canon.

Headless-plus-tests slice by nature; the user-visible proof is Assist gaining the missing read tools, exercised by the question bank.