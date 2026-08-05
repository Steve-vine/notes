---
id: 01KZ8N5ZETFF58M8QY3D72NVQN
created: 2026-08-05T09:48:24.922486Z
updated: 2026-08-05T19:02:21.143698Z
type: task
title: No way to clear a credential in the UI — add Clear to the rotate modal (read and write)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 554
sprint: skxht3g
comments:
- id: 01KZ92BNF26BPWK5GARQW918J9
  author: Steve Vine
  at: 2026-08-05T13:38:42.786687Z
  text: |-
    Built on feature/ise-554-clear-credential — PR #473 (full CI green), merged to staging.

    **UI.** Clear on the rotate modal, read and write, shown only when a credential is actually bound. Behind a confirm step that says what will happen (a read clear stops sync authenticating; a write clear says watching is unaffected). "Also delete the stored secret" is a separate tick, default off — unbinding can be undone by binding again, deleting cannot.

    **Backend.** Two operations, in order, never merged:
    1. Unbind — PATCH with an explicit null; verified end-to-end that null really clears rather than being read as "keep".
    2. `credentials.delete` refuses (409) while any System still references the name in EITHER slot, and names them — "which ones?" is the immediate next question. Refs are plain strings with no FK, so nothing at the DB level stopped a delete from leaving a system pointing at a secret that no longer exists, a failure that only surfaces at the next sync.

    A refused delete AFTER a successful unbind is a note, not a failure: the binding is gone, so the dialog stays open and says so, naming what still holds the secret. Reporting it as an error would send the operator back to check whether anything had happened at all.

    Acceptance: a cleared system lands back in the ordinary "no credential granted" state — the row is intact and readable, exactly as every system is before anyone grants one.

    Merge note: this branch and ISE-553 both appended to `CredentialUI.test.tsx` and both edited `RotateCredentialModal.tsx`; resolved on staging keeping both sets (23 tests, green). The same conflict will recur when both merge to main.
assignee: steve
label: null
priority: medium
task_status: done
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