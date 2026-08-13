---
id: 01KZY1S2E1P0G09KCBY3WPBH6F
created: 2026-08-13T17:12:36.545701Z
updated: 2026-08-13T21:35:36.659173Z
type: task
title: 'Incident header: Merge into joins the action row, raw evidence joins the description line'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 693
sprint: sevhjex
comments:
- id: 01KZYGTKZZ6V51VE66A9KK803A
  author: Steve Vine
  at: 2026-08-13T21:35:35.934904Z
  text: |-
    2026-08-13 — DONE, PR #646 merged to main. Built after ISE-691 as the task directed, since both reorder the same header; landed as a stacked branch and rebased onto main once #644 merged.

    **"Merge into…" is in the action row**, between the assignee and Ask Assist:

        Assigned to · AssigneeControl · [Merge into…] · [Ask Assist] · [Work in Claude] · [Raise ticket]

    **The size check the task asked for was worth making.** All three neighbours are `size="xs"`; `MergeIntoControl` was `compact-sm`, so dropped in as-is it would have sat at a different height from everything beside it. It was `compact-sm` while it stood alone in the panel stack, where nothing sat next to it to disagree with — a size that was fine in isolation and wrong the moment it had company. Now `xs`.

    **The raw-evidence toggle is on the description line**, with the Collapse/EvidenceBlock beneath. `align="baseline"` so a wrapping description keeps the toggle aligned to its last line rather than its box, and `wrap="wrap"` so a long one pushes the toggle down instead of off the row — both as specified. `IncidentDescription`'s two shapes (plain `Text` for a manual/reaped signal, `Anchor` + modal otherwise) both sit in the Group unchanged.

    **Wording: kept as "Show raw evidence".** The task flagged the reported name differed. "Raw" is the accurate word for what it opens — the unformatted evidence payload — and the control's job did not change, so renaming it would only break the association for anyone who knows it.

    **Guards untouched.** `MergeIntoControl` still renders nothing for a child or a non-mergeable status, so the row has to tolerate its absence; a `Group` does that for free.

    **On testing a pure layout change:** both controls existed before and after, so a presence test would have passed unchanged against the old layout and proved nothing. The tests assert DOM relationship instead — the merge button shares a parent with "Assigned to", and the toggle shares one with the description text. That is the only form of assertion that can fail if the change is reverted.

    Verified: 11 tests in IssueImpactPanel.test.tsx (which now covers both tasks' header changes), App.test.tsx and IssueMerge.test.tsx unaffected; prettier, eslint, build green; PR CI green.
assignee: steve
label:
- improvement
priority: medium
task_status: review
tech: null
---
Two layout moves on the incident page (`app/frontend/src/pages/IssueDetailPage.tsx`), both to pull controls out of the vertical panel stack and into lines that already exist.

**1. "Merge into…" moves to the top action row, left of "Ask Assist".**

`<MergeIntoControl issue={issue} />` currently sits in the panel stack between `<MergePanel>` and `<LearningPanel>` (`IssueDetailPage.tsx:1940` on main). Move it into the header `<Group gap="xs" mt="xs" align="center">` that holds Assigned-to, so the row reads:

    Assigned to · AssigneeControl · [Merge into…] · [Ask Assist] · [Work in Claude] · [Raise ticket]

The component renders `<div><Button/><Modal/></div>` and its button is `size="compact-sm"`, so it drops into that Group without restructuring. Check it sits level with the neighbouring buttons — the existing three may not all be `compact-sm`. Its own guards stay as they are: operator role, and hidden for a child or a non-mergeable status, so the row must tolerate it being absent.

**2. The raw-evidence toggle joins the description line, after it.**

Today `<IncidentDescription>` renders on its own, and the evidence toggle lives in a `<div>` much further down, below `LearningPanel`. Put both in one `<Group>` so the toggle follows the "Auto-promoted from a '<kind>' finding…" link on the same line, with the `<Collapse>`/`<EvidenceBlock>` underneath. This also moves the evidence block up the page from where it is now.

Two things to preserve:
- `IncidentDescription` returns a plain `<Text>` when the incident has no signal behind it (a manual incident, or a reaped signal) and an `<Anchor>` + `<SignalDetail>` modal otherwise. Both shapes have to sit in the Group.
- The description wraps (`whiteSpace: 'pre-wrap'`, `ta="left"`) — a long one must still wrap without pushing the toggle off the row. `align="baseline"` and `wrap="wrap"` on the Group.

**Naming note.** Reported as "Show more evidence"; the control actually reads **"Show raw evidence"** / "Hide raw evidence". Same control — there is only one on the page — but worth deciding whether to keep the wording while it moves.

**Watch for a collision.** ISE-688 also edits `IssueDetailPage.tsx` (the `RecallPlaybookRow` region, ~line 1400). Different region from both changes here, so a clean merge is likely, but land this after ISE-688/689 rather than in parallel.

Also relevant to ISE-691, which moves the Impact panel to the top of the same stack — the two together substantially reorder this header, so build them in a known order rather than concurrently.