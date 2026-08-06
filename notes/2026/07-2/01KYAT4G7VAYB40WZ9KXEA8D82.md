---
id: 01KYAT4G7VAYB40WZ9KXEA8D82
created: 2026-07-24T19:37:46.491095Z
updated: 2026-08-06T07:30:15.627257Z
type: task
title: Catalogue and review the artificial limitations on AI surfaces
project: 01KX671DATY39VW6GWK3M2T3DN
number: 265
sprint: svgrad3
comments:
- id: 01KYC89W85TM09DSGYVZZW6J8R
  author: Steve Vine
  at: 2026-07-25T09:04:37.124958Z
  text: "Done. Deliverable: docs/briefs/ai-limitations-catalogue.md — every limitation imposed on ISE's AI surfaces, each with a verdict (deliberate-and-right / deliberate-but-outgrown / accidental), built from the ISE-263 map and ISE-264 audit.\n\n15 limitations catalogued:\n- Deliberate-and-right, KEEP (L1-L8): no agent executes a mutation (ADR 0017); propose sees descriptions only; read-only allow-listed tool sets; assist's Postgres-enforced READ ONLY txn (ADR 0023); loop drivers that start but never approve/execute (ADR 0024); tool-less untrusted document tasks; prose-not-transcript history (ADR 0010); the scheduled/operator budget asymmetry (ISE-57). These are the constraints that let ISE hold write creds at all.\n- Deliberate-but-outgrown (L9-L12): \n  * L9 (the motivating case): chat can't pull on-demand Evidence. Argued outgrown — ADR 0023's boundary is about WRITES, and fetch_evidence is read-only by contract (ADR 0031 §3), so extending read-only Evidence to issue-chat doesn't breach its intent, only its original framing (written before operators investigated in chat). Proposal: add EVIDENCE_TOOLS to issue-chat first, assist second. Cost: real tokens, but already contained by the ISE-68 caps + 60k/turn; link spend to Sprint 23 panels.\n  * L10 history window / L11 spend caps: both already admin-tunable (ISE-248); keep the mechanism, re-tune numbers after L9.\n  * L12 analyse-issue no-Evidence: right today, revisit after ISE-264's fixes change the economics.\n- Accidental (L13-L15): unbounded traversal breadth (L13) and double-included estate context (L14) — both already carried by ISE-264 recs; plus a stale analyse-issue trigger description on the AI Models card (L15, models.py:123 claims a Beat schedule that doesn't exist).\n\nThe one ADR the sprint expected (chat Evidence access): included as a DRAFT argument to raise with you — not written as accepted, since accepting it is your call and this sprint is review-first. Once accepted it becomes docs/decisions/00NN-chat-evidence-access.md AND a Canon entry (per the standing instruction). Proposed the follow-up tasks in the doc.\n\nDocs only, no code change. Committed to feature/ise-265-catalogue-ai-limitations."
assignee: steve
label: null
priority: medium
task_status: done
---
Motivating case (2026-07-24): an operator asked issue-chat to check DataDog directly; it replied that it is limited to what ISE already holds. The connector Evidence capability (on-demand DataDog metrics/logs, ADR 0031) exists — but is wired to the investigation task types, not the chat surfaces, and chat runs behind the ADR 0023 read-only-DB boundary.

Working from the ISE-263 map, produce a catalogue of every imposed limitation and a verdict on each:

- **Deliberate and still right** (e.g. default-deny actions, ADR 0017) — keep, document.
- **Deliberate but outgrown** — e.g. chat without connector evidence tools made sense when chat was a cheap Q&A surface over the DB; now that operators investigate *in* chat, "check DataDog" is a reasonable ask. Evidence tools are read-only, so extending them to chat arguably doesn't breach ADR 0023's intent (no writes) — but that's an ADR amendment to argue, not assume. Same review for: chat history-turns window, per-surface tool subsets, spend shares.
- **Accidental** — limitations nobody chose (tool wiring gaps, context omissions found by the map).

Each "outgrown" verdict becomes a proposal: what to relax, what it costs (the caps exist partly for spend control — link to the Sprint 23 visibility work), and which ADR it amends. Expect at least one ADR (chat evidence access). Record decisions in the ISE Canon as made.

Depends on ISE-263 (the map).