---
id: 01M1FEX79KS3AEFJV990NY8FZK
created: 2026-09-01T21:44:51.251439Z
updated: 2026-09-01T21:44:51.251439Z
type: task
title: Why this signal did not escalate
priority: medium
task_status: backlog
assignee: steve
label: feature
project: 01KX671DATY39VW6GWK3M2T3DN
number: 767
tech: null
---
ADR 0107 says a signal that is not escalated is **retained and inspectable**, not discarded. This is the screen that makes that true.

An operator needs to be able to ask of any Alert or Observation: why is there no incident for this? And get an answer naming the rule, the business service, or the definition that decided it — not a shrug.

**The trap to avoid.** `signal_decision.py` already does a version of this for the current pipeline, and it works by **re-deriving the decision at read time from current config**, with its own docstring warning that it must mirror `promote_findings` exactly or it is "worse than none". That means it explains what *would* happen now, not what *did* happen then: clear an override and every past signal silently re-explains itself.

The Correlator should therefore **record its decision** as it makes it — which rule fired, against which definition, at what time — so this screen reads a record rather than recomputing a guess. Doing it this way also removes the drift risk in the existing projection.

**Blocked by** the Correlator.