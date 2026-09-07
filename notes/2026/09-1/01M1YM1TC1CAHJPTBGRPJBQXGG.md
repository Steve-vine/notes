---
id: 01M1YM1TC1CAHJPTBGRPJBQXGG
created: 2026-09-07T19:03:21.21793Z
updated: 2026-09-07T19:03:24.465964Z
type: task
title: Settle the tier vocabulary and what Specialised is allowed to mean
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 604
sprint: sqc2gdq
assignee: steve
label:
- brief
priority: high
task_status: todo
---
The tier names are **Essential**, **Expected**, **Specialised**. That is decided. What isn't decided is whether three tiers is the right number, because the third one is carrying two different ideas.

**The problem**

Some of the third tier is *situational* — privacy, AI governance, card data. It applies or it doesn't, depending on what the company is and what it handles. Some of it is *later* — passive asset discovery, DHCP log correlation for asset records, separating engineering from release duties. That applies to everyone, just not yet.

"Specialised" describes the first honestly and the second badly. A company reading it will conclude that work is not for them, when in fact it's for them next year.

**The three ways out**

1. **Keep three tiers.** Name it Specialised, accept a handful of "later" controls sit under a slightly wrong label. Cheapest; the label lies a little.
2. **Four tiers** — Essential, Expected, Specialised, Advanced. Specialised is about *who you are*, Advanced about *how far along you are*. Honest, but a four-way pill is harder to read at a glance and every screen showing the tier gets busier.
3. **Three tiers plus the company profile.** Specialised controls promote into Essential or Expected when the profile says they apply — personal data, AI in use, card data. What's left in the third tier is then genuinely later, and Advanced becomes its honest name. Cleanest outcome, most work, and it means the tier is no longer a fixed property of the control.

Option 3 is the recommendation, and it's the same profile mechanism already open in the sprint description — so this is one decision, not two. Settle them together.

**Done when**

- The tier count and final names are agreed.
- If the tier becomes per-company, that's written down before anything is built against it — it changes the Core control model and the assessment view, so it likely needs an ADR.
- The words are checked against what's already on screen. "Standard" was rejected for colliding with the **standard** content type; whatever is chosen gets the same check.