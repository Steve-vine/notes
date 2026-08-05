---
id: 01KZ8N5ZETFF58M8QY3D72NVQN
created: 2026-08-05T09:48:24.922486Z
updated: 2026-08-05T12:31:57.279612Z
type: task
title: No way to clear a credential in the UI — add Clear to the rotate modal (read and write)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 554
sprint: skxht3g
assignee: steve
priority: medium
task_status: todo
---
Settings → Integrations can grant and rotate credentials but never remove one: the rotate modal (`RotateCredentialModal.tsx`) has only Verify/Save. Found live 2026-08-05: six Kubernetes systems shared a wrong `write_credential_ref` ("Status Pages-credential", see ISE-553) and there was no way to detach it — the only recourse was direct DB surgery.

**UI.** Add a Clear button to the rotate modal, for both read and write credentials (shown only when a credential is currently bound). Destructive styling + confirm step; on success the system row shows "Grant read"/"Grant write" again.

**Backend.** Two distinct operations, both needed:
1. *Unbind* — null out `system.credential_ref` / `write_credential_ref`. The systems PATCH must accept explicit null for these fields (verify it doesn't treat null as "keep").
2. *Delete the stored credential* — `DELETE /api/v1/credentials/{name}` exists (admin) but `credentials.delete` (`credentials.py:84`) has NO in-use guard: refs are plain strings (no FK), so deleting a credential other systems still reference leaves dangling refs silently. Add the guard: refuse (409) naming the systems still bound, unless those bindings are being cleared in the same operation.

Suggested flow: Clear always unbinds; if the credential is then referenced by no other system, offer "also delete the stored secret" (the shared-ref case above is live proof one credential can back several systems).

Interaction with ISE-553: clearing is also the repair path for a wrongly-named ref — unbind, then grant fresh under the correct name.

**Acceptance:**
- Rotate modal shows Clear for a bound read or write credential; confirm → ref cleared, action links revert to Grant read/Grant write.
- Deleting a stored credential still referenced by another system is refused with a message naming that system.
- Sync/actions for a system with a cleared credential degrade to the existing "no credential" behaviour (no crash, health reflects it).