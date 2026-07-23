---
id: 01KY71XJMGT67NXG071CHYHD4D
created: 2026-07-23T08:36:50.448014Z
updated: 2026-07-23T09:08:58.446569Z
type: task
title: Create capability to add a 'Ghost' task
assignee: steve
label: null
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 248
---
A Ghost task is basically a placeholder for an existing task. The use case would be, a particular project has a requirement to do something that already has a task in another project.  Rather than creating another task that duplicates the content and may get missed when the first one is completed, a ghost task is a stand-in for the main task.

To create a ghost task, on the new note form, when the type Task is selected, a button (with a picture of a ghost on) appears on the right hand side of the title. When clicked it brings up a search box, allowing the user to search for and select a task, then it duplicates all the content, including taxonomies from the new note, only the ID is unique.

When the original note or the ghost note is updated, it's opposite should be updated as well.  In short, these notes always remain absolutely identical, other than the reference. Content, status, tax, always remain identical.  If the original note is deleted, the link is broken and the ghost note becomes a normal note.

Ghost notes should appear as a different colour on the kanban card and also have a different colour background when viewed.

It should be possible to create more than one ghost note from an real note but never a ghost note from another ghost note.

---

Linear DEV-901 · Project Enhancements · created 2026-07-07 · done 2026-07-11