---
id: 01M7QVPDNK6RCTVBSKXH51G1HB
created: 2026-11-18T17:36:26.29167Z
updated: 2026-11-18T17:36:33.144213Z
type: task
title: Each Library section can be sorted by name, created date or review date, either way
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1970
sprint: s2q1gxe
blocked_by:
- 01M7QV18EEP76MSWB8XSZ5F814
- 01M7QV1M06BT06WRAZ0ASEEWVT
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Steve, testing the Library on staging (18 Nov): every section title bar in the Library gets small sort icons on its right.

**Where:** every titled section in the Library:
- on the home: Pinned, Recently viewed, Folders and Domains;
- in a folder, including a domain folder and "Not in a folder": its Folders and Documents sections.

**What a person sees**
- On the right of the section's title bar there are three small icon buttons: **A–Z** (name), **Created** (creation date) and **Reviewed** (last review date).
- Clicking one sorts that section: A–Z, and dates newest first. Clicking the same one again reverses it, and a small arrow shows which way it runs. A third click returns the section to its own order.
- The section's own order is:
  - Pinned: newest pin first;
  - Recently viewed: most recent first;
  - Folders: the arranged order;
  - Domains: the domains' order;
  - Documents: as now.
- Each button's name says what it does and its current direction ("Sort by name, A to Z").

**Choices, for Steve to overturn**
- Sorting only changes what you see. It never changes the arranged order of folders for anyone else.
- The choice is remembered per section and per person, and follows them to any browser, like the reader width (COM-1962).
- "Created" means when a document or decision was first created, a folder was made, or a domain was added. "Reviewed" means a document's last review, or a decision's decided date.
- Folders have no review date. In a section of folders the Reviewed button doesn't show. In a mixed section, like Pinned or Recently viewed, folders and never-reviewed documents go last in either direction.
- Search results stay ranked by best match and have no sort buttons.

**Done when**
- Each listed section sorts by all three, both ways, and returns to its own order. Tests cover the ordering rules, including ties broken by name and undated items last.
- The buttons work from the keyboard and fit the title bar on a phone without wrapping the title.
- The choice persists across reload, sign-out and another browser, separately for each section.
- The e2e Library crawl still passes.

Builds on COM-1967 (the home's sections) and COM-1968 (Pinned). Mostly frontend. The creation and review dates the cards need may require a small API addition; if so, it joins the end of the chain.