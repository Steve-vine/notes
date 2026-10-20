---
id: 01M5CSGN03CVN39B759VMPYBJH
created: 2026-10-20T13:55:17.635112Z
updated: 2026-10-20T13:55:17.635112Z
type: task
title: Verify's Identity card shows what was asked for, not only when
label: improvement
task_status: todo
assignee: steve
priority: low
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1175
---
Steve's request while smoke-testing sprint 79.

**What's wrong:** under Verify, the Identity card says "ID asked for 20 Oct by Steve Vine." but not *what* was asked for. The note entered in Ask for identity ("A recent utility bill showing their address") only appears in the request's timeline. "Ask again" also replaces the date on the card, so earlier asks are only visible in the timeline.

**What it should do:** the Identity card lists each time ID was asked for, newest first: the date, who asked, and what they asked for (if a note was entered). The handler checking what came back can then compare it with what was asked without leaving the card.

**Behind it:** the note is only stored on the timeline entry. Nothing on the request holds it, so the card has no way to show it. The asks have to be readable for the card, either from the timeline entries or from a record of each ask. Nothing changes for requests that are already logged: their notes are already in the timeline.

**Done when:** after Ask for identity with a note, the Identity card shows the note beside the date and who asked. After Ask again, both asks are listed.