---
id: 01M3SSZK3J4SQR87K0XGRCXHTG
created: 2026-09-30T18:42:11.186802Z
updated: 2026-09-30T20:26:30.740962Z
type: task
title: The new shell — a sidebar that folds to icons, and a top bar with the trail, search (⌘K), company, theme, notifications and you
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 798
sprint: s0zzctz
blocked_by:
- 01M3SSYNG7G0N7PH6XS02CJ7NK
- 01M3SSZ4HV84GPHB49267YPDNP
assignee: steve
label:
- feature
priority: high
task_status: active
---
Part of sprint 65, UI Upgrade (ADR in COM-794). The frame every main-app page sits in, as the prototype draws it. The user portal's frame follows in its own task.

## What people see

**Sidebar**
- **The Compass mark and name at the top.** Under the name is where you are and which build: `staging · 20260929-1919`, or `production · v0.9.0` for a release.
- **The menu keeps today's sections and items:** Overview, Playbook, Posture, Modules, Portals, Admin. Each item has its icon. The current page is tinted violet.
- **The sidebar folds to icons only.** The toggle at the left of the top bar does it. Folded, hovering an icon shows its name. The choice is remembered on this browser.
- **Pages can tuck the menu away for you:** Assessments does while you work through controls. It comes back when you're done, and your own toggle always wins.
- **Small screens** keep today's pop-out menu behind a menu button.

**Top bar**, left to right
- **The sidebar toggle.**
- **The trail**, the way you came (ADR 0084). It moves up from above the page into the top bar, where the prototype draws its path. It behaves exactly as today:
  - steps are clickable;
  - long trails fold into "…";
  - a one-step trail is hidden.
  - On narrow screens it shows only the last two steps.
- **Search**, a wide box reading "Search controls, vendors, risks…" with a ⌘K hint (Ctrl K on Windows).
  - ⌘K or Ctrl K jumps to it from anywhere, except while typing in a field.
  - On narrow screens it becomes a search button.
  - Searching still starts a new trail.
- **The company switcher.**
- **The light/dark toggle.**
- **The bell**, with a violet dot when something is unread.
- **Your initials in a circle.** Clicking them opens what today's user menu offers: mail preferences, sign out, and the rest.

## Notes (technical)

- **Rewrite `components/AppLayout.tsx`** to the prototype's shell:
  - navbar 236px, or 64px folded, with the `localStorage` key `compass-sidebar`;
  - header 56px.
  - Keep `nav.ts` and its gates as they are.
- **The trail.** Move `<Trail>` into the header. `useTrailNavigation` and `useTrailScroll` are unchanged, and the page pane stays the scroll container.
- **A small shell context `useShell()`** with `requestCollapsed(boolean)`, so a page can fold the menu while it needs the room. An explicit user toggle overrides it until the page releases it.
- **The environment label.** `/api/v1/meta` already returns `env`. Extend `AppVersion` and `versionLabel.ts` to show `env · build` and move it under the brand.
- **⌘K.** Mantine `useHotkeys([['mod+K', focusSearch]])`, ignoring events from inputs and textareas. No command palette; it focuses the existing search box.
- **Tests.** The existing `AppLayout.test.tsx` and trail tests must still pass. Add tests for:
  - folding and the remembered state;
  - `requestCollapsed` and an override by the user;
  - ⌘K focusing search, and not when typing in a field;
  - the env label.

**Done when:** on staging the sidebar folds and remembers, ⌘K focuses search, the trail sits in the top bar and still works across sections, and the build line shows `staging · …`.