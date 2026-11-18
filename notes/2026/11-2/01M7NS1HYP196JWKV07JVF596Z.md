---
id: 01M7NS1HYP196JWKV07JVF596Z
created: 2026-11-17T22:11:36.534509Z
updated: 2026-11-18T03:02:21.201209Z
type: task
title: 'Landscape page: a break that puts the content after it on landscape pages in PDF and Word'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1914
sprint: s6y6p7g
comments:
- id: 01M7P9NXRHPNAJ6HFQQRJH1VDG
  author: Steve Vine
  at: 2026-11-18T03:02:21.201082Z
  text: |-
    Done — PR #1901, merged 1789d224.
    - In a document's editor, Insert ▸ Landscape page sits next to Page break and shows as a "Landscape page" line in the same style.
    - In the PDF and Word file, everything after it is on landscape pages (the same paper turned sideways, the house margins, header, footer and page numbers carrying on) until the next Page break, even across sections, or to the end of the document if no Page break follows.
    - A second Landscape page inside a landscape run just starts a new landscape page. The title page and the contents stay portrait, and headings on landscape pages are listed in the contents with their page numbers.
    - Plain text and search ignore it. The reading view shows the marker line. Compare versions shows a Landscape page added or removed, as it does a Page break.
    - Word: each part of the document now has its own header and footer laid across its own width. Before, the right-hand slot was placed for a standard portrait page only.
    Assumption: a Landscape page inside a list, quote or table only breaks the page. The editor's Insert menu puts it at the top level of a section, which is where it turns the page.
    To check on staging: put Landscape page → a wide table → Page break in a document, then download the PDF and the Word file. Check that the table is on a landscape page with the header and footer across it, and that the pages either side are portrait.
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Steve, 2026-11-17: wide diagrams (and wide tables) read better on a landscape page. The author marks where landscape starts, and a normal page break returns to portrait.

**What the author sees**
- In a document's editor, next to **Page break**, a new **Landscape page** shows as a labelled line ("Landscape page") in the same style as the Page break line.
- **Landscape page** starts a new page, and everything after it is on landscape pages.
- **Page break** starts a new page, and everything after it is on portrait pages, as today. So Landscape page → content → Page break puts that content on landscape pages, then carries on in portrait.
- A Landscape page after another one just starts a new landscape page. A Landscape page with no Page break after it stays landscape to the end of the document.
- It carries across sections: a Landscape page in one section continues through the next sections until a Page break.
- Removing either marker works like removing a page break today.

**What PDF and Word produce**
- The landscape pages are the same paper size turned sideways, with the house style's margins, header and footer laid across the wider page. Page numbers carry on.
- The title page and the contents stay portrait. Headings on landscape pages appear in the contents with their page numbers as usual.
- Word gets a landscape section in the same place, so the document still opens and prints correctly in Word.
- The plain-text export, search and the reading view ignore orientation, though the reading view still shows the marker line as it shows a page break.

**Done when**
- A document with Landscape page → a wide table or picture → Page break produces a PDF and a Word file where that content is on landscape page(s) and the rest is portrait, with header, footer and page numbers right on both.
- Landscape running across sections, and to the end of the document, both work.
- Compare versions reports an added or removed Landscape page like a page break.

Independent: no migration, no API change. It changes the document format next to Page break, so whichever of this and COM-1904 lands second rebases. Flowcharts use it: COM-1910 suggests it for a wide flowchart.