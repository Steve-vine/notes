---
id: 01M3WFE15ZZYXBA0Q0J7Z4V596
created: 2026-10-01T19:35:33.311776Z
updated: 2026-10-02T08:50:58.438806Z
type: task
title: Access Control tabs
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 830
sprint: s0zzctz
comments:
- id: 01M3WN6MMMRHAGGDY14BN4VFKR
  author: Steve Vine
  at: 2026-10-01T21:16:22.547884Z
  text: |-
    Merged: PR #838 (4e91238).

    All fourteen Access Control tabs are now on the bar, in the same order as before — Role matrix, Requests, Validation, Recertification, Coverage, Reports, Access Graph, Users, Groups, Shared Mailboxes, Devices, Directory Roles, Conditional Access, Admin. Nothing is kept in "More" by choice any more.

    One thing to know: "More" can still appear, but only when the window is too narrow to fit every tab — the last few fold into it rather than the bar wrapping onto a second line (that is the rule the redesign set for every tab bar). With the side menu open, all fourteen fit from about 1620px wide; with the menu folded to icons, from about 1430px. At the width of your screenshots they all fit.

    If you would rather the tabs wrap onto a second line than ever fold, that is a different rule for this one screen — say so and I'll raise it.

    To check on staging: Access Control — every tab visible, no More.

    Technical: also fixed in the shared tab bar — More used to hang off the end of the bar on a narrow window (its width estimate was slightly short), and a tab that appears after the page loads (Admin, once permissions are known) could wrongly land in More. Measured in headless Chromium at eight widths, 1100–1920.
assignee: steve
label: null
priority: medium
task_status: done
---
On the Access Control page, show all tabs by default, currently there's a 'more' section, remove this and display all tabs by default.