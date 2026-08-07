---
id: 01KZ6Z48W25N4RM5VYEE7EXKDW
created: 2026-08-04T18:03:45.922427Z
updated: 2026-08-07T11:55:27.135493Z
type: task
title: Platform Log grouping is defeated by messages carrying unique ids — one problem, six rows
project: 01KX671DATY39VW6GWK3M2T3DN
number: 543
sprint: skxht3g
comments:
- id: 01KZ7BE0KD1EE0QH7RSAPAPPC4
  author: Steve Vine
  at: 2026-08-04T21:38:48.045568Z
  text: |-
    Built — PR #462. PR CI green. No migration.

    Both fixes, as you said they were not alternatives.

    **1. The call sites.** Broader than just `kubernetes.py`: the sweep found **seventeen** `logger.warning` calls interpolating a caught exception into the message, two of which also carried a UUID and a retry count. All now use the house pattern `extra={"why": str(exc)}`. The dividing line I applied throughout — things that identify the PROBLEM stay in the message (system name, degraded source, channel name); things that vary per OCCURRENCE move to `extra` (the exception, a delivery id, an attempt number).

    The sweep is now a **test**, not a one-off read: a static AST check in `test_logging.py` that no WARNING+ log call renders an exception into its message. That catches the next one at CI rather than on the screen, which felt more useful than fixing today's list and moving on.

    **2. The surface.** Group key normalised to the message's first line. I went with that over a bounded prefix for exactly the reason you gave — a prefix could merge two genuinely different one-line messages, and over-collapsing hides one problem behind another, which is worse than under-collapsing. First line is also cheap and reversible.

    Two consequences I had to handle that the task did not name:
    - the entries endpoint has to match the SAME normalised key, or a collapsed group opens empty — the count and the expansion must agree;
    - the occurrences panel previously showed only `extra`, so truncating the key would have hidden the very detail that made an occurrence distinct. It now shows an entry's full message when it carries anything past the group key.

    Acceptance covered: six records differing only in an embedded `Audit-Id` collapse to one row; two distinct single-line messages stay two rows; the expansion returns every row the group counted with full messages intact.

    Note ISE-542 is still the underlying 403 those six rows report — fixing it removes today's example but not this defect, as you said.
assignee: steve
priority: medium
task_status: done
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
