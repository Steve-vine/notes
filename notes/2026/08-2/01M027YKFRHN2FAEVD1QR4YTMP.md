---
id: 01M027YKFRHN2FAEVD1QR4YTMP
created: 2026-08-15T08:17:27.032157Z
updated: 2026-08-15T17:17:45.620172Z
type: task
title: ISE cannot read a DataDog service check, and an empty metric query looks like proof
project: 01KX671DATY39VW6GWK3M2T3DN
number: 729
sprint: sevhjex
comments:
- id: 01M0303NB5NM129JCGC636BQMF
  author: Steve Vine
  at: 2026-08-15T15:19:38.597232Z
  text: |-
    Done — PR #683, merged to main 2026-08-15. Both gaps, plus the sibling case you flagged.

    **Gap 1 — the missing capability. Two queries, because DataDog's API forced the split.**

    - **`host_status`** is what should have been reached for: is this host reporting, when did it last, is it muted, agent version, which integrations report from it. It is backed by `HostsApi`, which was already wired.
    - **`service_check`** reads a check's state through the monitors that watch it. Worth recording why: DataDog's public API **submits** check runs but does not serve their status back — `ServiceChecksApi` has exactly one method, `submit_service_check`. So a monitor IS the readable form. That limit is stated in the result rather than papered over: "no monitor watches this check" comes back as *ISE CANNOT SEE this check — not that it is failing*, which is the identical mistake one layer up.

    Both catalogue descriptions name the trap explicitly — `host_status` says "do NOT reach for query_metrics with `datadog.agent.up`, which is a service check and not a metric" — so the steer is at the point the model would fall in, not buried in a system prompt.

    **Gap 2 — every emptiness now says which emptiness it is.**

    | Query | Now distinguishes |
    |---|---|
    | `query_metrics` → 0 series | a service check (can never return data here) / not a reporting metric at all / a real metric that was quiet — **only the third is evidence about the estate** |
    | `search_events` → 0 rows | *no events at all in the window* vs *N events, none matching* |
    | `search_logs` → 0 rows | says plainly it cannot tell a quiet service from a filter that cannot match, or from logs not being ingested |

    You were right that the material was already there — `active_metrics` knows which names report. The `search_events` one was free in a way I did not expect: it filters **in ISE**, not in DataDog, so the handler already knew the pre-filter count and the caller could not see it. Two facts behind one zero, separated at no cost.

    All of it lands in the **summary**, per your note, not only the payload.

    One judgement call: the inventory lookup is best-effort. An unavailable inventory is not a fact about the metric, so it falls back to the bare count rather than turning a successful query into an error — a worse answer beats a wrong one, which is the whole theme here.

    **A CI lesson worth carrying:** the first push went red on `backend-lint` for an unused `# type: ignore` in a test. Local ruff and pytest both passed — CI runs bare `uv run mypy`, which covers tests.
assignee: steve
label:
- bug
priority: high
task_status: done
tech: null
---
On IN-1358 the assistant reported that the DataDog agent on `mpwxdc01` was still not reporting. It was wrong, and it corrected itself on a later turn only because the operator probed:

> *"an artifact of probing a service-check metric through the wrong query type, not evidence the agent is actually down"*

**The evidence pull it rested on:**

```
query_metrics — "0 series for avg:datadog.agent.up{host:mpwxdc01}"
```

`datadog.agent.up` is a **service check**, not a metric. Service checks live on a different DataDog API. So the metrics query returned zero series *correctly* — that name is not a metric and never will be — and an empty result was read as a factual negative about a production host.

**Two gaps.**

**1. There is no service-check capability at all.** The DataDog evidence catalogue is `query_metrics`, `search_logs`, `search_events`, `active_metrics`, `synthetics_test`. Grepping the connector for `service_check` / `check_run` finds nothing. `datadog.agent.up` is among the most diagnostically useful signals DataDog carries — it is the "is this host talking to us" check, and the natural first question when a host goes quiet — and ISE cannot read it. The model reached for the closest-looking tool because the right one does not exist; no prompt wording fixes that.

**2. An empty result cannot distinguish two very different facts.** *"This metric exists and had no data in the window"* and *"this is not a metric"* both return **0 series**. The caller cannot tell them apart, so the second reliably reads as the first.

That is the same shape as ISE-685 (a 403 rendered as "install metrics-server"), ISE-651 (58 of 60 alerts where "matches nothing in the estate" meant something else entirely) and ISE-703 (which emptiness). Each time an ambiguous emptiness was reported as a definite negative, and each time it was believed.

**Scope**
- Add a service-check evidence query — read the current status and recent history of a named check for a host/scope, so `datadog.agent.up`, and every other check, is answerable.
- Make `query_metrics` disambiguate its empty result. `active_metrics` already lists what is actually reporting, so the connector can tell whether the requested name is a known metric and answer *"`datadog.agent.up` is not a metric — it may be a service check, try the service-check query"* instead of a bare zero. The material for this is already in the connector.
- Say which in the summary, not only in the payload: the summary string is what reaches the model's context and what an operator reads on the timeline.
- Check the sibling case: `search_logs` and `search_events` returning nothing carry the same ambiguity — no matching records, versus a query that could never match.

**Why it matters more than one wrong answer.** This was specific, plausible and actionable — it named a host, a symptom and a next step. Nothing about it looked like a guess. It survived until a human happened to question it, and the same class of mistake is exactly what ADR 0101's autonomy work must never make unattended: a validated-looking negative drawn from an empty result.

Found on IN-1358, 2026-08-15.