---
id: 01KXBHV7HCCPYSE4RX0GDQVF50
created: 2026-07-12T16:16:26.668371348Z
updated: 2026-07-23T18:32:58.677564Z
type: task
title: Phase 4 exit test — detection to execution, end to end
project: 01KX671DATY39VW6GWK3M2T3DN
number: 53
sprint: sdcd2jr
blocked_by:
- 01KXBHTZJZ49RCHXD043W3HDPP
assignee: steve
label: null
priority: high
task_status: done
---
**PASSED 2026-07-13.** Both legs, against the real g5 cluster with a real write credential.

**MAIN LEG — detection to execution, end to end:**
- sync detected the broken workload (ImagePullBackOff on nginx:v99-does-not-exist)
- the propose-remediation agent drafted `edit_resource` patching the image back to nginx:1.27, citing the rollout history as evidence: *"revision 2 set the image to a nonexistent tag... revision 1 used nginx:1.27 and was healthy at 2/2 ready. A plain restart would not fix it because the current spec still references the bad tag."*
- T2 -> awaiting approval -> approved by Steve in the UI -> executor patched the Deployment
- pods pulled the valid image, went 2/2 ready, findings cleared, **the issue resolved**
- audit chain: proposed(ai) -> awaiting_approval -> approved(Steve) -> executed(executor)
- `before.manifest` captured the prior image — the rollback substrate

**T3 / SAFETY LEG:**
- `delete_resource` against **kube-system** -> 409 *"no approval can override this"*
- `delete_resource` against **ise** (ISE's own namespace) -> 409, same
- both refused by the ISE-54 fail-safe defaults on a system with **no risk_policy configured at all**
- `delete_resource` against ise-acceptance -> T3, awaiting approval (T3 can never auto-apply)
- approved (admin self-approval, **audited distinctly as `self_approval: true`**) -> executor deleted the Deployment
- full manifest captured in `before` first — the only route back from an irreversible op

**NOT demonstrated live, and deliberately not claimed:** the separation-of-duties *refusal* (proposer == approver at T2/T3 for a non-admin). Steve is an admin, and ADR 0017 permits admin self-approval by design. It is covered at both T2 and T3 in the integration tests, where a non-admin approver can be constructed.

**The exit test earned its keep — six real defects, none findable by unit tests:**
- [[ise-58]] read-state too thin to remediate (the agent could see THAT it was broken, never WHAT to change) — fixed
- [[ise-44]] 309 duplicate AI issues + 72 wasted analyse runs burning 98.5% of the daily budget — fixed
- [[ise-59]] the UI was stricter than the server and deadlocked EVERY T3 change — fixed
- [[ise-57]] the spend ceiling blocks operator-triggered runs, against its own documented design — open
- [[ise-55]] no write-credential separation (sync and act share one principal) — open
- [[ise-56]] no credential UI: multi-field secrets and rotation are unreachable — open

Two of those (the inert blast-radius guard fixed in ISE-54, and the T3 deadlock) would have made Phase 4's central promises false in production while every test stayed green.