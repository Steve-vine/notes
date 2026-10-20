---
id: 01M5CY7XWPAXXG4HT2W71G9KW4
created: 2026-10-20T15:17:54.710804Z
updated: 2026-10-20T15:17:56.476793Z
type: task
title: A field's red error is easy to read in dark mode
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1176
sprint: ss8348q
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
Steve, while smoke-testing sprint 79 (seen on Data Subject Requests ▸ Settings ▸ Company, but it applies across Compass).

**What's wrong:** a field that's required but empty, or in the wrong format (such as a bad email address), turns red: the border, the message underneath, and the asterisk. That reads fine on the light background. On the dark background the red is a deep shade, so it's hard to see that anything is wrong, and the message is hard to read.

**What it should do:** in dark mode, the error red is a lighter red that stands out on the dark ground. The message text should be at least as readable as normal body text (4.5:1 contrast), and the border should be easy to see. Light mode stays as it is.

**Behind it (technical):** the theme sets its own colours for each family per scheme (ADR 0085, `theme.ts` `schemeVariables`), but not `--mantine-color-error`. The toolkit's default dark value points at a deep shade of red (red-8), which on our re-pointed red ramp is the dark one. Set `--mantine-color-error` for each scheme from the red tone, using the light-text shade in dark mode, and add it to the theme test's contrast checks. That covers every input, Select, Textarea, date picker and checkbox error at once. Also check other places that use red text directly (`c="red"` error lines in modals) so they match.

**Done when:** in dark mode, an empty required field and a bad email address show a red border and message that are easy to read, and a test pins the error colour's contrast against the dark surface.