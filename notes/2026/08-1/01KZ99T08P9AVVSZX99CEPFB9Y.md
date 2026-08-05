---
id: 01KZ99T08P9AVVSZX99CEPFB9Y
created: 2026-08-05T15:48:52.630374Z
updated: 2026-08-05T16:01:17.466954Z
type: memo
title: Notuvia MCP Server Config
project: 01KY6W9951TW0904DT0GGJVGE7
---
### Setup system wide for Claude Code
```
claude mcp remove notuvia -s local   # ignore "not found"
claude mcp remove notuvia -s user
claude mcp add --scope user notuvia -- /Applications/Notuvia.app/Contents/MacOS/notuvia-mcp
```
