---
id: 01M7TJTBQY7NJRRA76CQ2KKTJ8
created: 2026-11-19T18:59:01.50282Z
updated: 2026-11-19T20:40:34.657085Z
type: task
title: The reader's width button leaves the reader's bar for the far right, below it, matching the Library page
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1987
sprint: s2q1gxe
blocked_by:
- 01M7TJT0NV5ZX7ACR938EPSGYV
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Steve, testing the Library on staging (19 Nov): in the document reader, move the Reading width button off the reader's top bar to the same position as the Library page's width button (COM-1986): the far right, just under the bar.

**Today:** the Reading width button (COM-1962) is one of the icons in the reader's bar, between Open in Content and the light/dark switch. On a phone it's in the bar's More menu.

**What a person sees**
- The reader's bar no longer has the Reading width icon. The bar keeps ← Library, the type and title, ⓘ, Contents, Export, Open in Content (editors) and the light/dark switch.
- The Reading width button sits at the far right of the window, just under the reader's bar. That's the same spot as the Page width button on the Library page, so moving from the Library into a document leaves it in place.
- It's unchanged otherwise: the same icon, "Reading width" tooltip, menu (Normal / Wide / Full width, with the current one marked) and keyboard use.
- It still shows only for documents the reader lays out itself, not uploaded PDFs or links.

**Choices, for Steve to overturn**
- The reader covers the app's top bar, so there's no profile icon above it there. "The same position" means the same place in the window: far right, directly below the bar.
- It stays in view while you scroll, like the bar, because the reader's bar stays put as you read.
- On a phone it stays in the More menu, because a floating button would sit over the text.

**Done when**
- At 1920 px, the Reading width button is gone from the bar and sits at the far right under it, in line with where the Library page's Page width button is. It stays there while scrolling, and it never covers the text at Normal, Wide or Full width.
- Choosing a width still changes the column and is still remembered. It's absent for uploaded PDFs and links. Print shows no button.
- On a phone the More menu still offers it. No sideways scroll.
- Tests are updated, and the e2e Library crawl still passes.

Builds on COM-1962 and COM-1986. Frontend only.