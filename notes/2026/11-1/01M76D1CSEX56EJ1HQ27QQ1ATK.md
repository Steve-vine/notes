---
id: 01M76D1CSEX56EJ1HQ27QQ1ATK
created: 2026-11-11T22:53:11.854513Z
updated: 2026-11-11T22:53:14.004321Z
type: task
title: A person's pinned pages are saved to them, so they follow them to any browser; someone new starts with Dashboard and Actions
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1743
sprint: spsp226
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Part of the new menu (ADR task COM-1742; design: Claude Design project "Compass app navigation redesign", `Navigation Concepts.dc.html`, turn 2a). **On the chain:** it adds a migration and changes the API.

**What it does:**
- A person's pinned pages are an **ordered list saved with their own preferences**, like their time zone and mail settings. They see the same pins in any browser or on any computer they sign in on.
- **Someone who has never pinned anything** gets **Dashboard and Actions**. This covers existing staff on the day it ships, as well as new joiners.
- **Unpinning everything** is kept as an empty list. It doesn't fall back to Dashboard and Actions.
- Only the person can read or change their own pins. Nobody else's pins are visible or changeable, administrators included.
- **A pin to a page the person can no longer see** (their role changed) is kept but not shown. It comes back if they regain access. Pins name pages, not records.
- The pin list has a sensible upper limit (around 40, more than the number of pages) so it can't grow without bound.

**Not in this task:** the menu that shows and reorders the pins (the menu task, which builds on this one).

**Done when:**
- A person's pins, in order, are saved and read back as theirs, and survive signing out and in on another browser.
- Someone with nothing saved reads Dashboard and Actions.
- One person can't read or change another's pins.
- A pin to a page they can't see isn't returned to the menu, and returns when access does.