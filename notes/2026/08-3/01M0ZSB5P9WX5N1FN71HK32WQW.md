---
id: 01M0ZSB5P9WX5N1FN71HK32WQW
created: 2026-08-26T19:39:23.209725Z
updated: 2026-08-27T21:46:43.103982Z
type: task
title: Access Control's tab bar sits under its title, like every other tabbed screen
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 437
sprint: smnkt3k
comments:
- id: 01M12EFKQ4NGTEBJ12XSP5KVSB
  author: Steve Vine
  at: 2026-08-27T20:27:17.604134Z
  text: |-
    Done — PR #456.

    The shell now owns the Access Control heading above the tab bar, and the nine tab pages — Role matrix, Requests, Validation, Recertification, Access Graph, View Groups, View Users, View Devices, Directory Roles — drop their page-level titles so there are not two headings stacked. The screen used to announce itself as whichever tab was open, so it read as "Role matrix" on one URL and "View Devices" on another and never as the screen it is.

    The shell's comment said it deliberately added no title because each tab page had one. That reasoning is reversed in place rather than deleted, so the next reader sees why it changed.

    Tabs are untouched — same labels, same order, same URLs — so bookmarks and notification links land where they did. Detail pages (a role, a request, a campaign, a directory role) are routed as siblings of the shell rather than children, so they keep their own titles and are unaffected. Validation keeps its "Expedited changes" heading at section weight; only screen titles went.

    Two layouts had been built around the title and needed rebuilding rather than emptying. The role matrix put its Show-disabled switch and New-role button opposite the title in a space-between row — with the title gone that parks them on the left, so the row is justified right instead. Requests stacked its expedited-to-standard counts under the title in a wrapper that was then holding one child, so that came out. The four "Select a company…" branches lost the same kind of wrapper.

    Tests: the shell now asserts the screen title renders once, not twice, and that it comes before the tab bar in document order rather than merely existing on the page. Nothing broke — the per-tab page tests render their pages standalone, outside the shell, and none asserted on a page title. 752 tests pass.
assignee: steve
company:
- moneypenny
label:
- improvement
priority: medium
task_status: done
---
Access Control opens with its tab bar at the very top of the page and the title underneath, inside whichever tab you happen to be on. Every other tabbed screen — Vendors, Admin — puts the screen's name first and the tabs below it. Access Control reads as though the tabs belong to the sidebar rather than to a screen.

## What changes for the reader

**Access Control looks like Vendors.** The screen is named at the top, the tabs sit under the name, and the tab's content sits under the tabs. Which screen you are on stops depending on which tab is selected.

## Scope

The Access Control shell (`access/AccessControlPage.tsx`) deliberately renders no title of its own — the comment says each tab page keeps its own heading. Reverse that: the shell owns the **Access Control** heading above the tab bar, and each tab page drops its page-level title so there are not two headings stacked.

A tab page that needs a heading for a section within it keeps that, at section weight — this is about the screen title only.

The tabs stay as they are: same labels, same order, same URLs, so bookmarks and notification links still land where they did.

Detail pages that render outside the shell (a role, a request, a campaign) are unaffected.

## Tests

`AccessControlPage.test.tsx` and the per-tab page tests assert on headings — expect breakage there, and keep an assertion that the screen title renders once, not twice.