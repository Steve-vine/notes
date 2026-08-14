---
id: 01KZZTVQY2J7PCGA32DAN3P0RN
created: 2026-08-14T09:50:12.930897Z
updated: 2026-08-14T13:03:37.451165Z
type: task
title: The incident's raised line gives recency but not the date — show both
project: 01KX671DATY39VW6GWK3M2T3DN
number: 705
sprint: sevhjex
comments:
- id: 01M005XEJE6XAWNXPJ1EANFPP5
  author: Steve Vine
  at: 2026-08-14T13:03:23.214213Z
  text: |-
    Built and merged — PR #655 (squashed to main 2026-08-14).

    The header now reads "Raised 10 Aug 2026, 10:49 (4d ago) by finding-promotion": absolute first because it is the half that does not decay, recency in brackets after it, attribution unchanged, and the raw ISO on the element's `title` so the untruncated UTC value is one hover away.

    Format decision, as the ticket asked for a deliberate one: reused the house `dateTime()` (ISE-209) rather than adding the ordinal/long-month form the report worded. A second date convention here would leave the entity page and report runs inconsistent with the incident header for the sake of three characters. If the long form is specifically wanted, it is now a one-line change in one place.

    The composition lives in `lib/format.ts` as `dateTimeWithAge(iso, nowMs)` rather than inline in the JSX, so it unit tests without mounting a 2000-line page — `lib/format.test.ts` pins the shape, the house format, and the just-now case.

    Scope held to this line: the incidents list, Recall priors and component ages are all scanned by recency and are untouched.
assignee: steve
label:
- improvement
priority: medium
task_status: review
tech: null
---
The incident header shows only a decaying relative label (`IssueDetailPage.tsx:2266`, verified on `origin/main` @ 75c57f6):

```tsx
Raised {relativeTime(issue.created_at)} by {issue.created_by}
```

giving *"Raised 4d ago by finding-promotion"*. "4d ago" answers "is this fresh?" but not "when?", and an incident's start time is a fact people correlate against change windows, deploys and other incidents.

**Wanted:**

> Raised 10th August 2026 10:49 (4d ago) by finding-promotion

Absolute first, relative in brackets after it, attribution unchanged. `relativeTime` comes from `lib/systemStatus.ts:27`.

**Decide the format against the house one.** `lib/format.ts:10` already has `dateTime()`, in use since ISE-209 on the entity page and report runs, rendering **"10 Aug 2026, 10:49"** — short month, comma, no ordinal. Its docstring makes exactly the argument behind this request: *"'2h ago' answers 'is this fresh?'; it cannot answer 'when exactly?', and a decaying label is the wrong shape for a permanent record."*

The requested wording ("10th August 2026 10:49") differs from it in three ways — ordinal day, full month name, no comma. Two options, and it is worth a deliberate choice rather than a drift:
- **Reuse `dateTime()`** → *"Raised 10 Aug 2026, 10:49 (4d ago) by …"*. One date format across the app; nothing new to maintain.
- **Add an ordinal/long-month formatter** → matches the request exactly, but introduces a second date convention that other screens will then be inconsistent with.

Recommend reusing `dateTime()` unless the long form is specifically wanted here; either way put it in `lib/format.ts` rather than inline, and pair it with the raw ISO in `title` as the existing callers do, so the untruncated UTC value stays one hover away.

**Scope note — this line only.** The incidents *list* is scanned by recency, where a relative label is the right shape; do not sweep it. `relativeTime` also renders Recall priors and component ages, which are the same "is this fresh?" question and should stay as they are.