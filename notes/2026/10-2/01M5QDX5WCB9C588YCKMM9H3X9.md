---
id: 01M5QDX5WCB9C588YCKMM9H3X9
created: 2026-10-24T17:04:03.980147Z
updated: 2026-10-25T09:44:13.875051Z
type: task
title: 'DDQ: a person answering from what they know isn''t asked for sources — they say who it can go to instead'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1289
sprint: ssgnel8
comments:
- id: 01M5QV9EJ45VT1NJBKP2ME9YHK
  author: Steve Vine
  at: 2026-10-24T20:57:57.571875Z
  text: |-
    **Done: PR #1307, merged to main.** Goes to staging with the rest of sprint 86.

    **What you'll see**
    - **The answer window asks "Who can this go to?"** right after the answer. It lists the company's levels with what each means for a questionnaire, e.g. "Public — can go to any client", "Sensitive — only to a client under NDA", "Internal — never goes to a client".
    - **With no source, there's nothing to follow,** so a level must be chosen before **Save answer** works: "Say who this answer can go to." There's no default.
    - **Sources and evidence** sit behind **"Based on something in Compass? Add a source"**. The section is already open on an answer that has some.
    - **An approver** reviewing such an answer sees "From Steve Vine — no source in Compass".
    - **An assignee** can't submit an answer with no source until they've chosen a level (422).

    **Calls awaiting Steve**
    1. **No default:** the question is required.
    2. **Sources are tucked away,** not removed.
    3. **The level labels** are the sensitivity scale's names plus a plain gloss of the questionnaire rule.
assignee: steve
priority: medium
task_status: done
---
## What Steve said

Answering an assigned DDQ-3 question: "I also have the sources dropdown to select where the answer came from but the reason it came to me would be because the answer doesn't exist in any of these, this feels superfluous."

## Why it matters, not just tidiness

Today the sources are the only way Compass learns **who an answer can go to**. An answer with no sources and no classification chosen counts as *not classified*, so it's treated as Internal. With no NDA it is **held back** ("Not classified") and can't be approved. So a person who answers from what they know and skips the sources box, which is the natural thing to do, silently produces an answer that won't go out.

## Behaviour

- When a person answers, on the DDQ page or as an assignee, the form leads with the answer and one plain question: **"Who can this go to?"** The choices are the company's sensitivity levels in plain words (for example "Anyone, public", "Clients under NDA", "Internal only, keep it out").
  - It's required before Save as finished / Submit, and has no default. Nothing goes out as Public unless someone said so, and nothing is held back without anyone noticing.
- **Sources move behind "Based on something in Compass? Add a source"**, collapsed. Adding one works as now: the classification follows the source unless the person lowers it with a reason.
- An answer with no sources says so to the reviewer: **"From Steve Vine — no source in Compass"**. The approver sees the person's word is the only basis.
- **Polaris is unchanged.** It always cites what it used (COM-1281), and an answer Polaris drafts arrives with its sources filled in.
- **Next time:** an answer that came from someone's head is exactly what the Q&A library is for. At approval it's offered to the library as now, so the next questionnaire has a source.

## My calls (awaiting Steve)

- The "who can this go to" question is required, with no default.
- Sources are tucked away, not removed: a person can still cite a policy or a control.
- The labels come from the company's sensitivity scale names, with a short plain gloss of what each means for a DDQ.

## Implementation notes

- Independent of the chain if done in the frontend only. The API already accepts `classification_rank` chosen by hand with no sources, and `check_classification` needs no reason when there's no default. Confirm that, and add a server-side rule only if "required" must hold for the assistant/API too. Prefer it in the API: a submit (`ddq_assignments.submit`) or an owner "finished" save with no sources and no chosen classification → 422 "Say who this can go to". That puts it on the chain.
- Answer window (DDQ page drawer + assignee page): reorder, a collapsed sources section, a classification select with labels from the sensitivity scale + DDQ sharing rule gloss.
- Read model: `basis: "sources" | "person"` (derived: no sources), shown in the review list and in `ddq_get_question`.
- Coordinate with COM-1280 (fields under the client's labels) and COM-1287 (assignee page = DDQ page form).
