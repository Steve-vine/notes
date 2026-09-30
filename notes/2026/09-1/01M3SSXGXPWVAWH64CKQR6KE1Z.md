---
id: 01M3SSXGXPWVAWH64CKQR6KE1Z
created: 2026-09-30T18:41:03.414137Z
updated: 2026-09-30T18:46:42.687657Z
type: task
title: 'ADR: Compass takes the Nocturne look — one fixed palette, the prototype''s screen patterns, and Admin ▸ Appearance retired'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 794
sprint: s0zzctz
assignee: steve
label:
- brief
priority: high
task_status: backlog
---
Opens sprint 65, UI Upgrade. Steve designed the new Compass in Claude Design, and this ADR records what it commits us to. Every other task in the sprint follows it.

**Design source:** Claude Design project *Compass Site Redesign Review* (`891a3126-6ab8-4868-8550-6f744d19c0c1`).
- `Compass Redesign.dc.html` is the prototype of the shell and six screens: Assessments list and focus, Controls, a control's page, Vendors, a vendor's page, and Access roles.
- `_ds/nocturne-43a0d95c-a94a-4982-86a6-2b765914cf5b/` holds `readme.md` (the design system's rules) and `styles.css` (the tokens).
- Read them with DesignSync `get_file`. The uploaded screenshots are over the tool's 256 KiB cap and come back truncated.

## What Steve decided (2026-09-30)

- **Every screen is redesigned**, including both portals and the sign-in pages. The six prototyped screens set the patterns, and the rest follow them.
- **The palette is fixed.** The prototype's colours replace whatever an admin chose, and Admin ▸ Appearance goes.
- **The top bar carries the trail** (the way you came, ADR 0084) where the prototype draws its path. It is not a map of where a page is filed.
- **A page title stands alone.** The prototype's one-line descriptions under titles are dropped, and the screen convention "a screen does not explain itself" stands.
- **Light or dark follows the computer's setting.** The top-bar toggle overrides it and is remembered, as today.
- **The small new features the prototype shows are built**, each in its section's task.
- **An out-of-scope assessment needs a reason** from now on.
- **Controls can be exported.**
- **Vendors get a "Needs attention" filter.**

## Decided without asking Steve (stated to him)

- **Maturity stays 0–5.** The prototype draws 1–5, which would drop "0 — Non-existent".
- **Guidance stays one markdown field.** It is rendered in the prototype's three sections (What this means / What good looks like / Evidence to collect), which is the ADR 0059 §4 convention it is already written to.
- **Icons are Phosphor and the typeface is Inter**, as the design system specifies.
- **A vendor's compliance-rule banner is shown to everyone who can see the vendor.** Only editors get the fix button.

## The sprint's tasks

- **Foundation, in order:**
  - COM-796 the look, and Appearance retired;
  - COM-797 icons;
  - COM-798 the shell;
  - COM-799 the screen kit.
- **Sections** (each after the kit):
  - COM-800 out-of-scope reason;
  - COM-801 Assessments;
  - COM-802 Controls list;
  - COM-803 a control's page;
  - COM-804 the rest of the Playbook;
  - COM-805 Vendor lists;
  - COM-806 a vendor's page;
  - COM-807 Access roles and workflows;
  - COM-808 Access directory views;
  - COM-809 Gaps, Risks and Timeline;
  - COM-810 overview screens;
  - COM-811 Inventory;
  - COM-812 Admin;
  - COM-813 the user portal;
  - COM-814 the vendor portal and sign-in.

## Notes (technical)

- **Write `decisions/0085-*.md`.** The ADR records:
  - The Nocturne tokens as the one palette: the dark ground `#161826`, the accent `#9184d9`, and the light variant from the prototype's `[data-theme="light"]` block.
  - The status tones. The prototype's `TD` and `TL` constants give good, warn, high and bad as oklch values.
  - Inter, the 8px radius, the 0.7× density, and Phosphor.
  - The retirement of the per-organisation palette from COM-631. Supersede whatever recorded it; if it was never an ADR, say so.
  - An amendment to where ADR 0084's trail is drawn. Its behaviour is unchanged.
- **The screen patterns** each section builds from, detailed in COM-799:
  - a page header (title, actions on the right, no subtitle);
  - an underline tab bar whose overflow folds into a **More** menu;
  - a filter bar (search, "Label: Value ▾" filters, counts and toggles on the right);
  - quick-filter chips with counts;
  - grouped list rows with sticky column and group headings;
  - summary cards;
  - a detail layout (header, fact cards, tabs, a main column and a sticky side column of cards);
  - collapsible sections;
  - the focus mode (a queue on the left, the record on the right).
- **Update `brief/information-architecture.md` → *Screen conventions*.** Add the patterns above and keep every existing rule:
  - a pill shows its whole label;
  - toggles are `fit-content`;
  - row actions have their own column;
  - no subtitles.

**Done when:** the ADR and the IA brief update are merged.