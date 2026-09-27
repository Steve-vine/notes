---
id: 01M3HJFZNQPVK6GZQ0087H7EWE
created: 2026-09-27T13:57:24.279641Z
updated: 2026-09-27T14:26:28.877322Z
type: task
title: Markdown issues
project: 01KY6W9951TW0904DT0GGJVGE7
number: 450
sprint: sqsolof
assignee: steve
label: null
priority: medium
task_status: todo
tech: null
---
The following Markdown renders incorrectly in either Read or Live view, example screen clips are attached

\#### Closed ATX heading ####
Live view
![CleanShot 2026-09-27 at 14.59.45@2x.png](attachments/2026/09/01M3HJFZNQPVK6GZQ0087H7EWE/CleanShot-2026-09-27-at-14.59.45@2x.png)
---
---

This line ends with a backslash\
so this should also be on a new line.
Live view
![CleanShot 2026-09-27 at 15.02.21@2x.png](attachments/2026/09/01M3HJFZNQPVK6GZQ0087H7EWE/CleanShot-2026-09-27-at-15.02.21@2x.png)
---
---

Loose list (paragraphs between items):

- First item

- Second item, with a second paragraph.

  This paragraph belongs to the second item.

- Third item
Read view
![CleanShot 2026-09-27 at 15.06.29@2x.png](attachments/2026/09/01M3HJFZNQPVK6GZQ0087H7EWE/CleanShot-2026-09-27-at-15.06.29@2x.png)

---

[Inline link with title](https://example.com "Example title")

Both Live and Read View
![CleanShot 2026-09-27 at 15.10.40@2x.png](attachments/2026/09/01M3HJFZNQPVK6GZQ0087H7EWE/CleanShot-2026-09-27-at-15.10.40@2x.png)
---
---

[Anchor link to section 3](#3-commonmark--emphasis)

These don't work
---

---

Entities: &copy; &amp; &lt; &gt; &quot; &nbsp; &#169; &#x1F600;

In Live view
![CleanShot 2026-09-27 at 15.20.18@2x.png](attachments/2026/09/01M3HJFZNQPVK6GZQ0087H7EWE/CleanShot-2026-09-27-at-15.20.18@2x.png)

---

<div align="center">
  <strong>Block-level HTML</strong>
</div>

<details>
<summary>Click to expand (details/summary)</summary>

Hidden content with **Markdown** inside.

</details>

In Live view, renders as above
![CleanShot 2026-09-27 at 15.26.02@2x.png](attachments/2026/09/01M3HJFZNQPVK6GZQ0087H7EWE/CleanShot-2026-09-27-at-15.26.02@2x.png)

---

