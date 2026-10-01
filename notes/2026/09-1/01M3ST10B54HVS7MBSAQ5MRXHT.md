---
id: 01M3ST10B54HVS7MBSAQ5MRXHT
created: 2026-09-30T18:42:57.509648Z
updated: 2026-10-01T20:06:03.16572Z
type: task
title: Assessments, redesigned — the progress bar, a queue you work down with J/K and Save & next, and the menu out of the way
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 801
sprint: s0zzctz
blocked_by:
- 01M3SSZK3J4SQR87K0XGRCXHTG
- 01M3ST04QGV1F3BH3F9J4XDZXK
- 01M3ST0FF1P8KQ0DT1942KYQER
comments:
- id: 01M3TBX79SY3W3JY2BNYXSPASN
  author: Steve Vine
  at: 2026-09-30T23:55:27.929617Z
  text: |-
    Done: PR #817, merged to main (4fc73aa).

    What you'll see on Assessments:
    - **The list:**
      - "Assess next unassessed" at the top;
      - a progress card ("67% assessed · 30 controls", a bar split by status, and status chips with counts that filter);
      - filters for Domain, Framework, Tier and Maturity, a search, and Owned by me;
      - the controls grouped by domain, with status and maturity bars.
    - **Opening a control:**
      - The menu folds out of the way (and comes back when you close it).
      - The list becomes a queue on the left.
      - The control's bar shows where you are ("3 / 41").
      - **J / K** move down and up, and **Esc** closes. None of them fire while you're typing. Unsaved changes still ask first.
    - **The page:**
      - the guidance in its three parts;
      - Gaps, Linked content, Decisions and Framework mappings as sections that fold.
    - **The card on the right:**
      - status as four buttons;
      - maturity as six buttons (0–5) with the level's description;
      - owner with Assign to me;
      - evidence links and files (now with a drop zone), and notes;
      - a footer that says whether you have unsaved changes.
    - **Save & next** saves and moves to the next control, confirming "INS.2 saved · v6".

    Small changes: the save button now says "Save", and the switch says "In scope".

    Two things decided while building:
    - **The status chip counts respect every other filter** (maturity, search and Owned by me too), so a count always matches what you'll see.
    - **"Assess next unassessed" clears a status chip** that would hide the control it opens.

    All checks passed.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Part of sprint 65, UI Upgrade (ADR in COM-794). The first screen in the prototype, which is also where people spend most of their time. Built from the screen kit, in the new shell.

## What people see

**The list** (nothing open)
- **Header:** "Assessments", with **Assess next unassessed** on the right. It opens the first control in the list that has never been assessed.
- **Progress card:**
  - "**42%** assessed · 120 controls";
  - a bar split by status: Implemented, Partial, Not implemented, Not applicable and Not assessed, in their status colours;
  - chips for All and each status with its count. A chip filters the list.
- **Filter bar:** filter by ref or title, then Domain, Framework, Tier and Maturity, and the **Owned by me** toggle on the right.
- **The list is grouped by domain.** Columns are Ref, Control, Tier, Status, Maturity (bars and name) and Owner. Narrow screens show Ref, Control, Status and Maturity.

**Working through controls** (a control open)
- **The list shrinks to a queue on the left:**
  - the progress bar in miniature, the filter and the status chips;
  - each control with its status and maturity bars;
  - the open one highlighted.
- **The menu folds to icons** to make room, and comes back when you close the control. Your own sidebar toggle always wins.
- **The control's bar** shows its ref, tier and domain, "J K to move", its place ("3 / 41"), up and down buttons, **Playbook ↗** (its page) and close.
- **J / K** move to the next or previous control in the queue, and **Esc** closes. None of them fire while typing in a field. Leaving a control with unsaved changes still asks first, as today.
- **The main column:**
  - the control's title;
  - its guidance in three parts: *What this means*, *What good looks like* and *Evidence to collect*. With no guidance, authors see "No guidance has been written for this control yet. Add it in the Playbook";
  - folding sections for **Gaps** (with + Raise gap), **Linked content**, **Decisions** and **Framework mappings**.
- **The assessment card on the right:**
  - **Assessment** and its version (v5), and the **In scope** toggle. Out of scope needs a reason, from its own task.
  - **Status** as four buttons (Not implemented, Partial, Implemented, Not applicable).
  - **Maturity** as six buttons **0–5**, showing the chosen level's name and definition, plus Clear.
  - **Owner** with Assign to me.
  - **Evidence:** links, plus dropping files or browsing.
  - **Notes.**
  - **Last reviewed** and **Next review.**
  - A footer reading "● Unsaved changes" or "Saved · 29 Sep 2026", with **Save** and **Save & next ↓**.
- **Save & next** saves, then opens the next control in the queue. A note confirms it: "INS.2 saved · v6".
- **On a narrow screen** the assessment card sits above the guidance instead of beside it.

## Notes (technical)

- **Where.** `pages/AssessmentsQueuePage.tsx` and `components/AssessmentPanel.tsx`, rebuilt on the kit's focus layout, grouped list, chips and guidance renderer. Filters and state stay in the URL (COM-792).
- **Counts.** The status counts and % assessed come from the list the page already fetches. Compute them across the current Domain, Framework, Tier and Owner filters, but *before* the status chip, so the chips always show what choosing them would give.
- **Next unassessed** is the first row, in current order, with no assessment. It ignores the status chip.
- **Keys.** Mantine `useHotkeys` for J, K and Esc, guarded against inputs. Step through the same ordered list Previous and Next use today. `UnsavedChangesProvider` guards every move.
- **Folding the menu.** `useShell().requestCollapsed(true)` while a control is open, released on close or unmount.
- **Save & next** is the existing save, then Next on success. The toast carries the new version.
- **Maturity** is the existing 0–5 rubric (`maturity_level`) with names and definitions from the API. Don't hard-code the prototype's 1–5.
- **Retire** the old queue layout and anything only it used. Empty this page's entries from the page-header ratchet.
- **Tests.** Extend the queue page tests:
  - counts before the status chip;
  - next unassessed;
  - J/K/Esc, and not while typing;
  - Save & next advancing;
  - the menu folding and restoring.
- **Flakes.** Mind [[frontend-vitest-parallel-flake]]. Prove any flake against clean main.

**Done when:** on staging, Steve can open Assessments, click Assess next unassessed, and work down the queue with J/K and Save & next. The menu is out of the way while he does, and back when he closes the control.