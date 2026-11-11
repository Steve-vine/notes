---
id: 01M74YVJA3Q7HVXWT5499PWFM1
created: 2026-11-11T09:26:06.40352Z
updated: 2026-11-11T09:26:08.658469Z
type: task
title: A feed's Preview reads a sample when it has many follow-on reads, and a refused app sign-in says which step and what it asked for
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1722
sprint: sj4f1kj
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
Found setting up the GitHub App and Aikido on staging (COM-1713/1715), 2026-11-11.

**Chain:** independent

1. **Preview times out on a big follow-on feed.** The GitHub App's "Deploy keys" and "Actions secrets" feeds make one follow-on read per repository: 247 for Moneypenny-Development. Preview runs within the web request, so it times out. Scheduled runs on the worker aren't affected.
   - Preview should read the first 25 follow-on reads, say "Preview read 25 of 247 repositories", and show the records from those.
   - A partial preview counts nothing as closed.
2. **"The service refused the app sign-in (404)" doesn't say which step.** The lookup and the exchange give the same sentence. It should name the step and what it asked for, e.g. "GitHub has no installation of this App for Moneypenny-Development (the lookup /orgs/Moneypenny-Development/installation answered 404). Install the App on it, then test again."

## Done when
- A feed with hundreds of follow-on reads previews within the request, with the sample stated, and nothing counted as closed.
- A refused lookup and a refused exchange each say which step, the path and the service's words. Tested against a fake service.