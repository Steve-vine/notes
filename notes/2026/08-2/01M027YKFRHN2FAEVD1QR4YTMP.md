---
id: 01M027YKFRHN2FAEVD1QR4YTMP
created: 2026-08-15T08:17:27.032157Z
updated: 2026-08-15T08:17:27.032157Z
type: task
title: ISE cannot read a DataDog service check, and an empty metric query looks like proof
assignee: steve
task_status: backlog
label: bug
priority: high
project: 01KX671DATY39VW6GWK3M2T3DN
number: 729
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