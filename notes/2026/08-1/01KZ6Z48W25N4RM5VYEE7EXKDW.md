---
id: 01KZ6Z48W25N4RM5VYEE7EXKDW
created: 2026-08-04T18:03:45.922427Z
updated: 2026-08-04T18:03:45.922427Z
type: task
title: Platform Log grouping is defeated by messages carrying unique ids — one problem, six rows
label: improvement
priority: medium
assignee: steve
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 543
---
Found by using ISE-531 on its first day (2026-08-04). Grouping is the Platform Log's whole feature — "×384, first 02:41, last 11:24" is what turns a wall of repeats into "this has been broken since Tuesday". It groups on `(logger, message, level, component)`, which works exactly as intended when the message is a sentence and the detail lives in `extra`:

| logger | rows | groups |
|---|---|---|
| `ISE_api.connectors.cloudflare` | 68 | **2** |
| `ISE_api.connectors.kubernetes` | 6 | **6** |

The Kubernetes connector formats the entire HTTP exception into the message — 795 characters including the response headers, and crucially a per-request `Audit-Id`. Every occurrence is therefore a unique string, so identical failures never collapse. Six today; on a busy cluster it is a fresh row every sweep forever, which is precisely the flat unreadable feed ISE-531 exists to prevent.

ADR 0077 predicted the general problem ("every existing `logger.warning` becomes user-visible… it raises the bar on their wording") but the surface has no defence against a call site that ignores it.

## Two fixes, and they are not alternatives

**1. Fix the call site (the real bug).** `kubernetes.py` should log a short sentence and put the exception detail in `extra`, like the Cloudflare connector already does (`extra={"why": str(exc)}`). That is the house pattern, it is what the row-detail panel renders, and it is why Cloudflare's 68 rows collapse to 2. Worth a sweep for other offenders — anything doing `logger.warning(f"...: {exc}")` where the exception embeds ids, timestamps or counts.

**2. Make the surface resilient anyway**, because a future call site will do this again and the screen should degrade gracefully rather than silently stop grouping. Options to settle in plan mode:
   - Group on a **normalised** message: collapse long-form detail by truncating at the first newline (the k8s message is one line of prose followed by a dumped HTTP response), which is cheap, honest and reversible.
   - Or group on `(logger, level, component)` plus a bounded message prefix.
   - Prefer whichever keeps a genuinely-distinct message distinct — over-collapsing would hide two different problems under one row, which is a worse failure than under-collapsing.

Whatever is chosen, the group's displayed message must remain something an operator can read and search for.

## Not in scope

Fingerprinting by exception type or stack, or anything resembling a full log-aggregation heuristic. The table is WARNING+ only and pruned to a fortnight (ADR 0077 §2/§6); the cheapest rule that fixes the observed failure is the right size.

## Acceptance

The six identical Kubernetes 403s appear as **one** grouped row with a count, and the Cloudflare grouping is unchanged. A test seeds records whose messages differ only in an embedded id and asserts they collapse.

Related: [[ISE-542]] is the underlying 403 those six rows are reporting. Fixing that removes today's example but not the defect.
