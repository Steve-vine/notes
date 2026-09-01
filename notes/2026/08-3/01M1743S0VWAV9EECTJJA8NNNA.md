---
id: 01M1743S0VWAV9EECTJJA8NNNA
created: 2026-08-29T16:02:16.219752Z
updated: 2026-09-01T13:55:51.647805Z
type: task
title: A refused read should say what actually went wrong
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 518
sprint: s5cyp1z
comments:
- id: 01M1765PV28SSGB2T12QDM8EPN
  author: Steve Vine
  at: 2026-08-29T16:38:16.674268Z
  text: |-
    Done — PR #513, merged to main as 4964cc1.

    The applications and conditional access reads now say what actually went wrong. A refusal still names the permission, but leads with the restart, because that is the case seen on staging: a live grant, a green health card, and a worker holding a token minted before the consent. Anything else — a throttle, an outage, a network blip — is reported as what it was, and deliberately does not name the permission at all: somebody skimming a message that mentions a grant goes and grants it, whatever the sentence around it said.

    The reason is now composed where the failure is and travels back with the read, because by the time the status row is written a refusal and a throttle are indistinguishable.

    Audited every other Graph failure handler in tasks/. Nothing else hardcodes a permission sentence — the two sweeps already split 401/403 correctly, role eligibility and the audit actor lookup record the actual error, and the grants, contacts and $expand fallbacks have no status pair to lie on.

    Not done, and worth its own task: the "stale since 09:15" idea. Recording when each read last succeeded needs the same column on all five separately-permissioned reads (sign-in, auth methods, applications, conditional access, role eligibility) plus the Integrations card, and doing it for two of them makes the card inconsistent.

    No behaviour change — a failed read still leaves the mirrored rows alone. No migration, no API change. 84 integration tests green.
assignee: steve
label:
- bug
priority: medium
task_status: done
---
When the applications read (COM-498) or the conditional access read (COM-501) fails, the mirror records the same sentence whatever happened: *it needs the Application.Read.All / Policy.Read.All permission, with admin consent*. It is the right message for the common case and a confident lie for every other one.

**Seen on staging the day it shipped.** Both grants had just been consented and were live — the health card was green — but a sync pass that finished on a worker holding a token minted before the consent recorded "needs the Policy.Read.All application permission". Anybody reading that would have gone to the Azure portal to fix something that was already correct, and the real answer (*restart the worker*) was the one sentence the message buried at the end.

A throttle, a Graph outage or a network blip would each read the same way. Diagnosing a five-minute problem as a permissions problem is how somebody ends up granting a permission they did not need.

**The house idiom already gets this right.** `tasks/auth_methods_sweep.py` splits 401/403 — a genuine grant problem, worth naming the permission for — from everything else, which is logged as what it was. The two reads added in sprint 48 skipped that split. Bring them into line, and check nothing else added since has drifted the same way.

Worth considering while it is open, because the status pair cannot currently express it: **a read that failed once is not a read that has never worked.** The columns say available/unavailable and nothing else, so a transient blip and a permission nobody has ever granted look identical on the Integrations card. Recording when the read last succeeded would let the card say *stale since 09:15* rather than *unavailable*, which is a different instruction to the reader. Same shape as `sign_in_observed_at` — the column COM-492 added so *never signed in* could be told from *not yet read*.

**No behaviour changes.** A failed read still leaves the mirrored rows alone, which is the part that matters and is already right. This is about what the reader is told to do next.