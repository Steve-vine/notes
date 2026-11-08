---
id: 01M6X87Y11A6HNPFC8CJAFM3YZ
created: 2026-11-08T09:36:13.345454Z
updated: 2026-11-08T09:38:01.112073Z
type: task
title: 'ADR 0143: assistants connect by signing in through the browser — no token in the config file; Claude, ChatGPT and (next sprint) Copilot'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1641
sprint: sd11qqf
assignee: steve
label:
- brief
priority: medium
task_status: todo
---
Record the decision that replaces ADR 0109 §3 ("connecting is by a personal token pasted into the assistant's settings"). Amend 0109 rather than rewrite it.

**Steve's decisions (2026-11-08):**
- Connecting an assistant is a browser sign-in: the person adds Compass by its address, signs in to Compass as usual (password or Microsoft), allows the assistant, and the assistant keeps its own sign-in. Nothing is written into a config file.
- Personal tokens retire from the assistant after a switch-over. They keep working for scripts calling the API.
- A connection lasts until 30 days unused. Disconnecting it, disabling the person, or the person losing *Connect an AI assistant* ends it at once.
- Administrators see every connected assistant and can disconnect any of them.
- Target assistants: Claude (Code and chat) and ChatGPT in this sprint; Microsoft 365 Copilot in "MCP Expansion - Copilot".
- The assistant's address is reachable from the internet on staging and production, because claude.ai, ChatGPT and Copilot connect from their own clouds.

**My calls (record them as such):**
- Only the assistant's door is public: the MCP address and the sign-in plumbing the assistant's cloud calls. Compass's screens stay internal. The browser part of signing in (Compass's sign-in page and the Allow screen) uses Compass's normal internal address, so a person must be able to reach Compass when they connect. After that the assistant works from wherever its cloud runs.
- The switch-over is ended by an administrator, not by a date (see the switch-over task).
- Same grant as today: *Connect an AI assistant*. What the assistant can do is still the person's role.

**Before writing it, check each assistant's current requirements** (my knowledge is from mid-2026): Claude Code, claude.ai custom connectors, ChatGPT (developer mode / workspace connectors) and Copilot Studio. For each: which client-registration methods it uses (dynamic registration, client ID metadata documents, or entered by hand), the MCP spec version it expects, redirect addresses, and any **limit on how many tools it accepts** (Compass has 600+). Put the findings in the ADR. If one has a tool limit we exceed, say so to Steve before the build starts: it changes scope.

**Done when:** `decisions/0143-*.md` is merged, 0109 carries an amendment pointing to it, and the findings table is in the ADR.

**Independent:** documents only.