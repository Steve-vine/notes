---
id: 01M05ENBTH71GA3VPSH4ME9RZK
created: 2026-08-16T14:12:27.601111Z
updated: 2026-08-16T14:12:27.601111Z
type: task
title: One editable prompt per agent, behind a Prompt editor grant — supersede the contract/addendum split
assignee: steve
priority: high
task_status: backlog
label:
- feature
- brief
project: 01KX671DATY39VW6GWK3M2T3DN
number: 749
tech: null
---
Decided 2026-08-16, on smoke of [ISE-742]. The layered shape is wrong in use: what shipped shows a large read-only contract with a small addendum box under it, and in practice every prompt reads as read-only. Replace it with **one fully editable field per agent** — the whole prompt, as shipped, editable in place — and move the control from *what* can be changed to *who* can change it.

**The trade, stated plainly so the ADR can record it.** ADR 0105 kept the contract in code because safety properties live in it as prose — the grounding rule, the untrusted-content (prompt-injection) rule, the citation contract. Those become editable here. That is the deliberate decision: the protection is no longer "nobody can change this text", it is "only a named grant holder can, and every change is audited with the previous text". Steve's call, made knowingly; the ADR states it as a trade rather than pretending nothing was given up.

## ADR 0106 — supersedes 0105

Next free number (0105 is the last on origin/main — **re-check before writing**, these have moved twice today). Supersede, never rewrite: ADR 0105 stays as an accepted decision that was superseded, with 0106 saying why the layered shape did not survive contact.

## The role is a GRANT, not a ladder rung

This is the part that decides whether the feature works as asked.

`ROLES` is a **cumulative ladder** — `viewer < responder < operator < approver < admin`, and `role_level` takes the highest. A new rung cannot express "a subset of admins": placed below admin, every admin inherits it; placed above, it becomes a super-admin tier. Either way "all other admins can view but not change" is unreachable.

`BREAKGLASS_GRANT` (`models.py:26`, ADR 0089) is the precedent for exactly this shape: **a named capability carried in the user's `roles` list and deliberately NOT in `ROLES`**, which `role_level` ignores, so it confers nothing on the ladder. Add `PROMPT_EDITOR_GRANT = "prompt-editor"` the same way, granted out-of-band by mapping an identity-provider group (in-app role editing stays unbuilt).

**The footgun to avoid, concretely.** The frontend's `hasRole` (`auth/hooks.ts`) is ladder-based:

```ts
const level = Math.max(-1, ...user.roles.map((r) => ROLE_ORDER.indexOf(r)))
return level >= ROLE_ORDER.indexOf(required)
```

`ROLE_ORDER.indexOf('prompt-editor')` is **-1**, and every logged-in user's level is `>= -1`. So `hasRole(user, 'prompt-editor')` returns **true for everyone, including a viewer** — the gate would look present and be wide open, with a green suite. The backend fails loudly instead (`require_role` raises at import for an unknown role, `ROLE_ORDER.index` raises), so the two halves fail in opposite directions. Needs its own `hasGrant` on the frontend and a `require_grant` dependency on the backend, and a test that a plain admin is refused the write.

## Scope

**Model + migration (next free — head is 0141 today, re-check).**
- `ai_model_config.prompt_addendum` → **`system_prompt`**, nullable. **NULL means "use the prompt shipped in code"** and is the default, so an untouched agent stays byte-identical to its release — including its fingerprint.
- Every install currently has an empty addendum (checked on staging, 19/19 rows, all zero length). The migration therefore drops the old column, and **fails loudly if any row holds a non-empty addendum** rather than copying it: a two-line addendum silently becoming an agent's entire prompt is the worst outcome available here. Populated migration test both ways.

**Backend.**
- `prompts.py` collapses: `ADDENDUM_HEADING`, `assemble`, `segments` and the whole `_OVERRIDE_PATTERNS` / `override_risk` guard go. With no contract above it, "this says 'ignore the above'" has nothing to mean, and the acknowledgement checkbox goes with it.
- Resolution becomes: stored `system_prompt` if set, else `base_prompt(task_type)`. One function, used by the engine, the chat runner and both post-cap landing calls — a landing answering under a different prompt from the attempt it replaces would make the run's own fingerprint a lie ([ISE-742] got this right; keep it).
- `MAX_ADDENDUM_CHARS` becomes a whole-prompt cap, and needs to be a good deal larger — the shipped prompts are already ~6k characters, so the current 4k would refuse the default text itself.
- Keep the audit-with-previous-text behaviour, and keep no-op saves writing nothing. It matters more now, not less: the audit trail is the only remaining record of what the safety wording used to say.
- `GET` stays admin (viewing a prompt is admin-level); `PUT` requires the grant.

**Drift from the shipped default — the new risk, and it needs a screen.**
Once the database owns the whole prompt, a later release that improves a shipped prompt is **silently ignored for ever** on any agent that was edited. Nothing today would tell you. So:
- Mark an edited agent as differing from the shipped default, and let an admin see the shipped text beside their own.
- **Reset to shipped default** (writes NULL) as a first-class action — without it, one edit is a one-way door.

**Frontend.** `AIPromptsCard.tsx` becomes one `Textarea` per task type, prefilled with the effective prompt and fully editable — no split, no `Code` block, no lock line. For an admin **without** the grant the same text renders read-only **and says why** ("changing prompts requires the Prompt editor grant"), rather than being silently inert — the standing rule that a refusal names its reason.

**Keep from [ISE-742]:** `agent_run.system_prompt_hash` and the read-time `prompt_matches_current`. Both get more load-bearing, not less — once any prompt can change, "was this answer produced under the prompt that is there now?" is the only way a run stays explicable.

## Acceptance

A Prompt editor edits `issue-chat`'s prompt in Settings, saves, and the next run uses it — with the run detail showing the new fingerprint. A plain admin sees the same prompt, cannot change it, and is told why. Resetting returns the agent to the shipped text and to its original fingerprint.
