---
id: 01KY516ZQCQFBDVB6D9GT18EC5
created: 2026-07-22T13:46:01.324982Z
updated: 2026-07-24T14:49:02.080601Z
type: task
title: Document claim extraction & lifecycle diffing
project: 01KX671DATY39VW6GWK3M2T3DN
number: 220
sprint: s5khymf
blocked_by:
- 01KY516SB9K4B928SR6GH73CKA
- 01KY5158M01K8TKPQC02NAAVAA
comments:
- id: 01KY5GQVRZZHC57XP4SPYPCFF5
  author: Steve Vine
  at: 2026-07-22T18:17:22.975855Z
  text: |-
    **Done — PR #202** (stacked on #201). Last task of Sprint 20.

    Extraction proposes structured claims (edges, tags) into the queue, each quoting the passage that states it and carrying the document's age — because confirming a two-year-old statement is a different decision from confirming a fresh one.

    The interesting half is the **second** read. Migration 0046 adds `withdrawn` as a fourth proposal status plus `document_id` / `last_stated_at` / `needs_review`, which together turn re-extraction into a diff:

    | the document | the claim | what happens |
    |---|---|---|
    | still says it | any | re-raised; strengthens the existing row |
    | stopped saying it | undecided | **withdrawn** — nobody spent attention on it |
    | stopped saying it | confirmed | graph row stands, proposal **flagged for re-review** |
    | deleted entirely | any | the same rule applied to every claim at once |

    Guards worth flagging:

    - **A failed extraction diffs nothing.** This is the failure mode that would have mattered most — treating "the model was unavailable" as "the document no longer says this" would quietly withdraw the estate's claims on a provider outage. Tested explicitly.
    - **A claim naming something unknown is dropped**, as is an ambiguous name (two entities share it → ISE cannot tell which the page means). Resolution against known entities is what stops a document inventing infrastructure.
    - **A rejected claim its source still makes is stamped but not re-raised** — so the refusal sticks, and the next diff does not mistake it for a withdrawn claim.
    - **A source that starts saying it again clears the re-review** on its own. The question was "does the source still say this?", and the source answering yes is an answer; asking the human as well would be nagging.
    - Confirming a *tag* claim attributes it to the document's own integration — "known by wiki", which is honest provenance. Safe specifically because a Documents-only connector never runs the set-replace refresh of ADR 0037 §2, so nothing will clear it out from under the person who confirmed it.

    **`keep` is the only button on a flagged claim.** The other answer — retracting — means removing the edge or tag the confirmation created, and that belongs on the entity's own screen where the reviewer can see what else the change touches, not behind a one-click button in a queue. Judgement call; say if you'd rather have it inline.

    **UI:** a "Still true?" view on the Proposals queue (with a banner when re-reviews are outstanding), and a Claims drawer per document showing withdrawn and flagged claims alongside live ones — the visible history is the evidence that re-reading works at all.

    Gates: ruff, `mypy` (266 files), 1020 backend tests + 17 new, 335 frontend tests + 5 new, migration check green.
assignee: steve
priority: medium
task_status: done
---
Documents feed proposals, never a parallel truth store (Canon: "The Document Register" — consumed as claims).

- On scrape-detected change (and first registration): AI extraction proposes structured claims — `depends-on`/`routes-to` edges, tags, aliases — into the **proposals queue**, each citing the source passage, provenance = the document.
- **Diff semantics** on re-extraction: claims no longer stated are withdrawn if unconfirmed, or **flagged for re-review** if confirmed (a human signature survives its source, never silently). Page gone → same treatment for all the document's claims.
- Confirmed claims become ordinary graph rows (edges/tags) with document provenance — indistinguishable in traversal, distinguishable in provenance display; the Affects/what-if view shows still-unconfirmed document claims as distinct "unconfirmed" hints.
- Aged documents: extraction confidence and the proposal display carry the document's last-modified, so a reviewer sees they're confirming an old statement.
- Cost posture: extraction runs only on change — no scheduled AI sweep.
- Tests: extraction→proposal with citation; diff withdraw/flag paths; page-gone handling; confirmed-claim survival with re-review flag.