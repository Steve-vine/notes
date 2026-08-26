---
id: 01M0ZSB5P9WX5N1FN71HK32WQW
created: 2026-08-26T19:39:23.209725Z
updated: 2026-08-26T19:39:23.209725Z
type: task
title: Access Control's tab bar sits under its title, like every other tabbed screen
label: improvement
company: moneypenny
assignee: steve
priority: medium
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 437
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