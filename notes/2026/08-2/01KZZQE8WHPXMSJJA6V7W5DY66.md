---
id: 01KZZQE8WHPXMSJJA6V7W5DY66
created: 2026-08-14T08:50:25.809641Z
updated: 2026-08-14T08:50:25.809641Z
type: task
title: One section shell for the incident page — fixed title, collapse to a single line, always present
assignee: steve
priority: high
task_status: backlog
label: improvement
project: 01KX671DATY39VW6GWK3M2T3DN
number: 699
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