---
id: 01M3KZHZSHE1Q6W896FTW1Y4EB
created: 2026-09-28T12:24:10.289949Z
updated: 2026-09-28T12:24:10.289949Z
type: task
title: Suggest a Feature dialog sends to the developer; remove the vault-local flow
assignee: steve
task_status: todo
label: feature
priority: medium
tech:
- svelte
- rust
project: 01KY6W9951TW0904DT0GGJVGE7
number: 469
---
The UI half of ADR 0065. Help → Suggest a Feature… opens a dialog that sends the request through `send_feature_request`. The ADR 0050/0051 path that filed a Task into a configured project goes away completely.

## Agreed work

- [ ] A new `FeatureRequestDialog.svelte` in the Nocturne style (ADR 0063) with:
  - **Summary** (required, one line, 120-char counter)
  - **Details** (optional, multi-line)
  - **Email** (required). Prefill it from the last one used.
  - A short disclosure line: *"Sent with your email, app version, OS and an anonymous install id."* Link it to the privacy policy.
- [ ] Field errors from the client-side validation. **Send** is disabled until the form is valid.
- [ ] While sending, show a busy state. On success, show *"Thanks — request sent (ref …)"* and then close. On failure, **keep everything typed** and say what happened in plain words: offline, rate-limited ("You've sent a few already, try again tomorrow") or a server problem, with a **Try again** button. Nothing typed may ever be lost.
- [ ] Esc and Cancel close the dialog and send nothing. Ask before discarding if something has been typed.
- [ ] Remember the email in `AppConfig` as `feature_request_email: Option<String>`, `#[serde(default)]`. It stays on this machine and is only sent with a request.
- [ ] **Remove the ADR 0050/0051 machinery:**
  - `feature_project`/`feature_sprint` from `AppConfig` and its tests. Confirm an existing `config.json` that still has them loads fine (no `deny_unknown_fields`) and that the next save drops them.
  - the `feature_target`/`set_feature_target` commands, `featureTarget()` in `notes.ts`, the Settings → Projects picker, the `askFeatureTarget` dialog, and `captureFeature` in `Main.svelte`
- [ ] Rewire `menu-suggest-feature` to open the new dialog.
- [ ] Check the Help → Suggest a Feature… entry point is reachable on Windows and Linux as well as macOS. If it isn't, note that and add an entry in Settings → About.
- [ ] Run svelte-check and the vitest suite.

## Notes

Screen capture is denied, so the visual pass needs Steve.