---
id: 01KZ8PMSWQV5CHYP9PCW8HKPQR
created: 2026-08-05T10:13:59.319415Z
updated: 2026-08-07T08:59:01.599625Z
type: memo
title: 'ISE Claude Code setup incident resolution '
project: 01KX671DATY39VW6GWK3M2T3DN
---
### Prereq
- Claude Code installed and signed in.
- Network access to https://ise.citops.net
- A checkout of the ISE repo (or copy the clients/claude-code/ folder over by hand).
  
---
### Get an MCP token and connect
In ISE: Settings → Claude Code → New MCP token. Pick the lowest role that suits — for incident testing you need more than viewer (viewer can't acknowledge, resolve, merge, or record; those tools aren't even listed for it).

Copy the bearer token and make a note of it for later, then run the one-liner on your laptop.

---
### Install the skill
From the ISE repo run:
```
mkdir ~/.claude/skills/
cp -r clients/claude-code/skills/ise ~/.claude/skills/
```

---
### Install the statusline
From the ISE repo run:
```
cp clients/claude-code/statusline/ise-statusline.sh ~/.claude/ise-statusline.sh
chmod +x ~/.claude/ise-statusline.sh

mkdir -p ~/.config/ise
cp clients/claude-code/statusline/ise.env.example ~/.config/ise/env
chmod 600 ~/.config/ise/env
```
Edit `~/.config/ise/env` and set:
```
ISE_URL=https://ise.citops.net
ISE_MCP_TOKEN=<bearer-token>
```

Then add the statusline to `~/.claude/settings.json` (merge with whatever's already there):
```
{
  "statusLine": { "type": "command", "command": "~/.claude/ise-statusline.sh" }
}
```

  ---
### Restart and verify
  1. Restart Claude Code (new session) so it picks up the skill, statusline, and MCP server.
  2. Statusline should read ISE ▸ no session | <model>. If it shows only the model name, the env file or token is wrong — the script fails silent by design. Test it directly with: `echo '{"model":{"display_name":"test"}}' | ~/.claude/ise-statusline.sh`
  3. Ask Claude "what can you see in ISE?" — it should call describe_resources and describe your install's resource map.
     
---
### Working an incident (the loop you'll use for scenario testing)
1. Start: /mcp__ise__work-on IN-NNNN — or the Work on this in Claude button on the incident page, which shows the exact command. Statusline becomes ISE ▸ IN-NNNN (status) ▸ You.
2. Everything done through ISE tools lands on the incident timeline live.
3. Finish: record conclusions first (record_note, commit_diagnosis), then /mcp__ise__exit. Anything that only lives in the chat is lost to ISE.

---
### Gotchas
- One active session per user; pinning another incident supersedes the current one, and 4 hours idle auto-ends it.
- After any ISE release, reconnect (/mcp → reconnect, or restart) — the tool catalogue is fetched at connect time only, so a pre-deploy session will claim new tools "don't exist".
- The optional UserPromptSubmit hook (hooks/ship-prompt.sh) that records your prompts on the ticket is off by default and a team decision — skip unless you want it; setup is in hooks/README.md.
- Tokens revoke instantly in Settings → Claude Code if you need to kill one.