---
id: 01M1TSCT178BGZ79EJW64DYJ2R
created: 2026-09-06T07:19:46.471561Z
updated: 2026-09-06T08:19:09.636031Z
type: task
title: assessments get a review cadence, and saving one sets its review dates
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 566
sprint: s2fcksg
comments:
- id: 01M1TWSEZT9W9HPSF0CKGKYH32
  author: Steve Vine
  at: 2026-09-06T08:19:06.873988Z
  text: |-
    Done — PR #576, merged to main (stacked on COM-565, rebased onto main once that landed).

    **The settings tab.** Settings → Content reviews is now "Review cadence", with a section per subject: Content (the existing per-content-type rows, unchanged) and Assessments (one row, Controls, default 12 months). Live ?tab=content-reviews links land on it through the retired-tab alias COM-440 added.

    **The cadence is global**, as assumed — not per company. Say if it should follow the company; it is one table and one resolver.

    **Saving.** A control assessment save stamps last reviewed = today and next review = today + the cadence. The two date boxes are off the form and are now read-only text with the cadence named beside the next date ("6 Sept 2027 (12-month cadence)"), or "(no review cadence set)" when there is none. reviewed_at/next_review_at left AssessmentUpsert entirely rather than being accepted and ignored — they stay on the read model and in every revision snapshot.

    **"No row" vs NULL.** assessment_settings is a singleton table (entra_settings idiom). The migration seeds nothing: the absence of a row reads as the 12-month default, and NULL on a saved row is the deliberate opposite — nothing scheduled. Without that split, "nobody has set one" and "an admin turned it off" would be the same value.

    Nothing downstream needed building. Expect the Actions queue to start filling with "Review assessment" rows once a run of assessments has been saved — that is the point, but worth knowing before it looks like a second bug. No backfill; existing assessments pick the cadence up when next saved.

    Cadence changes are audited: clearing it stops Compass asking about controls at all.

    Smoke test:
    - Admin ▸ Review cadence — two sections, Controls reads 12; change it, save, confirm the toast.
    - Assess a control and save — the panel should show today's date under Last reviewed and today + cadence under Next review, with the cadence named. Nothing typeable.
    - An old ?tab=content-reviews link should still land on the tab.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Raised by Steve, 2026-09-06, after establishing that **nothing sets an assessment's review dates today**. They are typed in by hand or left blank, and a blank one simply never becomes due again — so an assessment's review cycle depends on an assessor remembering a date, with nothing behind it and nothing to notice when it is missing.

The other two review cycles in Compass already do this for you. Content carries a cadence per content type: publishing sets the first review date, recording a review moves the next one on. Vendors do not even store it — the next review is derived from the last one plus the vendor's cadence. Assessments are the odd one out, and this closes that.

## The settings tab

**Settings → Content reviews becomes just "Review cadence"** — it was never only about content, and it is about to hold two things.

It gains a section per subject:

- **Content** — the existing per-content-type rows, unchanged.
- **Assessments** — a new section, with one row: **Controls**, defaulting to **12 months**.

The section stays sensible with one row in it, because the shape is the point: this is where every review cycle's period lives, and the next assessable subject adds a row rather than another tab.

**Assumption, stated rather than asked:** the cadence is global, like the content cadences beside it and the rubrics on the next tab — not per company. Say so if it should follow the company instead.

## Saving a control assessment

Saving stamps both dates: **last reviewed = today**, **next review = today + the cadence**. Assessing a control *is* reviewing it, so the act of saving is what the dates should record.

**The two date boxes come off the form** (Steve's call, 2026-09-06). They become read-only text — the dates as they now stand, with the cadence named beside the next one:

```
Last reviewed   6 Sep 2026
Next review     6 Sep 2027  (12-month cadence)
```

Nothing to type and nothing that can be typed and then silently overwritten. Worth being deliberate about two consequences:

- **Every save re-stamps**, including one that only fixes a typo in the notes a week later. That is the behaviour asked for and it is defensible — you looked at the control — but it means "last reviewed" reads as "last touched". Content took the other road: it requires an explicit Review action to reschedule. If that turns out to matter, the fix is a separate Review action, not a date box coming back.
- **A cadence set to nothing** leaves the next review blank, exactly as content does with no cadence. Do not invent a fallback.

## Then it works on its own

Nothing downstream needs building: the Actions queue already raises a **Review assessment** item when `next_review_at` falls inside the lead window, and the reminder mail already carries it. Those rows have simply had almost nothing to fire on. Expect the queue to start filling once this lands and a run has been saved — that is the point, but it is worth knowing before it looks like a second bug.

Existing assessments keep whatever dates they have; they pick the cadence up the next time they are saved. There is no backfill, and one is not wanted — stamping "reviewed today" on records nobody has looked at would be a lie in the governance record.

## Related

- ADR 0032 / M22 — the content cadence this follows. `add_months` already exists and clamps month ends correctly.
- COM-564 / COM-565 — the same editor. Land those first; this changes the same form.
