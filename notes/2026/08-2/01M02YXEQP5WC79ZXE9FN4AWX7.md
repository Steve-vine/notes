---
id: 01M02YXEQP5WC79ZXE9FN4AWX7
created: 2026-08-15T14:58:46.646029Z
updated: 2026-08-15T15:16:34.347808Z
type: task
title: 'Vendor form: rename "Lifecycle" to "State" + readable read-only fields on the portal'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 213
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Two vendor-form fixes (both surfaces — internal vendor detail and portal detail share these components).

- [ ] **"Lifecycle" → "State"** (`vendors/detail/cards.tsx:114`, `LifecycleCard` header): the field is `state` everywhere else (register column, filters, pills) — the card header is the odd one out and confuses. Label change only; grep for any other user-facing "Lifecycle" strings while in there (component name rename optional).
- [ ] **Read-only fields readable**: the details card renders non-editable fields with `disabled={!canEdit}`, and Mantine's disabled styling greys the background *and* dims the text — very hard to read in both light and dark mode on the portal. Switch to `readOnly` when `canEdit` is false (inputs and selects) so fields keep the normal form colouring but can't be edited; drop the save/edit affordances as today. Check every input in the details card + any other card using the `disabled={!canEdit}` pattern.
- [ ] Verify contrast in both light and dark themes on the portal detail page.
- [ ] Tests: labels updated; read-only mode blocks edits but renders standard styling.

Frontend only; independent of the COM-208/209/210 stack.