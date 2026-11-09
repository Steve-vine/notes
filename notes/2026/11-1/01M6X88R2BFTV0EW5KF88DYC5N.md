---
id: 01M6X88R2BFTV0EW5KF88DYC5N
created: 2026-11-08T09:36:40.011067Z
updated: 2026-11-09T19:14:15.255638Z
type: task
title: The Allow screen — after signing in, the person sees which assistant is asking to act as them in Compass and allows or cancels it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1643
sprint: sd11qqf
blocked_by:
- 01M6X88E62KPHJ59H18MA3QA1J
comments:
- id: 01M6XCV403PMRTQZ8530R60BPD
  author: Steve Vine
  at: 2026-11-08T10:56:36.355161Z
  text: |-
    Done: PR #1657, merged to main.

    What changed: when an assistant asks to connect, your browser shows a card titled "Connect Claude?" (or whatever the assistant calls itself). It says the assistant will act as you with exactly what your role allows, that everything it does is recorded in Activity as done by you through the assistant, and where answering will return you. If you'll be returned to an app on this computer (Claude Code), there's an extra warning to allow it only if you've just started connecting. Allow connects it, and Cancel connects nothing. Either way you go back to the assistant.
    - Without "Connect Polaris" you see why, in the door's own words, and there's no Allow button.
    - A vendor or trust-centre account can't use it.
    - An expired request, an assistant Compass doesn't know, or one asking to return somewhere it never registered all say to start again from the assistant.
    - Arriving signed out takes you to sign in, and you come back to the card afterwards, by password or by Microsoft.
    - The assistant's name is always shown as plain text.

    Tested: allow, cancel, no grant, the loopback warning, a name containing markup, an expired request, an unknown assistant, and the login page carrying you back.

    Still to check: E2E Test Company in the browser on staging, once it's deployed and the staging tunnel exists (see COM-1647).
- id: 01M6XF6H30CRDZBKT8BPR02A70
  author: Steve Vine
  at: 2026-11-08T11:37:47.360627Z
  text: |-
    Pre-UAT on staging (9ae87353, E2E Test Company): **Passed**, except the Microsoft path, which I couldn't check.

    - **Signed out:** opening an assistant's sign-in link went to the login page with the way back attached. The "Sign in with Microsoft" link carries it too.
    - **E2E Admin A and E2E Admin B:** the card read "Connect UAT Claude Code?" (and "Connect UAT ChatGPT stand-in?"), with "Signed in as …", "returns you to an app on this computer (localhost)" and the local-app warning. Allow sent the browser back with a code, state and issuer.
    - **E2E Viewer (no grant):** the card shows "Your Compass role does not include 'Connect Polaris'. Ask a Compass administrator to add it to your role." There's only a Cancel button. Cancel sent the browser back with access_denied and nothing was connected.
    - The only browser errors were the expected signed-out checks.

    **Couldn't check:** signing in with Microsoft and landing back on the card. It needs a real Microsoft account. Steve: open the sign-in link from any assistant, choose Sign in with Microsoft, and check you land on the Allow card.

    Screenshots: ~/compass-uat/sd11qqf/COM-1643/
assignee: steve
label:
- feature
priority: medium
task_status: done
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