---
id: 01KZZQE8WHPXMSJJA6V7W5DY66
created: 2026-08-14T08:50:25.809641Z
updated: 2026-08-14T09:39:39.514203Z
type: task
title: One section shell for the incident page — fixed title, collapse to a single line, always present
project: 01KX671DATY39VW6GWK3M2T3DN
number: 699
sprint: sevhjex
comments:
- id: 01KZZR63D2PME82SY4SN1MFEXE
  author: Steve Vine
  at: 2026-08-14T09:03:26.626057Z
  text: |-
    DECIDED 2026-08-14 — the three open questions are settled.

    1. EMPTY VS NOT APPLICABLE — always show. Every section renders on every incident, including a manual one where history and playbook matching can never produce anything. Steve: "Keep the boxes on screen when there's no data, I want it to be implicitly implied that there isn't any data." So there is no third "not applicable" state; the box is present and empty, and its presence is what tells the operator the answer is nothing rather than unknown.

    2. THE OTHER PANELS ARE IN, NOT DEFERRED.
       - ChildPanel + ChildrenPanel: NOT separate sections — they fold into Related incidents (ISE-702).
       - LearningPanel: adopts the shell like the rest — own title, own colour, own collapse.

    3. COLOURS — one per section, each UNIQUE, fixed regardless of state. Impact takes the yellow it currently shows only in its unlinked state.

    COLOUR COLLISION TO RESOLVE. Verified on origin/main @ 75c57f6, the current allocation does not survive that rule:
      - Impact          plain Card when attached / yellow when unlinked  → becomes YELLOW, fixed
      - History         blue (shared with Playbooks today)               → needs its own
      - Playbooks       blue (shared with History today)                 → needs its own
      - Related         grape (MergePanel); ChildPanel also grape;
                        ChildrenPanel plain                              → grape, and the merged section unifies all three
      - Learning        yellow (IssueDetailPage LearningPanel)           → CLASHES with Impact, must move
    So this task owns the full allocation: five sections, five distinct colours, decided once and written down rather than each task picking its own.

    Also worth knowing while allocating: LearningPanel is doubly gated — `if (!terminal || !proposal) return null` — so it only appears on a resolved/closed incident that also produced a learning proposal. Steve has never seen it. Under decision 1 it now renders on every incident, which is a real visibility change for a panel nobody has laid eyes on; see ISE-703 for reviewing what it should say.
- id: 01KZZT8DBTZBNARQFSTWAETK11
  author: Steve Vine
  at: 2026-08-14T09:39:39.514066Z
  text: |-
    BUILT + MERGED 2026-08-14 — PR #648 (squashed to main as 9108e28), CI green.

    WHAT SHIPPED. `app/frontend/src/components/IncidentSection.tsx` — the shared shell, lifted from the shape ISE-691 already built for Impact rather than invented:
    - fixed title (`Title order={4}`), collapse chevron top-right with an aria-label;
    - ALWAYS renders, empty or not, per your decision 1;
    - collapsed = title + one key fact, or `No data` when empty (and an empty section starts collapsed);
    - children UNMOUNT when closed, never height-animated — a Mantine `Collapse` keeps them mounted and still answers every query inside (the ISE-683 trap);
    - `data-testid="section-<id>"` and a DOM `id` per section, so the `#learning` deep-link keeps working.

    COLOUR ALLOCATION, decided once and written down (your decision 3 — each unique, fixed regardless of state). It lives in one exported map in `IncidentSection.tsx`, not in five panels:
      impact → YELLOW      (was: plain card attached / yellow unlinked)
      history → BLUE       (keeps the blue it shared)
      playbooks → TEAL     (blue could only go to one of them)
      related → GRAPE      (unchanged; ChildPanel's grape folds in at ISE-702)
      learning → GREEN     (moved off Impact's yellow)
    Hues are deliberately spread: adjacent Mantine shades (blue/indigo, grape/violet, yellow/orange) are not tellable apart as pale card washes. A test asserts the five are distinct, so re-using one reddens CI rather than shipping.

    COLLAPSE PERSISTENCE — the question you left open: per SECTION, across incidents, in localStorage. Per-incident would make an operator working twenty incidents in a shift fold the same section away twenty times, and the preference being expressed ("I don't use Playbooks") is about the section, not about IN-1341.

    ONE TRAP WORTH KNOWING, found by the existing merge test going red. Every section fills from a query, so the FIRST render always looks empty. Seeding the open/closed state from that render left the merge candidates fetched, rendered into a closed box, and never seen. The default is now resolved at render time and only the operator's explicit choice is stored. There is a test for exactly that shape.

    APPLIED TO Related incidents here (the simplest consumer, which proves the shell): it no longer returns null when there is nothing — it says so. Its collapsed line reads "N possible duplicates", or "none proposed · N put away" when everything was dismissed; deliberately NOT the "N judged unrelated" wording the show/hide control inside uses, since the collapsed line and the control reading identically makes them one thing.

    Convention recorded in `docs/briefs/ui-brief.md` (screen 3, Issue detail) as a fourth zone, so the next section built follows it without reading this ticket.

    Follow-ons now unblocked and in progress: ISE-700, ISE-701, ISE-702, ISE-703.
assignee: steve
label:
- improvement
priority: high
task_status: active
tech: null
---
The four sections at the top of an incident follow no common convention, and the page reads as messy because of it. Reported from staging 2026-08-14.

**What is actually there today** (verified against `origin/main` @ 75c57f6):

| Section | Component | Card | Title | When empty |
|---|---|---|---|---|
| Impact | `IncidentEntityPanel` → `AttachedEntityPanel`/`UnlinkedEntityPanel` (`IssueDetailPage.tsx:1667`) | plain `Card withBorder` when attached, **yellow** when not | `Title order={4}` "Impact" — only in the attached branch | swaps to a different panel |
| History + Playbooks | `RecallPanel` (`IssueDetailPage.tsx:1790`) | **blue** | `Text fw={600} size="sm"`, dual: "Seen N times before" *or* "ISE has a playbook for this" | one dimmed line, or `return null` with no signal |
| Related incidents | `MergePanel` (`MergePanel.tsx:123`) | **grape** | `Text fw={600} size="sm"` "Looks related to N other incidents" | `return null` (line 120) |

So: three heading treatments, a title that changes identity with the data, two sections that vanish entirely, and only one with a collapse.

**ISE-691 already built the pattern — this extracts it.** `ImpactPanel` has the target shape: a real `<Title order={4}>` (line 309) and a collapse chevron top-right with an `aria-label` (lines 332-335), rendering children only when open rather than height-animating them (see the comment at line 339). This task lifts that into a shared shell and applies it, rather than inventing a convention.

**Scope**
- A shared section component: **fixed title always shown**, collapse control in the top-right, and a collapsed state that is a **single line — title plus one key fact**.
- Every section **renders on every incident**, present or empty. Empty collapses to one line reading `Title (No data)`.
- One colour per section, **fixed regardless of state**. Per-section colours stay as they are (they are fine); what must go is a section changing colour with its contents, which Impact does today.
- Apply it to **Related incidents** in this task — the simplest consumer, which proves the shell. Impact and History/Playbooks adopt it in their own tasks (they need structural work first).
- Collapse state should persist per section across a page visit; decide whether it persists across incidents.

**Define the collapsed one-liner per section** — "key information" is the whole value of the collapsed state and is different each time. Suggested: Impact → the subject entity and how many things it affects; History → how many prior incidents; Playbooks → how many match; Related → how many candidates. Get these agreed before building, or the collapsed page says nothing useful.

**Decide: empty vs not applicable.** `RecallPanel` returns null when the incident has no signal at all (a manual incident) — there is no history or playbook matching to be had, ever, not merely none today. Rendering two permanently-empty boxes on every manual incident may be worse than omitting them. Either "(No data)" covers both, or a third state says "not applicable to a manual incident".

**Three more panels share this stack** and were not in the report: `ChildPanel`, `ChildrenPanel` and `LearningPanel` (`IssueDetailPage.tsx:2242-2246`). Leaving them on the old convention re-creates the inconsistency one row further down. Decide whether they adopt the shell now or are explicitly deferred.

Follow-ons: ISE-700 (Impact becomes one box), ISE-701 (History and Playbooks split).