---
id: 01KXGSNYCVSQ7PT8SYKCP7V3Q2
created: 2026-07-14T17:09:34.235101036Z
updated: 2026-07-14T17:09:34.235101036Z
type: task
title: Dynamic feel & feedback
task_status: done
label: brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 55
---
Make the app feel responsive + alive (closes M7). Central wiring where possible. (Deploy to view.)

**Agreed approach (planned 2026-06-19).**

- [ ] **Toasts (central)**: add `@mantine/notifications` (+ CSS) + `<Notifications />` in the provider tree (main.tsx + test-utils). `QueryClient` with a `MutationCache`: `onError` → red toast from `error.message` (all mutations); `onSuccess` → green toast from opt-in `mutation.meta.successMessage`. Add `meta.successMessage` to key mutations (content create/publish/save, decision create/supersede, risk create/save, gap status, link/unlink). Inline error `Text`s left as-is (bound scope).
- [ ] **Loading skeletons**: shared `<Loading />` (Skeletons) replacing the ~10 `Loading…` spots on list + detail pages.
- [ ] **Empty states**: shared `<EmptyState icon title description action? />` on the main cases (Search no-results, Frameworks none, Dashboard no-activity, notifications caught-up).
- [ ] **Transitions**: subtle card hover-lift + fade via global CSS, gated `@media (prefers-reduced-motion: no-preference)`.
- [ ] Tests: `EmptyState` + `Loading` renders; a failing mutation through the shared QueryClient + `<Notifications/>` shows an error toast; suite green.

Refs: ADR 0022 (design), 0017, 0003. Depends on: <issue id="b5ce177b-1a3d-4b63-a107-7def7eaef133" href="https://linear.app/stevevine/issue/DEV-469/theme-foundation-lightdark-toggle">DEV-469</issue> (done).

---
*Migrated from Linear [DEV-472](https://linear.app/stevevine/issue/DEV-472/dynamic-feel-and-feedback) · created 2026-06-18 · completed 2026-06-19*  
*Related to (Linear): DEV-471*