---
id: 01KZ3Q815K1MMVTKVJ7AZK3MDJ
created: 2026-08-03T11:48:17.203786Z
updated: 2026-08-05T19:53:31.832798Z
type: task
title: Tag writeback declared on ActionSpec, not a hardcoded map
project: 01KX671DATY39VW6GWK3M2T3DN
number: 497
sprint: shk7zaj
comments:
- id: 01KZ9QSZDRVRKZX2E5Z2JHPTAZ
  author: Steve Vine
  at: 2026-08-05T19:53:31.832686Z
  text: |-
    Built — PR #485 (feature/ise-497-tag-write-declared → main), ADR 0084. Independent of 495/496.

    WHAT LANDED
    - `ActionSpec.tag_write = TagWrite(key_param=…, value_param=…)` — the operation that can correct a tag is the one that SAYS it can. `_OPERATIONS = {"kubernetes": "set_label", ...}` is gone, and so is every native-key-parsing branch in `tag_remediation`.
    - The TARGET stays a method, `Connector.tag_write_target()`: it varies from one param (`resource_arn`) to three (`namespace`/`kind`/`name`), and deriving it means parsing the connector's own key format. It is handed `system_id` because a connector that scoped its keys by it (ADR 0045) needs it to parse them back exactly rather than guessing where the id ends.
    - Two declaring operations in one catalogue raises: "which one corrects a tag?" must not be answered by iteration order.
    - `TagWriteUnsupported` carries a reason shown verbatim — "we cannot" is a worse answer than "we cannot, because a node is not a set_label target", and only the connector knows the second one.

    ⚠️ THIS FIXES A LIVE BUG — worth knowing about
    KUBERNETES TAG CORRECTION HAS NEVER WORKED. The old branch built `kind: "deployment"` by splitting the native key, while `set_label`'s declared schema only accepts the Kubernetes spelling `Deployment`. Proposal re-validates parameters against the declared schema (ISE-49), so every Kubernetes retag was refused by its own action — the button existed and simply errored.

    The 2348-test suite was green through it, because `plan()` was tested for Kubernetes and `propose()` was tested only for DataDog. The mapping lived in `tag_remediation` and the schema lived in the connector, and nothing had ever compared them — which is exactly the failure mode this task removes.

    THE GUARD THE OLD DESIGN COULD NOT HAVE
    Now both halves are the connector's, a test computes a real correction for EVERY connector declaring a tag write and validates it against that operation's own parameter schema. A connector gaining a tag write must add a case, so an untested declaration fails the suite rather than the operator. Verified it fails without the fix — reverting the one-line spelling map reddens 3 tests.

    UNCHANGED
    ADR 0043's semantics. No tag-write operation still means not correctable; those compliance issues stay a work list for a human and the UI shows no button rather than a broken one. `correctable_system_ids` (what gates the frontend button) now flows through `supported()`, which asks the connector.

    Full backend suite green locally: 2348 passed. Frontend: 617 passed. ruff/mypy strict/eslint/prettier/build clean.

    FOR THE STAGING SMOKE: worth actually clicking "fix at source" on a Kubernetes workload's tag issue — that path has never reached the approvals queue before.
assignee: steve
priority: medium
task_status: active
---
Replace `tag_remediation.py`'s `_OPERATIONS = {connector_type: operation}` dict (and the per-connector native-key → action-param branches) with a declaration on the ActionSpec itself (e.g. a `tag_write` marker + param mapping). A connector whose catalogue declares a tag-write op gets fix-at-source for free; absence still means unsupported (ADR 0043 semantics unchanged).