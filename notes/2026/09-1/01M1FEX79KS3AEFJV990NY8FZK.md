---
id: 01M1FEX79KS3AEFJV990NY8FZK
created: 2026-09-01T21:44:51.251439Z
updated: 2026-09-04T16:51:29.590389Z
type: task
title: Why this signal did not escalate
project: 01KX671DATY39VW6GWK3M2T3DN
number: 767
sprint: s7nj09w
comments:
- id: 01M1MHTZG730GT3J16HQ1ZYNHF
  author: Steve Vine
  at: 2026-09-03T21:12:15.622969Z
  text: |-
    Built — PR #710 (feature/ise-767-why-no-escalation). No migration; it reads the `signal_decision` table ISE-764 added.

    IT READS A RECORD, NOT A RE-DERIVATION — which was the whole task
    The trap the task named, avoided by construction: `signal_decision.py` recomputes from CURRENT config, with its own docstring warning that it must mirror the promotion path exactly or it is "worse than none". So it explains what WOULD happen now, not what DID happen then — clear an override and every past signal silently re-explains itself. The Correlator records its decision as it makes it, and this reads that. There is a test that moves the definition afterwards and asserts the answer does not.

    FOUR ANSWERS, because each is a different next action
    - **graded** — the capability is carrying it, or it is below the impairment bar. Nothing to do; the system is working.
    - **unassessed** — nobody has described this member. The cure sits next to the answer.
    - **uncovered / unsubjected** — the coverage gap, split into the two halves that need different fixes: define the Business Application, or tell ISE what the signal is about.
    - **muted** — somebody downgraded, silenced, ignored or suppressed it. A fact about ISE's CONFIGURATION, said as one — the ISE-635 distinction, kept.

    WHERE THERE IS NO RECORD, THE PROJECTION IS SHOWN AND LABELLED AS ONE
    A signal between two Differ passes has not been judged yet. "ISE decided this" and "ISE would decide this" are different claims and must not render as the same one. The old alert survives only for the override case, which names its own row and scope — detail the decision record deliberately does not carry — so the modal never says the same thing twice in two voices.

    The decision NAMES the definition it was judged against and links to it ("against what?" and "where do I change it?" are the next two questions), and it is DATED — a record is only a record if it is.

    On the row, only the coverage gap is badged. `graded` is the system working, and a badge on every quiet row is how the one that matters gets missed.
assignee: steve
label:
- feature
priority: medium
task_status: done
tech: null
---
ADR 0107 says a signal that is not escalated is **retained and inspectable**, not discarded. This is the screen that makes that true.

An operator needs to be able to ask of any Alert or Observation: why is there no incident for this? And get an answer naming the rule, the business service, or the definition that decided it — not a shrug.

**Three answers it must be able to give (ADR 0109):**
- *Graded* — the affected member is named in a capability, and the capability is still healthy because another provider is carrying it.
- *Unassessed* — nobody has described what this member does, so ISE has no basis to judge it. The cure sits next to the answer: describe the thing.
- *Muted* — someone downgraded, silenced, ignored or suppressed it. A fact about ISE's configuration, said as one.

**The trap to avoid.** `signal_decision.py` already does a version of this for the current pipeline, and it works by **re-deriving the decision at read time from current config**, with its own docstring warning that it must mirror `promote_findings` exactly or it is "worse than none". That means it explains what *would* happen now, not what *did* happen then: clear an override and every past signal silently re-explains itself.

The Correlator should therefore **record its decision** as it makes it — which rule fired, against which definition, at what time — so this screen reads a record rather than recomputing a guess. Doing it this way also removes the drift risk in the existing projection.

**Blocked by** the Correlator.