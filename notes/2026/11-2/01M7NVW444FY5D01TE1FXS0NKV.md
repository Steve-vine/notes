---
id: 01M7NVW444FY5D01TE1FXS0NKV
created: 2026-11-17T23:01:04.260283Z
updated: 2026-11-18T14:25:33.113795Z
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
- id: 01M7QBWC63P2H44YPWA5E84Y93
  author: Steve Vine
  at: 2026-11-18T13:00:04.163224Z
  text: |-
    Pre-UAT (staging build c15afb4d, E2E Test Company, E2E Admin A and E2E Viewer): **Failed**. Two defects have been raised as new tasks and are being fixed forward. Everything else passed.

    Defects:
    1. **The home's "Try" suggestions came from a draft's tags.** An E2E draft's tags ("backup testing, incident reporting, lost laptop, one hour") showed as the Try row, the Viewer saw them too, and they vanished when the draft was deleted. A draft must never surface in the Library. Screenshots: COM-1920/01, 02.
    2. **A search snippet showed raw flowchart markup.** Searching "service request handling" showed `…flowchart {asset=9469d4d1-… caption="E2E…` in the snippet of a flowchart document. Screenshot: COM-1920/11.

    Passed:
    - **Home box:** "Search titles, summaries, tags and folders…" with the / hint, and / puts you in the box.
    - **In a folder:** "Search <folder>…" with This folder / Everywhere. "wireless" found 3 in Network & Remote Access and 5 Everywhere.
    - **Esc:** clears the box, then leaves it, then goes up a level.
    - **Results:** they appear as you type, with "N documents for “q” · Enter opens the first".
      - Folder chips.
      - Rows with the matched words highlighted, folder paths and type.
      - Type chips narrow the results and count them.
    - **Enter** opens the top result in the reading pane.
    - **Nothing found:** "Nothing matches “ransom” in Network & Remote Access", and Search everywhere instead works.
    - **Address and Back:** the query is in the address, and Back from the pane returns to the results.
    - **The design's examples:**
      - "ransom" gave 3 results, matched in their text.
      - "pci access" gave the folder chips plus User Credentials Policy.
      - A word only in a document's text ("laptop") was found, with a highlighted snippet.
    - **Rules (checked through the API):**
      - A draft's unique title word isn't found.
      - Scoping to a folder includes its subfolders.
      - The type filter narrows results while the type counts stay whole.
    - **Phone:** no sideways scroll.

    Couldn't check:
    - "Ransomware runbook ranks first": staging has no Ransomware runbook.
    - A tag-only match on a published document: no published document on staging has tags. Through the API, a tag-only word on a test document was found by tag.

    Note for Steve: typing a search replaces the current Back step rather than adding one. Back from results inside a folder therefore goes to the page before the folder, not to the unsearched folder.

    Screenshots: ~/compass-uat/library/COM-1920/01–12.
- id: 01M7QGRWXS7G2N8A2FZFCYT7AG
  author: Steve Vine
  at: 2026-11-18T14:25:33.113566Z
  text: |-
    Pre-UAT follow-up: now Passed. Checked on staging a3e70502, 18 Nov 14:22–14:25 GMT, in E2E Test Company.

    This morning's two defects are fixed forward and re-checked on staging:
    - COM-1948: Try suggestions now come only from published tags.
    - COM-1949: snippets show words, not flowchart markup.

    The tag-only search, which I couldn't check this morning because no published document had a tag, has now been checked. I tagged the published "E2E pre-UAT COM-1907 Service request handling" with "e2e service desk". A Library search for "e2e service desk" found it, as Admin A, and the Viewer saw the tag offered under Try. I removed the tag afterwards.

    Still for Steve: a "ransomware" runbook ranking first, because staging has no such runbook.
assignee: steve
label:
- feature
priority: medium
task_status: review
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