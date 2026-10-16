---
id: 01M51YE7E465PBEDQQPPC8BRZ3
created: 2026-10-16T08:49:42.340056Z
updated: 2026-10-16T08:49:44.62435Z
type: task
title: Text or a drawing added in a document's editor doesn't save
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 999
sprint: s2ufsxd
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Found in Steve's smoke test of sprint 71 (COM-988 / COM-993), 2026-10-16: "If I add something on the document editor like text or a drawing, it doesn't save."

**Not yet reproduced.** The steps are being confirmed with Steve.

## What the staging logs show (2026-10-16, deploy 1f57e6e9)

- **Steve's browser sent one save** from a document's editor all morning: User Credentials Policy at 08:27 BST, and it succeeded. That document is Published, so the edit went into its unpublished draft; its "unpublished changes" flag is set.
- **No drawing was ever saved, by anyone.** No browser has loaded the drawing editor (Excalidraw) or the text-diagram (Mermaid) code from this deploy, so either the Insert menu never opened them or they failed before loading.
- **Artificial Intelligence Policy has no sections.** Its Edit tab shows "Nothing written yet" with "Start from the current text" instead of an editor. That flow may be where it goes wrong: no section was ever created from it.
- **Only 3 documents on staging have sections:** User Credentials Policy, AI Risk Assessment Standard and Access Control Policy. Every other templated document opens to "Nothing written yet".

## What has been ruled out

- **Main's code, in a real browser**, with the real document page and its Edit tab (Playwright harness, stubbed API): typing in a section saves within a second, and "Saved" shows.
- **The cached PDF:** a section save also moves the document's last-changed time, so the draft's Print preview is re-rendered, not served stale.

## To find out from Steve

- Which document?
- What does the note beside **Rich text | Markdown** say after typing: Saving…, Saved, or nothing?
- How does it show as not saved: after a reload, on the Read tab, or in Print preview?
- For a drawing: does the drawing window open, and what happens on Done?

## Done when

- [ ] Text typed into a section, and a drawing added with Insert ▸ Drawn diagram, are both still there after a reload, and both appear in Print preview.
- [ ] A document with no sections offers a clear way to start writing, and that creates a section that saves.
