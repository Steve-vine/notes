---
id: 01M3CZB6BT17EYKJGG2ZRE1865
created: 2026-09-25T19:05:46.618038Z
updated: 2026-09-26T12:39:48.835486Z
type: task
title: A template can list the controls in the document's domain — the [domain-controls] placeholder
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 751
sprint: s71mee4
comments:
- id: 01M3D0J290SFBF1C4MEDJACFZ5
  author: Steve Vine
  at: 2026-09-25T19:27:00.384809Z
  text: |-
    Done: PR #761, squash-merged to main as 277f2c6.

    `[domain-controls]`, on its own line in a template, lists every live control in the document's domain as ref then title, in library order. Disabled and retired controls are left out, and a document with no domain gets an empty line. The lines are plain body text rather than headings, so they stay out of `[contents]`. Refs are in the same fixed-width font the app uses, and nothing is a link.

    The PDF is regenerated whenever the domain's controls change: one added, renamed or disabled. A PDF of an older version lists today's controls.

    This task also stops a section from being created with, or renamed to, a built-in name: `title`, `date`, `contents`, `domain-controls` or `posture`. The built-in would hide the section. Existing sections can still be edited, and staging had none with those names.

    The Templates tab help lists the new placeholder.

    To smoke-test: add `[domain-controls]` on its own line to a content type's Word template, then generate a PDF for a document that has a domain.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
A Word template gains a `[domain-controls]` placeholder. On its own line in the body of a template, it becomes a list of every control in the domain the document belongs to, in the generated PDF.

Part 1 of 2. COM-752 adds `[posture]` on the same mechanism.

## What it shows

- **Which controls:** every live control in the document's domain, one per line, as ref then title (e.g. `INS.1  An acceptable use policy has been created…`), in the domain's control order. Disabled and retired controls are left out.
- **No domain:** a document with no domain gets nothing. The placeholder's line is removed, as an unmatched section placeholder is today.
- **Formatting:** plain lines in the template's body style, with no heading of its own; the template's author writes one around it if they want. The lines are not Word headings, so they don't appear in `[contents]`. Refs and titles are plain text, not links, because a PDF is read outside Compass.
- **Placement:** like a section placeholder, it works on its own line in the document body. In a table, text box, header or footer it's cleared, the same rule sections already follow.
- **Which PDF:** the PDF shows the controls as they are when it's generated. That includes a PDF of an older published version from History, whose controls are today's rather than those at the time.
- **Templates tab:** the "Placeholders you can use in a template" help lists `[domain-controls]` with a one-line description.

## Done when

- A templated document in a domain with controls generates a PDF listing them, and a document with no domain generates cleanly without the line.
- Adding or disabling a control in the domain changes the next PDF: the cached PDF is not reused.
- The Templates tab help mentions it.

## Notes

- Today the only special block token is `contents` (`core/templating.py` ~657). Add `domain-controls` beside it as a *data* placeholder. `merge_sections_into_template` stays pure: the rows are queried in `tasks/pdf.py` and passed in. Build this as a small general mechanism, a map of block token to lines to write, so COM-752's `[posture]` reuses it.
- The PDF cache key (`tasks/pdf.py` ~92-134) must include a digest of the listed controls, as `_reviews_digest` does for the review record. Bump `_RENDERER_VERSION`.
- Built-in names are unreserved today, so a section named `domain-controls` or `posture` would be shadowed by the built-in. Refuse those names for **new or renamed** sections. Check the staging data for existing clashes first, and leave any existing section untouched, because refusing it would break editing it.
- Tests go in `tests/test_templating.py`, covering the merge output, the no-domain case, disabled controls and the cache key. The frontend test pins the help text (`ContentPage.test.tsx`).

Raised in sprint 61 (Content upgrade), 2026-09-25.