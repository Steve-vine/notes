---
id: 01M7QBXQVB28REFHRDTC35SVHE
created: 2026-11-18T13:00:48.875006Z
updated: 2026-11-18T14:00:39.043051Z
type: task
title: Library search snippets show the document's words, never flowchart or diagram markup
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1949
sprint: s2q1gxe
comments:
- id: 01M7QFB6J8KKC2MBG7498EQS2E
  author: Steve Vine
  at: 2026-11-18T14:00:35.656298Z
  text: |-
    Done: PR #1935, merged as efa9787c.

    Library search now matches a document's readable words, and quotes them in its snippets:
    - a flowchart gives its caption and steps;
    - a picture, drawing or diagram gives its caption;
    - a link gives its text.

    Words that exist only in the stored markup ("asset", "caption", block ids, diagram source) no longer find anything. Polaris's Library search uses the same search, so its snippets are clean too.

    Cause: search matched and quoted each published version's stored Markdown, which keeps every block's attributes, chart data and diagram source.

    Technical:
    - richtext/plaintext.py gains a words-only mode, document_words(). body_words(), the global-search snippet from COM-1932, now uses it.
    - library_search._content matches in Python against those words, cached per published version id. Published versions never change, so the cache can't go stale; it's capped at 20k entries.
    - Decisions are unchanged.
    - Tests: a unit test reads a document holding every block kind as exactly its words. An integration test finds a document by a flowchart step, a caption and a drawing's caption, each with a clean snippet ("2. Triage by the duty analyst"), while markup words find nothing.

    For Steve to overturn:
    - Global search snippets also lose the "[Flowchart: …]" / "[Diagram: …]" labels and link addresses.
    - A flowchart shown inside another document adds no words to that document. It's still found as its own Library document.

    Re-check on staging after the next deploy.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found in the Library pre-UAT pass on staging (c15afb4d, 2026-11-18, COM-1920).

**What happened:** searching the Library for "service request handling" showed the flowchart document's snippet as `…flowchart {asset=9469d4d1-499e-4d09-9777-a3dbdc9157d5 caption="E2E…`. That's the stored markup of the flowchart block, not words a reader would recognise. Screenshot: ~/compass-uat/library/COM-1920/11.

**Done when**
- The text the Library searches and quotes from is the document's readable words. That means the same plain text Content's search and plain-text export use. A flowchart contributes its caption and steps, and other non-text blocks contribute their caption or nothing.
- No snippet, in the Library or from Polaris's Library search, shows asset ids, block names or attribute syntax.
- A test searches a document with a flowchart, a drawing and a text diagram, and checks the snippet holds only words.

On the chain: changes what the Library's search API returns.