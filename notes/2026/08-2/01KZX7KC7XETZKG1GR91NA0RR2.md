---
id: 01KZX7KC7XETZKG1GR91NA0RR2
created: 2026-08-13T09:35:07.005662Z
updated: 2026-08-13T10:00:54.210606Z
type: task
title: Groups becomes a screen of its own under Collections, not a Settings tab
project: 01KX671DATY39VW6GWK3M2T3DN
number: 678
sprint: savn96w
comments:
- id: 01KZX92K62K9PAF43PDVFMQRQV
  author: Steve Vine
  at: 2026-08-13T10:00:54.210503Z
  text: |-
    Built and merged to main as PR #629 (76db742), CI green.

    Groups is now /groups, first in the Collections section. TagRulesCard was lifted whole, so TagRules.test.tsx passes untouched.

    Two things the move forced, both worth knowing:

    - The Settings tab was "gated" by not being rendered. That stops being a gate the moment the screen has a URL somebody can type, so the page enforces canManage itself and says so below admin; the API is still the authority.
    - /settings?tab=tags redirects to /groups rather than silently landing on Integrations. No in-app links pointed at that tab, but bookmarks and shared links are the case that matters.

    /groups, not /tags — /tags is the tag cloud, which already owns that route and the tags glyph. Groups took IconCategory so two nav entries don't read as one screen.
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Groups are operator knowledge about the estate — the same kind of thing as a Business Application — but they live as the `tags` tab of `/settings` (`pages/SettingsPage.tsx`, rendering `components/TagRulesCard.tsx`), filed with credentials and AI ceilings. Promote them into the Collections section from [ISE-677], as its **first** item, above Business applications and Business services.

**Scope**
- New route + page (`/groups`, `pages/GroupsPage.tsx`) rendering the existing `TagRulesCard` — lift the card, don't rewrite it; its tests (`pages/TagRules.test.tsx`) render the component directly and should keep passing untouched.
- Nav item `Groups` first in the `Collections` section.
- Remove the `Groups` tab from Settings, and **redirect `/settings?tab=tags` to the new page** rather than 404ing a bookmark or a shared link. Sweep for in-app links to that tab before deleting it.
- Keep the same role gate the tab had (`canManage`) — this is a move, not a permissions change. On the standalone page that gate has to be enforced by the page itself; a tab that simply wasn't rendered is not a gate once the URL is reachable directly.
- Page furniture to match the sibling screens: title, dimmed description, and an empty state that says what a group is for.

**Done when** an operator manages groups from Collections › Groups, Settings no longer offers the tab, and an old `?tab=tags` link still lands somewhere sensible.