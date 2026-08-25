---
id: 01M02YXEQP5WC79ZXE9FN4AWX7
created: 2026-08-15T14:58:46.646029Z
updated: 2026-08-25T18:43:17.645612Z
type: task
title: 'Vendor form: rename "Lifecycle" to "State" + readable read-only fields on the portal'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 213
sprint: sbph5q5
comments:
- id: 01M0306H367TMTREXGGD5VY3QG
  author: Steve Vine
  at: 2026-08-15T15:21:12.55074Z
  text: |-
    Done — PR #205 (feature/com-213-vendor-form-state-readonly, stacked on #204).

    "Lifecycle" → "State": one user-facing string, in LifecycleCard's header. Grepped the tree — that was the only one. Kept the component name (the card is about lifecycle *moves*) with a comment recording why the header disagrees.

    readOnly instead of disabled: 6 fields in DetailsCard, 15 in AssuranceCard (TriSelect's prop renamed with them). Mantine honours readOnly on Select (dropdown suppressed, clear button hidden) and NumberInput (controls hidden), so the swap holds for every input kind in those cards, not just text. The Save button was already hidden when canEdit is false, so nothing became submittable.

    Scoped to the vendor cards — RiskDetailPage/GapsPage/AssessmentsQueuePage use the same pattern but are not on the portal and not what this task named.

    Tests: the two internal read-only cases now assert readOnly === true && disabled === false (asserting both directions, so a future revert to `disabled` fails rather than passing silently); PortalVendorDetailPage gains one case per fix.

    Light/dark contrast is left to the UI smoke test — the change is precisely the Mantine styling swap that fixes it.
assignee: steve
company: null
label:
- improvement
priority: medium
task_status: done
---
Two vendor-form fixes (both surfaces — internal vendor detail and portal detail share these components).

- [ ] **"Lifecycle" → "State"** (`vendors/detail/cards.tsx:114`, `LifecycleCard` header): the field is `state` everywhere else (register column, filters, pills) — the card header is the odd one out and confuses. Label change only; grep for any other user-facing "Lifecycle" strings while in there (component name rename optional).
- [ ] **Read-only fields readable**: the details card renders non-editable fields with `disabled={!canEdit}`, and Mantine's disabled styling greys the background *and* dims the text — very hard to read in both light and dark mode on the portal. Switch to `readOnly` when `canEdit` is false (inputs and selects) so fields keep the normal form colouring but can't be edited; drop the save/edit affordances as today. Check every input in the details card + any other card using the `disabled={!canEdit}` pattern.
- [ ] Verify contrast in both light and dark themes on the portal detail page.
- [ ] Tests: labels updated; read-only mode blocks edits but renders standard styling.

Frontend only; independent of the COM-208/209/210 stack.