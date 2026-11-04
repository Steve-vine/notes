---
id: 01M6EWDZBBMA9RQJMBCKBNQ333
created: 2026-11-02T19:40:26.347698Z
updated: 2026-11-04T19:50:53.389741Z
type: task
title: Compass knows our company's legal details — Polaris fills our party clause from them and points out when our standard contract or the client's draft states them differently
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1528
sprint: sm2a4gc
comments:
- id: 01M6KZ1WYANR96H2T3ZV308R8R
  author: Steve Vine
  at: 2026-11-04T19:02:28.554833Z
  text: |-
    Done — PR #1600, merged to main (dce32796).

    What changes:
    - Each company now has legal details: registered name, trading name, where it's registered, company number and registered office. An administrator records them on Admin ▸ Companies ▸ Edit, under "Legal details". The company number keeps its leading zero, and clearing a box removes that detail.
    - When Polaris reviews a contract, it's given these details and told to use them, never the standard contract's or the draft's copy, for any wording that names us as a party.
    - Compass itself spots where our standard contracts, or the client's draft, give our company number or postcode differently, and hands that to Polaris to mention in the comment. For example: "Our Mutual NDA (Corporate) v1, clause 1 gives company number 3894972; Compass holds 03894972" and "…gives postcode LL13 7YT; Compass holds LL13 7ZB". It only looks at text that names us, so the client's own number and address aren't compared.
    - With no legal details recorded, Polaris is told not to guess and to flag the party clause "Can't tell", saying the company's legal details need recording.
    - The privacy contact under Data Privacy settings is unchanged. It's a different thing from legal identity.

    Tests: legal details are recorded, edited and cleared, and only administrators can do it. The review context gives the details and both differences for a standard NDA with the old number and postcode. With none recorded, it gives the Can't tell instruction. The Edit company form shows and saves them. Unit suite green.

    To check on staging: record Test Company's legal details (Callitech Limited, Moneypenny, England and Wales, 03894972, Moneypenny, Western Gateway, Wrexham, LL13 7ZB), then re-review CR-3's party clause. It should suggest 03894972 and LL13 7ZB, with a comment noting the standard NDA's different number and postcode. Polaris's wording needs its AI provider, so that part is yours to see.

    Still not code: upload a corrected Mutual NDA (Corporate) so the old details stop spreading.
assignee: steve
label:
- bug
priority: high
task_status: done
---
Contract Review - Updates. Found by Steve testing Contract Review (ADR 0134) on staging, 2026-11-02, on CR-3 PEGO NDA (Test Company). **On the chain**: adds a migration (new company details) and changes the API.

## What happened

The client's NDA left our party clause blank: *"("Insert client name") incorporated and registered in with company number whose registered office is at ("Party 2")"*. Polaris flagged it "Differs from our standard contract" and suggested:

> CALLITECH LIMITED (trading as Moneypenny), incorporated and registered in England and Wales with company number **3894972** whose registered office is Moneypenny, Western Gateway, Wrexham **LL13 7YT** ("Party 2");

The correct details, as Steve finalised them:

> Callitech Limited … incorporated and registered in England and Wales with company number **03894972** whose registered office is at Moneypenny, Western Gateway, Wrexham, **LL13 7ZB** ("Party 2");

Polaris copied our own standard Mutual NDA (Corporate) v1 word for word. Its Parties (1) has the company number without its leading zero and an old postcode. Compass holds nothing else about who we legally are, so Polaris had no way to check it. The wrong details would have gone back to the client as our suggested wording.

## What people should see

- An administrator records each company's legal details once, with the company's other settings: registered name, trading name, where it's registered, company number and registered office address.
- When a clause names us as a party, Polaris's suggested wording uses those details, not the standard contract's.
- If our standard contract or the client's draft states our name, number or registered office differently from what Compass holds, Polaris says so in the clause's comment, e.g. "Our standard NDA gives company number 3894972; Compass holds 03894972".
- If no legal details are recorded, Polaris doesn't guess. The party clause is flagged "can't tell", saying the company's legal details need recording.

## Approach (for the PR)

- Company legal identity fields on the company (migration + company settings API/screen). Decide in the PR whether the DSR "company details" settings should read from them too.
- Add them to what `contracts_review_context` gives Polaris (once per page, not per clause, see COM-1527), and update the review instructions: party/identity wording comes from the company's legal details. Compare against the standard clause and the draft; never copy identity details from either.
- Company number is stored as text (keeps leading zeros).

## Done when

- Test Company's legal details can be recorded and edited on screen. Re-reviewing CR-3's party clause suggests 03894972 and LL13 7ZB, and the comment notes the standard NDA's different number and postcode.
- With no legal details recorded, the party clause comes back "can't tell" with that reason.
- Test: suggested party wording comes from the company's legal details even when the standard contract's clause says something else.

## Not code

Our standard Mutual NDA (Corporate) itself carries the old number and postcode. Upload a corrected version so it stops spreading.