---
id: 01M177NKCCVN8PXMXQTT6DTMC7
created: 2026-08-29T17:04:25.996443Z
updated: 2026-09-01T13:55:53.493556Z
type: task
title: A read that failed once is not a read that has never worked
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 520
comments:
- id: 01M1BAQVMADGKB1VQ8HNQPFPM2
  author: Steve Vine
  at: 2026-08-31T07:15:03.434048Z
  text: |-
    Implemented on feature/com-520-read-recency.

    Both halves, as the task framed them.

    **Surfacing the pairs.** The Integrations card's Directory mirror panel now lists all five reads under "What the last pass could read" — role eligibility, sign-in activity, authentication methods, applications, conditional access — each with its state and, where it failed, the reason COM-518 wrote. All five always, not only the failing ones: a card listing only failures reads as a card with nothing to say.

    **Three words instead of two.**
    - *Current* (teal) — the last pass read it.
    - *Stale since <time>* (orange) — it worked before, it is not working now. Wait.
    - *Never read* (red, with the reason) — no pass has ever read it. Go and grant something.

    A fourth rendering, deliberately: *Never read* in grey, with no reason, is the tenant whose first pass has not finished. Same words, no urgency, nothing to act on yet.

    **The column.** `last_role_eligibility_read_at`, `last_applications_read_at`, `last_conditional_access_read_at` on `directory_sync_status` (migration 0158), stamped on the success path only — same principle as `sign_in_observed_at`. The two sweeps already had theirs and are read as-is. The endpoint returns all five as one ordered list, so the frontend cannot silently drop one; the generated `key` union makes an added or renamed read a compile error on the label map.

    The backfill sets the new stamp to `last_completed_at` where the read is currently available, and leaves it null where it is not — inventing a time for a read that has never worked would turn "never read" into "stale", which is the confusion this removes. Verified against a populated database, not just CI's fresh one, and the downgrade too.

    No behaviour change to the reads themselves.

    Tests: 5 new backend (a clean pass stamps; never-worked told apart from stopped-working; a failing eligibility read keeps its last-worked time; the endpoint carries all five), 2 new frontend (the grant/blip distinction on the card; a never-run mirror says never read). Full backend and frontend suites green.
- id: 01M1BH39D3NC6TS4C4Z7X0MJYV
  author: Steve Vine
  at: 2026-08-31T09:06:09.443279Z
  text: |-
    Shipped. PR #554, merged to main as 1a83bb3, live on staging as `staging-20260831-0741` and carried forward by `staging-20260831-0831`.

    CI green on every check; full backend suite (383 unit, 1478 integration) and frontend suite (953) green.

    One note for whoever smoke-tests: the first look at this on staging was misleading through no fault of the feature. The mirror sync was failing on every pass — a separate, older defect the card's new "Last sync failed" line made visible — so the five reads showed the migration's backfill rather than live state. That is COM-547, now fixed and deployed; the sync has been completing since 08:45 and the reads move with it.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Follow-up from COM-518, raised there and deliberately left out of it.

Five of the mirror's reads need a grant the rest does not, and each records whether it worked: role eligibility (COM-444), sign-in activity (COM-492), authentication methods (COM-497), applications (COM-498) and conditional access (COM-501). Each is a pair — available, and why not. COM-518 fixed *what the why says*. This is about what the pair cannot say at all.

**Available and unavailable are the only two words there are.** So a Graph blip five minutes ago and a permission nobody has ever consented look identical. Those are opposite instructions to the reader: one is *wait*, the other is *go and grant something*. Telling them apart is the difference between a person doing nothing and a person opening the Azure portal.

**What a first look found, and what it changes.** None of the five pairs reach any screen. `GET /integrations/entra/directory-status` returns the last pass's start, finish, error and four counts — nothing else — so the Integrations card cannot currently say *unavailable* either. Role eligibility's reason is the one exception, carried on role responses. So this is two halves, and the first is larger than "add a column":

- **Surface the pairs.** Each read says on the Integrations card whether the last pass could do it, and why not. Today a tenant that has never consented `Policy.Read.All` shows a green card and an empty conditional access screen, and the sentence COM-518 wrote is in the database where nobody reads it.
- **Then make the pair say three things instead of two.** Never read, read and current, read and stale since a time.

**Two of the five already have the timestamp.** `last_sign_in_sweep_at` and `last_auth_methods_sweep_at` are stamped on the success path only, so for those two *when it last worked* is already recorded and merely unused. Applications, conditional access and role eligibility have no equivalent — that is the column to add, on the same principle as `sign_in_observed_at` (COM-492), which exists so *never signed in* can be told from *not yet read*.

**Why all five together.** Doing it for the two that shipped most recently is what makes the card inconsistent: two rows that can say *stale since 09:15* beside three that can only say *unavailable* is harder to read than five that say the same thing. That is the reason this is its own task rather than the tail of COM-518.

**What the reader should end up seeing.** *Conditional access — stale since 09:15* is a different instruction from *Conditional access — never read*, and both are different from a green card that is silently wrong. The wording is the deliverable as much as the column is.

No behaviour change to the reads themselves: a failed read still leaves the mirrored rows alone, which is already right.
