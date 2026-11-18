---
id: 01M7NVW444FY5D01TE1FXS0NKV
created: 2026-11-17T23:01:04.260283Z
updated: 2026-11-18T10:04:41.527886Z
type: task
title: 'Library search: ranked across titles, tags, summaries, folders and the text, in this folder or everywhere'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1920
sprint: s2q1gxe
blocked_by:
- 01M7NVTSYDM1W80CQ23GEHGPZS
- 01M7NVVC1D5CRMTPGPX65THYMX
comments:
- id: 01M7Q1V85QY8EPE43GT1VPFENA
  author: Steve Vine
  at: 2026-11-18T10:04:41.527736Z
  text: |-
    Done: merged as PR #1924 (1f3e7ccf). All required checks passed. No migration was needed: searching the published text as you type is fast enough.

    What a person can do now:
    - **Home:** a large centred box, "Search titles, summaries, tags and folders…", with a / hint. Under it are the type chips and **Try** with the four most-used tags.
    - **In a folder:** a full-width box, "Search Access & identity…", with **This folder / Everywhere**. This folder covers the folder and everything under it.
    - **Keys:** / puts you in the box from anywhere. Esc clears it, and Esc again leaves it. Enter opens the top result, in Content until the reading pane lands in COM-1921.
    - **Results:** they replace the cards as you type, with no Search button.
      - The count line: "N documents for “q” in X · Enter opens the first".
      - Matching folders as chips: "Audit & certification › PCI DSS · 7 docs".
      - Documents as rows: type icon, title and summary with the matched words marked, every folder path the document is in, and its type.
      - The type chips count and narrow the results.
    - **Nothing found:** "Nothing matches “xyz”", with **Search everywhere instead** in a folder.
    - **Address:** the search is in it (?q=), so Back and shared links work.
    - **What it searches:** only published documents and accepted decisions. A document with unpublished changes is found by its published title and text, never the draft's.
    - **Ranking:**
      - Best first: the title's start, a word in the title, anywhere in the title, a tag, the type, the summary, a folder it's in, then the published text.
      - Every word typed must match somewhere.
      - Word endings and near-misses are forgiven ("ransom" finds Ransomware).

    Tested on seeded data:
    - "ransom" ranks the Ransomware runbook first.
    - "pci access" finds documents in both the PCI DSS and Access & identity folders.
    - A tag-only match is found.
    - A word only in the text is found, ranked below title matches, with a snippet.
    - Draft words and proposed decisions are never found.
    - Folder scope, type filter and permissions are checked too.

    Choices made, for Steve to overturn:
    1. A folder chip shows when its name matches any one word typed. That's what gives "pci access" both chips. At most 6 show.
    2. A near-miss of a title or tag word ("ransomwear") still finds the document. It ranks below a folder match and above a text match.
    3. Plurals match singulars ("policies" finds a Policy).
    4. Typing a decision's number ("DEC-12") ranks it as a title match.
    5. When a word matches only in the text, the row shows a few words of that text with the word marked.

    Not yet checked: phone width in a real browser. That's in the pre-UAT pass after deploy.
assignee: steve
label:
- feature
priority: medium
task_status: active
---
The Library's search box, as in the design. Built on COM-1916 (folders), COM-1917 (summary and tags) and COM-1918 (the page).

**The box**
- On the home: large and centred, "Search titles, summaries, tags and folders…", with a **/** hint. Under it, the type chips and **Try** with four suggestions, taken from the tags used most.
- In a folder: full width, "Search Access & identity…", with **This folder / Everywhere**. This folder searches the folder and every folder under it.
- **/** anywhere on the page puts you in the box. Esc clears it, and Esc again leaves it.

**What it finds, best first**
- Every word typed must match somewhere. A document ranks higher the better its words match: the title's start, then a word in the title, then anywhere in the title, then a tag, then the type ("policy", "runbooks"), then the summary, then a folder it sits in, then the document's own published text.
- Typos and word endings are forgiven where it's cheap to do so ("ransom" finds Ransomware, "rotat" finds rotation).
- **Folders** that match show first as small chips with their path and document count ("Audit & certification › PCI DSS · 7 docs"). Clicking one opens it.
- **Documents** show as rows: type icon, title and summary with the matched words highlighted, each folder path it's in, and its type. The type chips narrow the results and show counts for them.
- "5 documents for “pci access” in Access & identity · Enter opens the first". Enter opens the top result in the reading pane (COM-1921; until then, in Content).
- Nothing found: "Nothing matches “xyz”", and in a folder **Search everywhere instead**.

**Rules**
- Only published versions, and only what the person can see. A draft's words are never found.
- Results feel instant: as you type, with no Search button.
- The query is in the address, so Back works and a search can be shared.

**Done when**
- The examples from the design work on staging test data: "ransom" ranks the Ransomware runbook first; "pci access" finds documents in PCI DSS and Access & identity; a tag-only match is found; a word only in a document's text is found and ranked below title matches.
- This folder / Everywhere, folder chips, highlights, type chips, Enter, / and Esc all work.
- Phone width: no sideways scroll.

On the chain: a new search API for the Library.