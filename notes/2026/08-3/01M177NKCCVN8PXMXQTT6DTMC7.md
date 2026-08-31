---
id: 01M177NKCCVN8PXMXQTT6DTMC7
created: 2026-08-29T17:04:25.996443Z
updated: 2026-08-31T06:51:54.739568Z
type: task
title: A read that failed once is not a read that has never worked
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 520
assignee: steve
company: null
label: improvement
priority: medium
task_status: todo
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
