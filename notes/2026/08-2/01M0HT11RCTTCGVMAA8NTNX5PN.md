---
id: 01M0HT11RCTTCGVMAA8NTNX5PN
created: 2026-08-21T09:21:58.028996Z
updated: 2026-08-21T20:09:15.951589Z
type: task
title: Build images on merge to main; staging deploy becomes retag + helm
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 334
sprint: sspwpgk
comments:
- id: 01M0JZ1XTDE4N20297B3N7JTW5
  author: Steve Vine
  at: 2026-08-21T20:09:04.077126Z
  text: |-
    Done — PR #330, squash-merged to main 2026-08-21. ADR 0041 amended.

    Deploy latency was 11-18 minutes, nearly all of it buildx, and all of it sat between "I want to smoke-test this" and being able to. The work was always going to happen — it now happens at merge, where nobody is waiting on it.

    build-images moves to push -> main, alongside the backstop. The pointer push then finds its images already in the registry, because staging is by definition fast-forwarded to a main commit and that commit's push built and pushed both images tagged with its short SHA.

    So the deploy PROMOTES rather than rebuilds: `docker buildx imagetools create` copies the manifest server-side, the blobs already being in the repository, so nothing is downloaded or re-uploaded. That is not merely faster — it means the bits deployed are byte-identical to the ones the trunk build produced, which a rebuild could not promise.

    The secret scan now also runs on main: an image should only ever be built from scanned code, and the build is now on the trunk.

    ADR 0008 is untouched in substance — both tags are still immutable and `latest` is still never used. The staging-yyyymmdd-hhmm tag now records when a commit was PROMOTED rather than when it was compiled, which is the more useful of the two. ADR 0041's trigger table said the staging push is what builds, so it gets an amendment recording all of the above.

    One new failure mode, named in the ADR rather than left to be discovered: the pointer can be moved to a commit whose trunk build has not finished or never ran, leaving nothing to promote. The deploy fails fast with an explicit message instead of deploying something stale, and the existing operating rule "do not move the pointer while the backstop is red" now also means "not before the build is green".

    Note this sprint's own deploy will be the first exercise of the new path.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
The staging push currently builds both images (11–18 min deploy latency). Build on every push to main instead (parallel with the backstop, tagged by SHA); the staging push then retags/promotes the existing image and runs helm + smoke (~2–3 min). Needs an ADR amendment: ADR 0008/0041 word the staging push as what builds — images stay immutable, only the build trigger moves. Keep the dispatch fallback for dropped push events.