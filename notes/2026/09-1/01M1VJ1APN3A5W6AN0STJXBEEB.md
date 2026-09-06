---
id: 01M1VJ1APN3A5W6AN0STJXBEEB
created: 2026-09-06T14:30:24.725198Z
updated: 2026-09-06T15:27:19.690428Z
type: task
title: writing a new decision returns to a dialog — a large one, like every other "New…" in the app
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 589
sprint: s2fcksg
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Everywhere else in Compass, "New…" opens a dialog — a risk, a gap, a vendor, a control. Decisions are the exception: COM-578 gave writing one its own screen. The exception is a thing to learn, and it buys the reader nothing, so it goes back to a dialog — sized at roughly **80% of the viewport**, which is the part that matters.

**This deliberately reverses COM-578's placement, and not its reasoning.** COM-578 moved the form off the modal because a two-column Markdown editor is cramped "even at the widest standard dialog size" — that is Mantine's `xl`, about a third of what is proposed here. At 80% the editor gets more room than the page gives it today, since the page sits inside the shell's padding. Everything else COM-578 established stands: one `DecisionEditor` component, every entry point offering the same fields. Do not move this back to a page on the old argument — the size is what answered it.

## What is needed

- [ ] `/decisions/new` opens the Decisions list with the editor in a modal on top, rather than a separate screen. Keep the route: it is a shareable, bookmarkable URL today, and keeping it means Back closes the dialog instead of abandoning the list.
- [ ] **Supersede opens the same dialog**, carrying the decision being superseded — today it routes to the same page with `?supersedes=<number>`. If new-decision becomes a dialog and supersede stays a page, there are two places to write a decision again, which is precisely what COM-578 collapsed.
- [ ] Size it to the screen, not just the width: `size="80%"` sets width only, so the body needs a height with the editor scrolling inside it, or the dialog stays short on a tall display and the preview column is what suffers.
- [ ] `NewDecisionPage` goes; `DecisionEditor` is untouched — it does not care what holds it.
- [ ] Closing with unsaved text should not silently discard it. Click-outside is already off app-wide (COM-308), so this is about the X and Escape.

## Related

- COM-578 — one editor, three entry points. The component this depends on, and the placement this reverses.
- ADR 0017 — information architecture.
