---
id: 01KY5RWJ7S9N8G1HCN8X522T2J
created: 2026-07-22T20:39:45.657478Z
updated: 2026-07-22T21:07:01.781935Z
type: task
title: Document claim pipeline — silent drops, code-side anchoring, unknown-entity proposals
project: 01KX671DATY39VW6GWK3M2T3DN
number: 222
sprint: s5khymf
assignee: steve
label:
- bug
priority: high
task_status: review
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