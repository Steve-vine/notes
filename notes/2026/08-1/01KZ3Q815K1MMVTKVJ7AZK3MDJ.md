---
id: 01KZ3Q815K1MMVTKVJ7AZK3MDJ
created: 2026-08-03T11:48:17.203786Z
updated: 2026-08-07T10:09:45.532223Z
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
- id: 01KZAX5XHZT8KRY542Q4PCCBZ2
  author: Steve Vine
  at: 2026-08-06T06:46:40.446965Z
  text: |-
    ADR RENUMBERED 0084 → 0087 (2026-08-06).

    The collision resolved itself the other way while this was in review: **ISE-563's Servers integration ADR merged to main first as 0084** (PR #483). The number on main is the one already referenced, so this one moves rather than theirs.

    0087, not 0085 — 0085 and 0086 are taken by the sibling tasks in this sprint and are already cited in commits, PR bodies and the Canon. Renumbering a whole run to close a gap would invalidate more references than it tidies; ADR numbers are identifiers, not an ordering to be kept dense.

    Done on the branch (`f4b6afa`), force-pushed; PR #485's body updated. Re-merged into staging (`91246b0`). Only the file heading and the index row referenced the number — no source or test references, since the code cites ADR 0043 for the semantics.

    Root cause was a stale index: `docs/decisions/README.md` stopped at 0076, so "what is the next free number?" could not be answered from it. Fixed separately in **PR #488**, which backfills 0077/0078/0081/0082/0084 and adds the rule to the preamble: take the next number from the FILES and the OPEN BRANCHES, never the table alone — a gap means an ADR is in flight, not a free number.
- id: 01KZAYAC81S7A91549BNK5B8YB
  author: Steve Vine
  at: 2026-08-06T07:06:35.136077Z
  text: |-
    ADDED: set_label EXECUTION COVERAGE (commit `cf130a6`, on PR #485).

    `set_label` had NO execution test at all — anywhere, before or after this task. The whole tag-writeback path was covered only as far as the approvals queue, which is precisely how the bug survived: `tag_remediation` produced `kind: "deployment"` from the native key while BOTH the action schema's enum AND `_workload_api`'s `_WORKLOAD_SUFFIX` lookup spell it `Deployment`, and nothing ever ran the two together.

    Worth stating plainly: THE CONNECTOR WAS INTERNALLY CONSISTENT ALL ALONG. Its schema enum is literally `[*_WORKLOAD_SUFFIX, "namespace"]` and its executor does `_WORKLOAD_SUFFIX[kind]` — same dict, so they cannot drift. The only wrong party was the outside module that reconstructed `kind` by splitting a native key. That is ADR 0087's argument in one example: the knowledge belonged with the operation that declares it.

    It also means the old lowercase value would have raised `KeyError` in the executor had it ever got past the schema — the fix is correct on both halves, not just the validating one.

    FOUR NEW TESTS (on the existing `RecordingApps` harness, plus a `RecordingCore` for the namespace branch):
    - patches exactly ONE key — a correction must never take another label with it — and records the prior value as the rollback substrate;
    - "was unset" vs "was something else": different rollbacks, and the approver reads the difference off the detail line;
    - the `kind: namespace` branch patches the namespace and NOT a workload (and `namespace` stays required even there, because the protected-target guard matches on it — omitting it would be a hole in ADR 0021's deny-list);
    - the one that ties all three spellings together: feed `tag_write_target`'s output from a real native key STRAIGHT into `act()`. **Verified it fails on the pre-fix code** (reverting the one-line spelling map reddens exactly that test).

    That last test is the assertion that could not previously be written, because the native-key parsing lived in `tag_remediation` and the schema lived in the connector.

    Unit suite: 628 passed. `test_kubernetes_connector.py` + `test_tag_remediation.py` on the combined staging state: 67 passed. ruff + mypy strict clean. Merged to staging (`9de4309`).

    Still unproven and only provable by hand: an actual patch against a real cluster. The staging smoke on a Kubernetes workload's tag issue is now the only remaining gap.
assignee: steve
label: null
priority: medium
task_status: done
---
Replace `tag_remediation.py`'s `_OPERATIONS = {connector_type: operation}` dict (and the per-connector native-key → action-param branches) with a declaration on the ActionSpec itself (e.g. a `tag_write` marker + param mapping). A connector whose catalogue declares a tag-write op gets fix-at-source for free; absence still means unsupported (ADR 0043 semantics unchanged).