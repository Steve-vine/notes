---
id: 01KY5RWJ7S9N8G1HCN8X522T2J
created: 2026-07-22T20:39:45.657478Z
updated: 2026-07-23T18:32:57.385679Z
type: task
title: Document claim pipeline — silent drops, code-side anchoring, unknown-entity proposals
project: 01KX671DATY39VW6GWK3M2T3DN
number: 222
sprint: s5khymf
comments:
- id: 01KY5TF032SGQ9QFMGVYRNT93X
  author: Steve Vine
  at: 2026-07-22T21:07:18.242389Z
  text: |-
    **Done — PR #204** (from main). All five defects addressed; migration 0047 adds the `entity` proposal kind and `document.last_extraction`.

    **1. Silent drops.** Every claim's fate is counted *with a reason* and written to the document, logged, returned by the sweep (`claims_dropped`, never omitted even at zero), and rendered in the Claims drawer: "23 extracted · 0 raised · 23 dropped", each drop naming the claim and why. A discarded output is a legitimate result; a silent one was the bug.

    **2. Anchoring is now code, not a prompt.** You were right that the prompt threat was actively harmful. It produced neither fewer unknown names nor better claims — it produced the same claims with a *listed* name substituted in, which is how you got `prod-uk-openanswer-ekscluster routes-to chinwag-v2` from a document that says no such thing. The prompt now asks for faithful reporting and explicitly says the known list is "not a menu you must choose from"; resolution decides anchoring.

    **3. Unknown names are proposable.** New `entity` proposal kind carrying the name, the suggested type, and the relationship that justified it. Confirming creates entity + edge in one act — one decision for the reviewer, not two — and reuses an existing entity if one has appeared since (so two claims about MongoDB Atlas confirm to one row and two edges). The guard against inventing infrastructure is now the correct one: **at least one end must already be known**; neither known is refused.

    **4. Candidate list scoped** to entities the document's tags reach plus one hop, excluding machine-named rows (EC2 ids, private-DNS names, UUIDs, `runner-*`) and anything under 4 chars, capped at 80, with types included. An untagged document gets an empty list, which is honest — it reaches nothing, so it can anchor to nothing.

    **5. Schema guidance.** Direction is spelled out from the subject's point of view, including the reversal trap ("if the document says X is used by Y, the claim is Y depends-on X"). Configuration values are refused as entities — `LIVEKIT_URL`, `8080`, `https://…`, `${VAR}` — with a recorded reason.

    **One judgement call to flag:** for ungoverned tag keys you asked for "new-key suggestions". I've implemented it as a **drop that names the key** (`'port' is not a key in the Tag Dictionary`) rather than raising a proposal, so `port:`/`deployment:` show up in the accounting where an admin can see them. Raising a dictionary-key proposal would need a new proposal kind and a confirm path into the dictionary editor — worth doing if you want it, but it seemed like scope creep on a bug fix. Say the word.

    **Re-test criteria:** the Kora runbook should still yield ~0 (nothing in this change makes extraction less conservative — the model is still told returning nothing is a correct answer). Chinwag-V2 should now yield anchored edges plus new-entity proposals for MongoDB Atlas/Auth0/LiveKit/etc., each with its citation, and a visible accounting for whatever didn't make it. The hallucinated-anchor case is structurally impossible: a name that doesn't resolve can no longer silently become a different entity.

    Also updated one ISE-220 test that encoded the old silent-drop behaviour — rewritten with the reasoning in its docstring rather than deleted, since the drop rule genuinely changed.

    Gates: ruff, mypy (268 files), 1040 backend tests (+20), 340 frontend (+2), all four frontend gates green.

    Separately noted: `env:live` on Kora is a Tag Dictionary alias decision, not touched here.
assignee: steve
label: null
priority: high
task_status: done
---
Follow-up from smoke-testing ISE-220 (2026-07-22), upgraded from prompt polish to a **confirmed correctness bug** after comparing two extract transcripts against pipeline output.

**Evidence (both runs 2026-07-22, staging):**
- *Kora runbook* (19:43): model correctly returned 0 claims — procedural content, conservatism working as designed. Keep this behaviour.
- *Chinwag-V2 Overview* (19:25): model returned **23 claims** — including genuinely stated, high-value dependencies (chinwag → MongoDB Atlas, Auth0, LiveKit, Deepgram, Runpod, HuggingFace, Composio). **All 23 were silently discarded**: `proposal` table has 0 rows and the scrape task reported `claims_raised: 0`. No log line, no drop count, no reason recorded.

**Defects, in priority order:**
1. **Silent drops.** Anchoring/validation discards must be observable: a `claims_dropped` count with per-claim reasons in the task result and logs (and ideally on the document's detail view — "23 claims extracted, 23 dropped: subject unknown"). An AI call whose entire output is discarded must not report as "nothing found".
2. **Anchoring is prompt-only and the model ignores it — worse, it induces false anchors.** The transcript shows claims about unlisted names (`chinwag-v2`, `Auth0`, env var `LIVEKIT_URL` as an object) AND one hallucinated anchor to a listed-but-wrong entity ("prod-uk-openanswer-ekscluster routes-to chinwag-v2" — stated nowhere in the document; would have been a *false proposal* had it anchored). Enforce anchoring in code; remove the prompt threat; let the model name unknowns explicitly.
3. **Unknown names must be proposable, not unspeakable.** The document's most valuable facts (external SaaS dependencies) are unanchorable by construction — ISE has no entities for MongoDB Atlas/Auth0/LiveKit/etc. Unknown subjects/objects should yield *proposed-new-entity (+alias) proposals* with the edge claim attached, reviewed in the queue (ADR 0028 §3 precedent). Claims with env-var/non-entity objects are rejected with a recorded reason.
4. **Scope the known-entities list** (original finding): currently a ~350-name estate dump incl. UUIDs, instance ids, ephemeral GitLab runners. Replace with tag-linked entities + 1–2 hop neighbourhood, excluding retired/ephemeral/machine-named; include entity types.
5. **Claim schema guidance**: direction conventions for `routes-to`/`depends-on` (transcript has reversals, e.g. "mgnt-production-uk routes-to chinwag-v2-build"); tag claims must use dictionary keys or arrive flagged as new-key suggestions (`port:`, `deployment:` in the transcript).

**Re-test criteria:** Kora runbook still yields ~0; Chinwag-V2 Overview yields anchored + new-entity proposals with citations and a visible accounting (raised / anchored / new-entity / dropped-with-reason); the hallucinated-anchor case is structurally impossible (code-side anchoring rejects it with a reason rather than the prompt begging).

Related observation handled separately: Kora reports `env:live` (not `env:prod`) — Tag Dictionary alias decision.