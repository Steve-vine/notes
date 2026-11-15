---
id: 01M7FM64QFV0446ZV7G5ENBSQX
created: 2026-11-15T12:51:17.359304Z
updated: 2026-11-15T12:52:25.842103Z
type: task
title: The workflow builder — a canvas where a person drags a trigger, conditions and actions into place and joins them, each step set up in a side panel in plain words, with Ask Polaris beside it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1854
sprint: s7nqsy0
blocked_by:
- 01M7FM5KETXGZRMTQ1YQ533CF7
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint "Automation - Workflows" (ADR in COM-1848). Builds on COM-1851 (workflows) and COM-1853 (Compass sources).

## What people see

- **New workflow** (or opening one) shows a **canvas**: a trigger block at the top, then condition blocks, then action blocks, joined by lines. Conditions branch into **Yes** and **Otherwise** paths.
- A **palette** down the side lists what can be added, in plain words, grouped as *Starts when*, *Check that* and *Then*. Only the triggers, conditions and actions that exist today are listed. Later ones simply appear.
- **Clicking a block** opens a side panel to set it up with dropdowns and pickers, never typed expressions:
  - control and check pickers;
  - a field picker that lists the fields the chosen check actually captures (with their display names), and shows a sample value;
  - document and list pickers;
  - severity, status and support pickers;
  - number boxes.
- **Each block reads as a sentence**, e.g. "Every *change* where *type* is *Standard* is on *Approved standard changes* (by reference)". Read top to bottom, the whole canvas reads as one plain description, which also shows on the workflow's page.
- **Problems show on the block**: a red mark and a line saying what's missing ("Choose a list"). A workflow with problems can be saved but not enabled.
- **Save** makes a new version (COM-1851). **Test** runs it (the test task). **Enable / Disable** sits in the header.
- **Ask Polaris** opens a panel beside the canvas. Ask in your own words ("fail when a standard change isn't on the approved list") and Polaris builds or changes the blocks on the canvas for you to see, explain and test. It can't enable (COM-1848 §7).
- **A starting point**: New workflow offers *Blank*, *Judge a check's evidence* (trigger + one condition + set status), and *Gaps from evidence* (the status-change pair).
- Works with keyboard and screen reader: every block can be reached, set up and connected without a mouse, and the sentence view is the accessible reading of the workflow.

## Notes for the builder

- Use a maintained graph-canvas library (e.g. React Flow / @xyflow/react), pinned exactly. The canvas edits the same step graph COM-1851 stores. No second format.
- Screen conventions apply to the page frame and side panel (`brief/information-architecture.md`). Fields on one row use `FieldRow`.
- Phone width: the canvas becomes the sentence view with edit links. Building on a phone isn't a goal.

## Done when

- A person can build Steve's standard-changes workflow on the canvas without Polaris, save it, and read it back as sentences.
- Starting points and problem marks work. A workflow with problems can't be enabled.
- Ask Polaris changes the canvas in front of the person.
- Vitest covers the side panels and the sentence view. Browser smoke opens the builder and adds a block.

**On the chain** only if it needs API additions (field lists, pickers). Otherwise independent once COM-1851 is in.