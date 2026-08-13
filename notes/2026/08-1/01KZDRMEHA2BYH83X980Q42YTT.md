---
id: 01KZDRMEHA2BYH83X980Q42YTT
created: 2026-08-07T09:24:57.002422Z
updated: 2026-08-13T19:00:09.767117Z
type: task
title: Verify the MCP gated-write path end to end — propose, approve, execute
project: 01KX671DATY39VW6GWK3M2T3DN
number: 598
sprint: snk16ew
comments:
- id: 01KZEA7K5Q69VKVQP63NF8WJEC
  author: Steve Vine
  at: 2026-08-07T14:32:30.135203Z
  text: |-
    Built on feature/ise-598-mcp-gated-write-proof — PR #521.

    **Result: no gap. Nothing was added to the MCP surface, and that IS the finding.**

    Propose, approve, inspect, the timeline and the executor were all already there and already right. What was missing was any test that crossed the SEAMS between them. `test_mcp_actions` proved a proposal lands, `test_mcp_approvals` proved approval and separation of duties, `test_change_executor` proved execution — four tests each proving a different quarter of the claim, and nothing walking the whole thing on one surface. A row of a capability matrix that no test crosses is a claim, not a fact.

    `tests/integration/test_mcp_gated_write_path.py` now walks it, on the MCP surface throughout:
    1. T2 proposed from Claude Code queues at the tier the CATALOGUE resolves — a caller cannot ask for a lower one.
    2. The proposer's own approval is refused THERE, with the token identity as proposer. That's the rule that most needed proving on this surface specifically: if it only held on the app, MCP would be the way around ADR 0017.
    3. A second human approves.
    4. The executor runs it with EXACTLY the approved parameters — nothing re-planned them between the decision and the write.
    5. Claude Code can see it ran — by id via `get_proposed_change`, AND on the incident timeline. Worth recording: `list_pending_approvals` shows only `awaiting_approval` by design, so if you lose the change_id the timeline is how an executed change is found again. Its card carries the OUTCOME, not just the fact of a proposal. Not a gap, but it's the question I went in expecting to be one.
    6. Audit trail: proposed → awaiting_approval → approved → executed, approver named, proposal marked `via: claude`.

    Tier behaviour, walked from the same surface because a ceiling is only worth asserting where something might push against it: T3 stays queued under a policy that claims `auto_apply: {T3: true}` (a misconfigured policy fails STRICTER, ADR 0021); an unapproved change is refused by the executor rather than merely labelled; T0 and policy-authorised T1 auto-apply with the trail naming `policy:auto_apply` instead of a human; a system with an empty risk_policy still waits — absence is not consent (ISE-54 shape). Plus: write tools are ABSENT from a viewer's tool list, not merely refused.

    Two failure modes included deliberately, because both are ways a gated write can look successful to whoever approved it — an integration disabled AFTER approval must fail rather than fire (ISE-461, and the reason must be legible from `get_proposed_change`), and a connector blowing up must leave a `failed` record with its reason rather than a change reading `approved` for ever.

    Trap caught while writing it, worth remembering: the module shares one database but each test got a fresh random `ISE_CREDENTIAL_MASTER_KEY`, so the write credential stored by the first test decrypted to `InvalidTag` in later ones — and `str(InvalidTag())` is the EMPTY STRING, so the change failed with a blank reason and looked exactly like a genuine execution failure. Pinned to a fixed key with a comment.

    Deliverables: the test, an ADR 0090 amendment recording that invariant 4 is now claimed, and a new §3a in the "ISE Test Plan" memo for the LIVE walk — eleven checkboxes covering what CI cannot have: a real connector, a real worker, and the queue between them. The memo's §15 now records that ISE-598 found no gap.

    Headless by nature, stated explicitly per the DoD: this verifies an existing surface and ships no screen. The sprint's user-facing deliverables are the other three tasks (Assist page ×2, Service Desk guided incident page).

    Tests + docs only — no source change, no migration, no OpenAPI change. Full backend suite green: 2555 passed. ruff + mypy strict clean.

    Note for the release: ISE-597 and ISE-598 both append an amendment block to ADR 0090, so expect a trivial end-of-file conflict when the second one merges to staging — resolve by keeping both blocks.
assignee: steve
label: null
priority: medium
task_status: done
tech: null
---
The Role Matrix's Claude Code row claims full Incident-Screen parity on gated writes. Prove it rather than assume it (matrix invariant "MCP completeness").

- Walk propose → approve → execute over the MCP surface against staging: `propose_change` with a real T1/T2 action, approval (in-app or MCP if registered), execution, audit rows.
- Check tier behaviour: T0/policy-T1 auto-apply; T2/T3 queue; separation-of-duties enforced with the token identity as proposer.
- Any gap (missing tool, wrong min_role, approval not reachable, execution not observable from Claude Code) becomes a fix within this task if small, or a spawned task if not.
- Extend the ISE Test Plan memo's checkboxes with this path.

Precedes breakglass (ISE-592) — breakglass auto-satisfies exactly this gate, so the gate must demonstrably work first.