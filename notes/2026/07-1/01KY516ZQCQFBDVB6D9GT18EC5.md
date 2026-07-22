---
id: 01KY516ZQCQFBDVB6D9GT18EC5
created: 2026-07-22T13:46:01.324982Z
updated: 2026-07-22T18:01:34.322191Z
type: task
title: Document claim extraction & lifecycle diffing
project: 01KX671DATY39VW6GWK3M2T3DN
number: 220
sprint: s5khymf
blocked_by:
- 01KY516SB9K4B928SR6GH73CKA
- 01KY5158M01K8TKPQC02NAAVAA
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Documents feed proposals, never a parallel truth store (Canon: "The Document Register" — consumed as claims).

- On scrape-detected change (and first registration): AI extraction proposes structured claims — `depends-on`/`routes-to` edges, tags, aliases — into the **proposals queue**, each citing the source passage, provenance = the document.
- **Diff semantics** on re-extraction: claims no longer stated are withdrawn if unconfirmed, or **flagged for re-review** if confirmed (a human signature survives its source, never silently). Page gone → same treatment for all the document's claims.
- Confirmed claims become ordinary graph rows (edges/tags) with document provenance — indistinguishable in traversal, distinguishable in provenance display; the Affects/what-if view shows still-unconfirmed document claims as distinct "unconfirmed" hints.
- Aged documents: extraction confidence and the proposal display carry the document's last-modified, so a reviewer sees they're confirming an old statement.
- Cost posture: extraction runs only on change — no scheduled AI sweep.
- Tests: extraction→proposal with citation; diff withdraw/flag paths; page-gone handling; confirmed-claim survival with re-review flag.