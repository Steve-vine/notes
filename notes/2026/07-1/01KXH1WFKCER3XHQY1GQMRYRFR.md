---
id: 01KXH1WFKCER3XHQY1GQMRYRFR
created: 2026-07-14T19:32:57.06882867Z
updated: 2026-07-23T19:46:01.108904Z
type: task
title: Citation model + resolver
project: 01KX671DATY39VW6GWK3M2T3DN
number: 64
sprint: syz8rn1
blocked_by:
- 01KXH1VZV34ZQA7XCBYG2YJRNJ
assignee: steve
priority: medium
task_status: done
---
"Answers cite ISE records with links" (ui-brief §7). **There is no citation schema in the codebase today** — `Issue.evidence` is untyped JSONB holding model-authored prose. The only polymorphic record reference that exists is `AuditEvent(entity_type, entity_id)` — reuse that precedent exactly.

## Shape

```python
class Citation(BaseModel):
    entity_type: Literal["system", "issue", "finding", "proposed_change", "agent_run"]
    entity_id: UUID
    label: str   # model-authored, human-readable
```

## Citations are NOT in the output schema

Two reasons: a structured output type would **defeat token streaming** (the whole point of ISE-61), and asking a model to type UUIDs into free prose is **asking for hallucinated ids**.

## Two layers

**Floor — deterministic observation capture, requiring zero model cooperation.** Every assist tool, before returning, appends the `(entity_type, entity_id, label)` of each entity it returned to `deps.observed` (under a lock — tools may run on different threads). Deduped and capped at the end of the turn. **These cannot be hallucinated: the model literally read them.** Slight over-citation is the cost, and it is the right cost.

**Precision — a `cite(entity_type, entity_id, label)` tool.** Does a DB `get` and returns `{"ok": true}` or `{"error": "no such issue"}` — so a **hallucinated id is rejected in-band and the model self-corrects**. Cited entities rank above merely-observed ones.

⚠️ **Sequencing trap:** pydantic-ai's `run_stream` stops the graph at final output and *will not execute tool calls made after it*. If the model calls `cite` **after** it starts producing text, those calls are dropped. Hence the prompt rule — *"call `cite` before you write your answer"* — and hence the deterministic floor, which does not depend on the model getting that right.

## Resolution happens in the API, never in the model

New `app/backend/src/ISE_api/citations.py` — `resolve(db, citation) -> ResolvedCitation`, mapping entity_type → (model, title, href): system → `/systems/{id}`, issue → `/issues/{id}`, proposed_change → `/approvals?change={id}`, agent_run → `/agent-runs/{id}`.

Persisted on `assist_message.citations`, but **resolved fresh on every read** — so a deleted entity degrades to plain text, never a broken link.

Blocked by: ISE-63.