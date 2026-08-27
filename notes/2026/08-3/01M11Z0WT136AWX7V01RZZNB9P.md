---
id: 01M11Z0WT136AWX7V01RZZNB9P
created: 2026-08-27T15:57:06.753476Z
updated: 2026-08-27T15:57:11.717375Z
type: task
title: A domain's function can be read but never set
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 465
sprint: s8cjs5n
assignee: steve
company:
- moneypenny
label:
- bug
priority: medium
task_status: todo
---
The domain list groups by CSF function — Govern, Identify, Protect, Detect,
Respond, Recover — which is the spine COM-423 chose for the library and the
reason the list is in that order rather than alphabetical. Two problems with how
that landed.

## The function is write-only from the seed

`function` is a real, indexed, nullable column on `domains`, and `DomainOut`
returns it. Neither `DomainCreate` nor `DomainUpdate` accepts it, and neither the
*New domain* modal nor the domain detail edit form offers it.

So the only thing that has ever set a domain's function is the seed. A domain
created in the app gets none, sits below Recover under "No function set", and
there is no screen that can rescue it — the edit form cannot set it either.

All 23 seeded domains currently have a function, so the unassigned bucket is
empty. It stays empty exactly until someone adds the 24th domain, and then it is
permanent.

**Fix:** add `function` to `DomainCreate` and `DomainUpdate`, and a select to both
forms. Keep it optional — nullable was a deliberate choice, because forcing a
guess puts a *wrong* function into the reporting view rather than an absent one,
and absent is honest. Offer an explicit empty option rather than defaulting to
Govern.

## The section headings are striped as though they were rows

The heading is a `Table.Tr` inside a `<Table striped highlightOnHover>`, so the
zebra pattern counts it. Headings land on alternating backgrounds, they shift the
striping of every domain row beneath them so the alternation restarts at each
group, and they highlight on hover as though they were clickable.

**Fix:** take the heading rows out of the striping and the hover. A heading should
read as a band above its group, not as an item in it — and the striping below it
should be continuous, or dropped entirely in favour of the grouping doing that
work.

Same shape as COM-460, which does this for framework requirements: a grouping row
is structure, not content. Worth landing them with a consistent treatment rather
than inventing two.

## Implementation

- Backend: two schema fields plus the `domains.py` create/update paths. No
  migration — the column, the enum and the index already exist.
- Frontend: `DomainsPage.tsx` (`CreateDomainButton`, and the heading row in the
  table body) and `DomainDetailPage.tsx` (`EditDomainForm`).
- Gate on library write, as the rest of the domain form is.

Tests: a domain created with a function keeps it and appears under that heading; a
domain created without one appears under "No function set" and can be given one
from the edit form afterwards; clearing a function returns it to unassigned.
