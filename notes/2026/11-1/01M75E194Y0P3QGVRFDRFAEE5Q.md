---
id: 01M75E194Y0P3QGVRFDRFAEE5Q
created: 2026-11-11T13:51:22.270847Z
updated: 2026-11-11T17:31:38.54056Z
type: task
title: 'A host scanned by two parts keeps both parts'' findings: one part''s run no longer closes what only the other part reported'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1729
sprint: sj4f1kj
comments:
- id: 01M75F4D15YES3ZSKET077ZP4M
  author: Steve Vine
  at: 2026-11-11T14:10:33.125253Z
  text: |-
    Built and merged to main (PR #1725, 2026-11-11). On the chain: migration 0810 records which parts report a finding. No API change. Going to staging now, before Nessus's Findings feed is approved.

    What changed:
    - A finding remembers which parts (scans) report it.
    - When a part's run reads a host without a finding, that part stops counting for it. The finding closes by "missing" only once no part reports it any more.
    - Feeds without parts, the coded readers and findings recorded earlier close as they always did.
    - The first run after this may close and reopen once a finding recorded earlier, on a host shared by two scans (3 hosts on staging).

    Tests: a fake service with one host in two scans. Three runs close nothing; a finding both scans report survives one scan dropping it; only the one dropped by its only scan closes. The test fails without the change. The feed, lifecycle and Unmatched suites pass.

    Pre-UAT: this shows on staging once Steve approves Nessus ▸ Feeds ▸ Findings. After two runs, the 3 hosts that are in more than one scan should keep every scan's findings open.
assignee: steve
label:
- bug
priority: high
task_status: done
---
Found in pre-UAT of COM-1724 on staging, 2026-11-11, setting up Nessus's Findings feed with each scan as a part.

A feed with parts applies each part's records on its own (ADR 0148 §3). When a feed closes by "missing", a part's run treats every host it reported as fully read, so any finding on that host it didn't report is marked fixed. A host in two scans therefore flaps: scan B's run closes what only scan A found on it, and the next run reopens it. On staging, 3 of Nessus's 212 hosts are in more than one scan. This was possible on several-companies accounts since COM-1708; COM-1724 makes it reachable on every account with parts.

**Chain:** on the chain (a finding records which parts report it: migration)

## What the person sees
- A finding found by several parts (scans) stays open while any of them still reports it. It closes by "missing" only when every part that reported it has read the host again without it.
- A part set to Don't read doesn't count either way.
- Feeds without parts, and the coded readers, behave as before.
- Findings recorded before this change don't say which part found them. On the first run they may close and reopen once on hosts scanned by several parts (3 hosts on staging). After that they're kept per part.

## Done when
- Tested with a fake service: a host in two parts, each reporting a different finding. A run closes neither; dropping one finding from its part closes only that one.
- Existing parts tests and the vulnerabilities source tests still pass.
- No service name in code (COM-1696).