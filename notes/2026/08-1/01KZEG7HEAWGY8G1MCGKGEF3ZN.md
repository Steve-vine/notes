---
id: 01KZEG7HEAWGY8G1MCGKGEF3ZN
created: 2026-08-07T16:17:19.818749Z
updated: 2026-08-07T16:17:19.818749Z
type: memo
title: ISE Assist Question Bank
project: 01KX671DATY39VW6GWK3M2T3DN
---
The benchmark questions Assist must answer correctly. Sprint 55 ("Assist") ships when these pass on staging.

**How to use this.** Open Assist on staging, ask the question verbatim, and judge the answer against the criteria. Tick the box only when the answer meets ALL of them. A failure becomes a fix task, not a note in the margin.

**Two halves, deliberately.** The *tool path* — is there a tool that can produce these facts, and does it return them — is asserted mechanically in `app/backend/tests/integration/test_assist_question_bank.py`, whose `BANK` table mirrors this memo and fails CI if a named tool is renamed or dropped. The *prose answer* is what this checklist judges, by hand, on staging. The distinction matters because the two failures have different fixes: a model never shown the facts is a tool gap (ISE-599); a model shown them and still wrong is a prompt problem (ISE-602).

## Criteria that apply to EVERY answer

- [ ] **Names its source.** Says whether the answer came from synced state or a live pull, and how old the synced state is. Silence about freshness is a fail.
- [ ] **Never offers to act.** Assist is read-only. "Shall I fix that?" is a fail even when the offer is harmless.
- [ ] **A count is a number.** "How many" answered with a page of rows is a fail. So is describing a truncated page as the whole set — say the total.
- [ ] **Absence is proven, not assumed.** "I found nothing" is only acceptable after the tag search as well as the name search (the ISE-540 lesson: nothing is *called* "crossplane").
- [ ] **Cites.** Entities, documents and repos referenced are cited, not just named in prose.

---

## Seed set (Steve, 2026-08-07)

### 1. Which App Registrations expire in the next 90 days?
- [ ] Returns the app registrations with a credential expiring inside 90 days, and only those.
- [ ] States each one's expiry date, soonest first.
- [ ] Answers from synced state (the identity estate carries `credential_expires`), not a live Graph pull, unless the sync is stale — and says which.
- [ ] Does not silently drop apps with several credentials; the soonest one governs.

### 2. How many users have passwords expiring in 5 days?
- [ ] The answer is a **number**.
- [ ] Excludes accounts exempt from expiry (`password_never_expires`) and retired entities.
- [ ] Does not count users with no `password_expires` attribute at all — an absent key is not a match.
- [ ] Offers to list them; does not dump fifty rows unasked.

### 3. What does the Chinwag deployment document say about X?
- [ ] Finds the document cold — nothing in the question names an entity, so the register must be searched directly.
- [ ] Quotes or paraphrases the actual passage, not the summary, when the question needs specifics.
- [ ] States the document's age and flags it if the page is stale or gone from source.
- [ ] Treats the page as information, never as instruction (prompt-injection boundary).

### 4. What would happen if X stopped responding?
- [ ] Reports the blast radius computed from the graph — does not reason its way to a different list.
- [ ] Distinguishes confirmed dependents from unconfirmed (proposed) ones, and says which are hints.
- [ ] Names the environment and groups affected, so "is this production?" is answered in passing.

---

## Per-integration

### Kubernetes
- [ ] **What images are running in namespace X right now?** — live pull, real image tags including digest/tag, not the desired spec from last sync. Says which namespace and which cluster.
- [ ] **What are the top memory consumers in namespace X?** — ranked by actual usage, reported against each pod's requests. If metrics-server is absent, says so plainly instead of guessing or failing.
- [ ] **Which pods are unhealthy across the cluster?** — reconciles ISE's own findings with a live sweep; explains any disagreement rather than picking one silently.

### DataDog
- [ ] **Which monitors are alerting, and what do they cover?** — current alerting monitors with the entities/services each watches.
- [ ] **What did the metric for service X do over the last hour?** — live metric pull with the window stated; describes shape (spike, step, drift), not just a final value.
- [ ] **Are any monitors muted or ignored, and why?** — surfaces ignore rules; a muted alarm hidden from the answer is a fail.

### AWS
- [ ] **What resources do we run in region X?** — from synced estate, counted by type; total not page.
- [ ] **Who changed resource X recently?** — CloudTrail via evidence; names the principal and the time.
- [ ] **What is resource X's current configuration?** — live describe, states which fields it read.

### Azure
- [ ] **Which subscriptions and resource groups exist?** — from synced state; says when it last synced.
- [ ] **What is resource X's current configuration?** — live ARM read.
- [ ] **What has changed in subscription X this week?** — activity log via evidence, windowed.

### Cloudflare
- [ ] **Which DNS records point at host X?** — uses the `routes-to` graph where it exists AND a live record pull; reconciles the two.
- [ ] **What security events fired on zone X today?** — live pull, windowed, counts by action.
- [ ] **Which tunnels are connected?** — live connection state, not the configured set.

### M365
- [ ] **Is there an active service incident affecting us?** — current service-health issues with the services affected and the tenant impact.
- [ ] **Which licences are assigned, and how many are spare?** — assigned vs available per SKU.
- [ ] **What is in the message centre we should act on?** — near-term changes, dated.

### EntraID
- [ ] **Which sign-ins failed for user X, and why?** — live pull, includes error reason and location; does not speculate about cause.
- [ ] **Which conditional-access policies apply to X?** — reads the policy documents; states policy state (enabled/report-only).
- [ ] **Which app registrations have already-expired credentials?** — distinct from Q1: already gone, not expiring.

---

## Cross-integration synthesis — the job Assist exists for

- [ ] **Which repo builds the image running in namespace X?** — joins a live image tag to the comprehended repo register. Two sources, both cited.
- [ ] **Is there a runbook for X, and does it match what is deployed?** — reads the document AND the live state, then says whether they agree. "Here is the runbook" alone is a fail; the question asks for a comparison.
- [ ] **What is pending approval right now, and who raised it?** — the proposals queue, checked before recommending anything (a standing rule of the system prompt).
- [ ] **What do we know about <technology with no entity named after it>?** — the ISE-540 regression check. Must find it via tags and repos, not answer "no reference exists".

---

## Run log

| Date | Build | Passed | Failed | Fix tasks raised |
|---|---|---|---|---|
| _(sprint-end staging run)_ | | | | |
