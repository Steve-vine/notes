---
id: 01M7RPBXBX8DKZDHE4JA4MW682
created: 2026-11-19T01:22:33.469083Z
updated: 2026-11-19T02:48:55.841009Z
type: task
title: 'Library polish from pre-UAT: focus returns to the button you used, a tooltip doesn''t linger, and Polaris describes Folders plainly'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1985
sprint: s2q1gxe
comments:
- id: 01M7RSHC9BN67ADHGY3V4YTHAR
  author: Steve Vine
  at: 2026-11-19T02:17:58.314879Z
  text: |-
    Merged: PR #1980, sha 0c012ebb. No migration, no API change.

    What changed:
    1. Closing the reader's details pane (Esc, × or a click outside) puts focus back on the ⓘ.
    2. The Details tooltip stays hidden after the pane closes until the pointer leaves the ⓘ, so two Escapes leave the reader. The Reading width tooltip hides while its menu is open.
    3. After unpinning a Pinned tile, focus moves to the next tile's Unpin. After the last tile it moves to the Pinned heading, and once nothing is pinned, to the next section's heading.
    4. Polaris's Library browse says plainly that the home has two sections: Folders (people's own folders, then Not in a folder) and Domains (each domain's folder).
    5. A cleared sort is removed from the saved Library choices instead of being saved as null.
- id: 01M7RVA2918KV5N49EHJKT0V50
  author: Steve Vine
  at: 2026-11-19T02:48:55.840712Z
  text: |-
    Pre-UAT re-check (staging 0c012ebb, E2E Admin A): **Passed**.
    1. Closing the reader's pane by Esc, ×, a click outside or the keyboard puts focus on the ⓘ, with no tooltip.
    2. With the mouse resting on ⓘ, the first Esc closes the pane and the second leaves the reader. Reading width's tooltip hides once its menu is open.
    3. Unpinning by keyboard from Pinned tiles: the middle tile moves focus to the next tile's Unpin, the last tile to the Pinned heading, and the only remaining tile to the Recently viewed heading.
    4. Polaris: "The Library home has two sections: Folders, then Domains. 1. Folders: people's own folders, with Not in a folder last … 2. Domains: one folder for each domain." The confusing sentence is gone.
    5. Setting then clearing sorts leaves `sorts: {}`; earlier nulls were dropped too.
    Screenshots: ~/compass-uat/library/COM-1985/.
assignee: steve
label:
- improvement
priority: low
task_status: review
---
Small things found at pre-UAT of sprint 119 (staging 25f02b9c, 19 Nov). None fails a task's "Done when", but each is worth fixing before Steve tests.

1. **Focus after the reader's details pane closes (COM-1974).** After Escape, × or a click outside, focus goes to the page body. COM-1974's notes asked for it to return to the ⓘ. Expected: focus returns to the ⓘ Details button.
2. **The Details tooltip comes back (COM-1974).** If the mouse is still resting on ⓘ when Escape closes the pane, the "Details" tooltip reappears, and the next Escape only closes the tooltip, so leaving the reader takes three Escapes. Expected: the tooltip doesn't reopen when the pane closes, so two Escapes leave (one closes the pane, one leaves). The same applies to the "Reading width" tooltip, which stays visible behind its open menu (COM-1962): it should hide while the menu is open.
3. **Focus after unpinning from a Pinned tile (COM-1968).** After unpinning by keyboard, focus falls to the page body. Expected: focus moves to the next Pinned tile's unpin button, or to the Pinned section's heading if it was the last one.
4. **Polaris's description of the home (COM-1967).** Asked to describe the Library home, Polaris added "There's no separate section for people's own folders on this home", which is confusing because Folders is that section. Expected: its instructions or the browse tool's wording say plainly that Folders holds people's own folders, then Not in a folder, and Domains holds the domain folders.
5. **Cleared sorts leave nulls (COM-1970).** Clearing a section's sort saves `sorts: {pinned: null, …}` instead of removing the key. It's harmless, but the server should drop a cleared key, so the saved choices stay tidy.

**Done when:** each of the five behaves as expected, with a test for 1–3 (focus) and 5.

Independent: frontend, plus a small backend touch for 4–5.