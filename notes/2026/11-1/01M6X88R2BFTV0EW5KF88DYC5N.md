---
id: 01M6X88R2BFTV0EW5KF88DYC5N
created: 2026-11-08T09:36:40.011067Z
updated: 2026-11-08T10:23:38.951789Z
type: task
title: The Allow screen — after signing in, the person sees which assistant is asking to act as them in Compass and allows or cancels it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1643
sprint: sd11qqf
blocked_by:
- 01M6X88E62KPHJ59H18MA3QA1J
assignee: steve
label:
- feature
priority: medium
task_status: active
---
The page the person sees in their browser when an assistant asks to connect (follows COM-1642).

**Wanted behaviour:**
- It names the assistant as it introduced itself (e.g. "Claude", "ChatGPT") and the address it will send the person back to. It says the assistant will act as them in Compass with exactly what their role allows, and that everything it does is recorded in Activity as done by them through the assistant.
- **Allow** connects it and returns the person to their assistant. **Cancel** returns them with nothing connected.
- A person whose role doesn't include *Connect an AI assistant* sees why, and who to ask, in the same words as today's refusal, and has no Allow button.
- A portal-only account (vendor or trust centre) can never get here.
- Arriving signed out goes through the normal sign-in (password or Microsoft) and comes back to this screen.
- Built to the screen conventions: a plain card, not a full app page. The assistant's name is shown as text exactly as sent and is never trusted as markup.

**Done when:** in E2E Test Company, signing in as a test account with the grant and allowing a local Claude Code connects it. Cancel connects nothing. A test account without the grant sees the refusal. Signing in first through password and then through the Microsoft path both return to the screen.

**Implementation:** a frontend route outside the app shell (no menu or breadcrumbs), driven by the authorize request COM-1642 hands over. Allow/Cancel post to the API COM-1642 adds. Read `brief/information-architecture.md` → *Screen conventions* first. Vitest for the three states (allow, cancel, no grant).

**Independent:** frontend only, after COM-1642 merges.