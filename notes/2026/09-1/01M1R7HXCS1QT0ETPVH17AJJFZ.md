---
id: 01M1R7HXCS1QT0ETPVH17AJJFZ
created: 2026-09-05T07:29:30.521321Z
updated: 2026-09-05T17:40:45.229924Z
type: task
title: Every firing 'No Data' synthetic is a paused test, and ISE has the tag that says so
project: 01KX671DATY39VW6GWK3M2T3DN
number: 785
sprint: s7nj09w
comments:
- id: 01M1RZZ5GYD43R2C1TMEADFAY8
  author: Steve Vine
  at: 2026-09-05T14:36:10.654719Z
  text: |-
    Done — PR #727 merged to main (2026-09-05).

    - A synthetics-alert monitor in `No Data` whose tags carry `check_status:paused` is emitted as an **Observation** of kind `synthetics_paused` (confidence 0.9) on the SAME source key, so the row flips between Alert and Observation as the test is paused and resumed — no second signal. Title keeps the source's wording (ADR 0103); the rule reads `check_status` only. `details` gains `check_status: paused` and a reason: "a monitoring gap, not an outage".
    - Mechanism it needed: a connector can declare `detect_observation_kinds()`. The alert poll reconciles and stamps each such kind under its own sweep scope on every pass, so its absence recovers it (kind-scoped stamps already existed for estate drift; this generalises the door). Undeclared observation kinds from `detect()` are dropped with a Platform Log warning.
    - Broader question in the task (source stopped looking — Status Page checks, K8s probes, disabled monitors) is NOT addressed here; this is the DataDog synthetic instance only.
    - On staging the 6 firing "No Data" rows will flip to observations on the next DataDog sync; ISE-787's migration then closes the 4 per-location ones.
assignee: steve
label:
- bug
priority: medium
task_status: done
tech: null
---
Found while investigating ISE-784. The split is total, with no overlap:

```
state     check_status          finding status   count
Alert     check_status:live     resolved            23
Alert     check_status:live     recovered            9
No Data   check_status:paused   triggered            6
No Data   check_status:paused   resolved             2
```

Every `Alert` comes from a live check. Every `No Data` comes from a **paused**
one. So all 6 currently-firing "No Data" synthetic signals mean *"somebody
switched this test off"*, not *"the service is unreachable"* — and ISE is
carrying them as open signals with a `low` severity that reads as a real, if
minor, fault.

**ISE already has the fact.** `check_status:paused` arrives in the finding's
`details.tags` on every one of them. Nothing reads it.

This matters more once ISE-782 lands: attribute these to a Business Application
by `ise-ba:` tag and six meaningless signals start being priced against it.

**Proposed**

- Read `check_status` on a synthetics alert. A `No Data` from a `paused` check is
  not a fault — suppress it, or carry it as an Observation saying the test is
  paused, which is a genuinely useful thing to know about a Business Application
  claiming to be monitored.
- Prefer the Observation over silent suppression. A paused synthetic on a
  critical application is a **monitoring gap**: ISE-765 already raises an
  Observation for an ungraded application on the same reasoning — an absence of
  assessment is a finding, not a blank.
- Do not special-case the title text. The rule is about `check_status`, and the
  titles ("… is No Data") are the source's wording, which ADR 0103 says ISE keeps.

Broader question worth asking once: a paused check is one instance of "the
source has stopped looking". Status Page checks, Kubernetes probes and DataDog
monitors can all be disabled at source while ISE keeps reporting on the estate
as if it were watched. ISE-750 established that a disabled integration must not
report health it has not checked; this is the same principle one level down.
