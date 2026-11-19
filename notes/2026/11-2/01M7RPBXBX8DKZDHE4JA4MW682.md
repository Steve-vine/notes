---
id: 01M7RPBXBX8DKZDHE4JA4MW682
created: 2026-11-19T01:22:33.469083Z
updated: 2026-11-19T01:22:38.813308Z
type: task
title: 'Library polish from pre-UAT: focus returns to the button you used, a tooltip doesn''t linger, and Polaris describes Folders plainly'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1985
sprint: s2q1gxe
assignee: steve
label:
- improvement
priority: low
task_status: todo
---
Small things found at pre-UAT of sprint 119 (staging 25f02b9c, 19 Nov). None fails a task's "Done when", but each is worth fixing before Steve tests.

1. **Focus after the reader's details pane closes (COM-1974).** After Escape, × or a click outside, focus goes to the page body. COM-1974's notes asked for it to return to the ⓘ. Expected: focus returns to the ⓘ Details button.
2. **The Details tooltip comes back (COM-1974).** If the mouse is still resting on ⓘ when Escape closes the pane, the "Details" tooltip reappears, and the next Escape only closes the tooltip, so leaving the reader takes three Escapes. Expected: the tooltip doesn't reopen when the pane closes, so two Escapes leave (one closes the pane, one leaves). The same applies to the "Reading width" tooltip, which stays visible behind its open menu (COM-1962): it should hide while the menu is open.
3. **Focus after unpinning from a Pinned tile (COM-1968).** After unpinning by keyboard, focus falls to the page body. Expected: focus moves to the next Pinned tile's unpin button, or to the Pinned section's heading if it was the last one.
4. **Polaris's description of the home (COM-1967).** Asked to describe the Library home, Polaris added "There's no separate section for people's own folders on this home", which is confusing because Folders is that section. Expected: its instructions or the browse tool's wording say plainly that Folders holds people's own folders, then Not in a folder, and Domains holds the domain folders.
5. **Cleared sorts leave nulls (COM-1970).** Clearing a section's sort saves `sorts: {pinned: null, …}` instead of removing the key. It's harmless, but the server should drop a cleared key, so the saved choices stay tidy.

**Done when:** each of the five behaves as expected, with a test for 1–3 (focus) and 5.

Independent: frontend, plus a small backend touch for 4–5.