---
id: 01M7NVXA8AG9M78QMBWRBPM1D8
created: 2026-11-17T23:01:43.306579Z
updated: 2026-11-18T13:00:27.662748Z
type: task
title: 'Polaris and the Library: find documents by folder, file them, arrange folders, write summaries and tags'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1923
sprint: s2q1gxe
blocked_by:
- 01M7NVWXE7HPXBBB2WXV4AN3DS
comments:
- id: 01M7Q54YZ8P7PR08XC6C4PY9XR
  author: Steve Vine
  at: 2026-11-18T11:02:25.511716Z
  text: |-
    Done: merged as PR #1928 (5ed5a16d). Every check passed on the first run. No migration and no API change.

    What a person can now ask Polaris, in Ask Polaris and over the Playbook MCP address:
    - **Anyone who can see Content:**
      - "What's in the PCI DSS folder?"
      - "Find our documents about ransomware" (the Library's own search, published versions only).
      - "Where does the Access Control Policy appear?"
      - "What isn't filed yet?"
      - Polaris can also list documents with a given tag, and documents with no summary or tags.
      - Answers give folder paths and links into the Library.
    - **People who can edit Content can also have Polaris:**
      - make, rename, describe, re-icon, recolour, move, reorder and delete folders;
      - file and unfile documents and decisions;
      - suggest and save summaries and tags.
    - **Asks first:**
      - It lists the documents before filing more than 5 at once.
      - Before deleting a folder it asks the Library page's question ("Delete Old? Its 3 folders go too. 12 documents stay in their other folders. 4 will be Not in a folder.").
      - It saves a summary and tags only once the person agrees.
    - **A reader asking for a change** is told in plain words that it needs the right to edit Content.
    - **Never publishes** a document or changes its text. Every change is in the activity log as the person's, via Polaris.
    - **Polaris's instructions** now describe the Library and these rules.

    Tools: five new Playbook tools.
    - **Library browse:** a folder, Not in a folder, where a document appears, tagged, or needs a summary.
    - **Library search.**
    - **Library arrange:** create, change, move, reorder, delete.
    - **Library file:** file or unfile documents in a folder.
    - **Library describe:** suggest or save a summary and tags.

    The Playbook address goes from 64 to 69 of its 128 tools.

    Choices made, for Steve to overturn:
    1. Summary and tags have their own tool rather than new fields on the content and decision edit tools. Decisions are edited by a Posture tool that the Playbook address doesn't offer, so this was the only way to cover both from Playbook.
    2. Suggestions use the same Suggest with Polaris as the on-screen button, so the published version is read and existing tags are preferred. When Polaris can't suggest (switched off, or the role doesn't allow using it), the connected assistant is told to write the summary and tags itself and save them once the person agrees.
    3. Asking first happens in the conversation, not with an approval card. An approval card would appear on every folder change in Ask Polaris, even making one.
    4. Only "DEC-12" names a decision, never a bare number.

    Tests: 7 new integration tests cover:
    - each question as a reader and as an editor, over the Playbook address;
    - a reader's change refused;
    - bulk filing and delete asking first;
    - the activity log showing "via Polaris";
    - no new version after saving details;
    - the tool limit and instructions;
    - Ask Polaris with a test provider.

    The unit suite and the related integration suites pass. Links to a document open its reading pane once COM-1921 lands. Until then they open its folder.
- id: 01M7QBX34ERARGSA05ZYV81PG0
  author: Steve Vine
  at: 2026-11-18T13:00:27.662509Z
  text: |-
    Pre-UAT (staging build c15afb4d, E2E Test Company): **Passed** as a Content editor (E2E Admin A) over the Playbook MCP address. **Couldn't check** a reader's refusal, or Ask Polaris in Compass.

    Steps and what was seen, connected as E2E Admin A through the assistant's own sign-in to the staging Playbook address:
    - **The tool list:** all five Library tools, 69 tools in all, under the 128 limit. The instructions include the Library paragraph: ask before filing more than five documents, ask before deleting, never publish.
    - **Browse:**
      - "Business Continuity & Backup" folder: its 3 documents, with links.
      - Where Access Control Policy appears: its folders.
      - Where DEC-3 appears: Not in a folder, with a link.
      - The Not in a folder view and the top of the Library also work.
    - **Search "ransomware":** 3 results with snippets and counts by type.
    - **Arrange:**
      - Made an E2E folder and a subfolder, then renamed and recoloured the subfolder.
      - Moving a folder into its own subfolder was refused with the plain reason.
    - **File:**
      - 6 documents without confirming: nothing was filed, and Polaris returned the list and asked.
      - 2 documents, confirmed: filed.
      - Unfiling reports which documents are now Not in a folder.
    - **Delete:**
      - Without confirming, it asked "Delete … ? Its 1 folder goes too. 1 document stays in its other folders. 2 will be Not in a folder." and deleted nothing.
      - Confirmed, it deleted with the right counts.
    - **Describe:** with no fields given, it returned a suggestion for a runbook and for DEC-6, and saved nothing.
    - **Activity log:** records each change as E2E Admin A, via Polaris.

    Couldn't check:
    - **A reader's change being refused inside Polaris.** No test role that can't edit Content has "Connect Polaris", so the Viewer can't connect at all ("Your Compass role does not include 'Connect Polaris'"). The refusal is covered by the integration tests. **Steve:** try it with a role that can connect Polaris but can't edit Content.
    - **Ask Polaris in Compass** (the in-app chat). **Steve:** ask it "What's in the Access Control folder?" and "Find our documents about ransomware".

    Small wording point, being tidied in the polish task: "Its 1 folder goes too" should read naturally when there's only one folder inside.

    Everything made for the test was deleted, and the test connection was disconnected.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Polaris, in Compass and over the Playbook MCP address, can use the Library the way a person can, with exactly that person's rights. Built on COM-1916, COM-1917 and COM-1920.

**Anyone who can see Content can ask**
- "What's in the PCI DSS folder?" — the folder's subfolders and documents, with paths and links to the Library.
- "Find our documents about ransomware" — Library search (COM-1920), same ranking, published versions only.
- "Where does the Access Control Policy appear?" — every folder it's in.
- "What isn't filed yet?" — Not in a folder.

**People who can edit Content can also ask**
- "Make a folder called Cloud under Information security", rename, describe, recolour, move and reorder folders.
- "Put every PCI-tagged document in the PCI DSS folder" — Polaris lists what it will file and asks before filing more than a handful at once.
- "Delete the Old folder" — Polaris says what goes with it (COM-1916 wording) and asks first.
- "Write summaries and tags for the documents that have none" — Polaris drafts them from each published version and saves them when the person agrees, as COM-1917's Suggest with Polaris does on screen.

**Rules**
- Everything Polaris changes is in the activity log as made by the person, via Polaris.
- Nothing Polaris does publishes a document or changes its text.
- Playbook stays under its 128-tool limit for Copilot (ADR 0144): fold the Library into as few tools as possible.

**Done when**
- Each question above works on staging through the Playbook MCP address and in Compass's Ask Polaris, as a reader and as a Content editor.
- A reader's request to change folders is refused with the reason.
- The Playbook area's tool count is under the limit, and Polaris's instructions mention the Library.

On the chain: adds Polaris tools and changes the API they call.