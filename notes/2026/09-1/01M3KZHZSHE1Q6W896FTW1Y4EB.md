---
id: 01M3KZHZSHE1Q6W896FTW1Y4EB
created: 2026-09-28T12:24:10.289949Z
updated: 2026-09-28T13:56:50.780078Z
type: task
title: Settings → Request a feature pane sends to the developer; remove the vault-local flow
project: 01KY6W9951TW0904DT0GGJVGE7
number: 469
sprint: svg0tvg
blocked_by:
- 01M3KZHMBY30C5WK7CTNJ6SP9T
comments:
- id: 01M3M4VN0BB1H24DE60D0CNYRK
  author: Steve Vine
  at: 2026-09-28T13:56:49.800822Z
  text: |-
    Built. PR #474 (brief-469-request-a-feature-pane), in Review.

    What landed:
    - Settings → Request a feature, after About, with the lightbulb icon. It needed its own branch, because Settings' final {:else} renders Storage.
    - FeatureRequestPane.svelte: summary with a counter, optional details, required email prefilled from the last one used, and the disclosure line. Errors show only once a field has been left. Send is disabled until the form is valid, and Cmd/Ctrl+Enter sends.
    - On success it shows the reference and clears the fields, keeping the email. On failure it keeps everything typed and explains why in plain words.
    - The draft lives in a module store (featureRequestDraft.svelte.ts), so it survives pane switches and closing Settings, for the session only.
    - AppConfig.feature_request_email replaces feature_project/feature_sprint. An old config still loads and the next save drops the old keys, and a test covers this. The email is saved after the Worker accepts a request.
    - Help → Request a Feature… (renamed) opens Settings on the pane.
    - The ADR 0050/0051 code is removed, including FeatureTargetDialog.svelte.

    Decided along the way:
    - I dropped the intro paragraph and folded the "so the developer can reply" hint into the disclosure line. With them in, Send was pushed below the fold at the 600px minimum window height.
    - The Details counter only appears near the 4000 limit.

    Verification: svelte-check reports 0 errors, 411/411 vitest tests pass (8 new), and the pre-push hooks passed. The real Settings.svelte was rendered headlessly in a throwaway Vite lab with a mocked invoke, at the minimum window size in dark and light. I checked the empty, errors, sent, offline, rate-limited and pane-switch states; all behave correctly and Send fits in every normal state.

    Not done:
    - A visual pass in the real Tauri app, which needs Steve.
    - The privacy-policy link on the disclosure line, because no URL is known yet.
assignee: steve
label:
- feature
priority: medium
task_status: review
tech:
- svelte
- rust
---
The UI half of ADR 0065. Requests are written and sent from a new **Request a feature** pane in the Settings modal, listed directly under **About**. It uses the `lightbulb` icon, which brings back the bulb that dropped off in the UI redesign (ADR 0063). The pane sends through `send_feature_request`. The ADR 0050/0051 path that filed a Task into a configured project goes away completely.

## Agreed work

- [ ] Add a section to `SECTIONS` in `Settings.svelte`, directly after `about`: `{ id: "request", label: "Request a feature", icon: "lightbulb", desc: "Suggest an idea to the Notuvia developer." }`. `SectionId` picks it up from there.
- [ ] Put the pane body in its own `FeatureRequestPane.svelte` so `Settings.svelte` doesn't grow much. It has:
  - **Summary** (required, one line, 120-char counter)
  - **Details** (optional, multi-line)
  - **Email** (required). Prefill it from the last one used.
  - A short disclosure line: *"Sent with your email, app version, OS and this install's id."* Link it to the privacy policy. Don't call the id anonymous: sent alongside an email, it isn't.
- [ ] Field errors from the client-side validation. **Send** is disabled until the form is valid.
- [ ] While sending, show a busy state. On success, clear the form and show an inline *"Thanks — request sent (ref …)"* in the pane. On failure, **keep everything typed** and say what happened in plain words: offline, rate-limited ("You've sent a few already, try again tomorrow") or a server problem. Send stays available to try again.
- [ ] **Nothing typed is lost** by switching to another Settings pane and back. If Settings is closed with an unsent draft, keep the draft for the rest of the session (in memory only) rather than asking.
- [ ] Remember the email in `AppConfig` as `feature_request_email: Option<String>`, `#[serde(default)]`. It stays on this machine and is only sent with a request.
- [ ] **Help → Suggest a Feature…** opens Settings on this pane, the same way About Notuvia opens it on About (`settingsTab = "request"; settingsOpen = true`). Rename the menu item to **Request a Feature…** so the menu and the pane use the same words.
- [ ] **Remove the ADR 0050/0051 machinery:**
  - `feature_project`/`feature_sprint` from `AppConfig` and its tests. Confirm an existing `config.json` that still has them loads fine (no `deny_unknown_fields`) and that the next save drops them.
  - the `feature_target`/`set_feature_target` commands, `featureTarget()` in `notes.ts`, the feature-target picker in Settings → Projects, the `askFeatureTarget` dialog, and `suggestFeature`/`captureFeature` in `Main.svelte`
- [ ] Run svelte-check and the vitest suite.

## Notes

Settings is reachable on every platform (the rail's gear and `?`), so the pane is the entry point on Windows and Linux regardless of how their Help menu renders. Screen capture is denied, so the visual pass needs Steve.