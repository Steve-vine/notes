---
id: 01M7QCHFZR2JNMY6792MD6T656
created: 2026-11-18T13:11:36.184687Z
updated: 2026-11-18T20:54:17.270576Z
type: task
title: 'A Group shape: a titled box that holds other shapes together, like a lane but standing on its own'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1954
sprint: s6y6p7g
comments:
- id: 01M7QVXPA2KVASA3ES6FY6XK2B
  author: Steve Vine
  at: 2026-11-18T17:40:24.51458Z
  text: |-
    Done — PR #1941, merged f41ea26c.
    - Group joins the shape buttons: a tinted box with a dashed edge and a title along its top. With shapes selected, Group (or Group these in the panel) wraps them; otherwise it lands in the next free place.
    - A shape is in the Group its middle sits in: drag one in (the Group highlights while it's over it) or out; a Group drawn or resized round shapes takes them in. Moving a Group moves everything in it. Resizing stops at what it holds, and it grows when a shape in it is moved or enlarged towards its edge.
    - Remove asks: keep its shapes, or remove them too. Ungroup keeps them. Either way the Group's own connections go, and the dialog names them first.
    - A Group can span lanes (each shape keeps its own lane) and can be connected to and from shapes outside it, with labels and line styles — never to a shape inside it. Fill, border colour, pattern and weight from the Style panel apply to it.
    - Reading view, PDF, Word and downloads draw it behind its shapes. Plain-text steps read "1. Raise the incident → “Repeat every hour” (steps 2–4)" and, after the steps, "Group “Repeat every hour”: steps 2–4 → when finished: Fixed → 5". Compare versions names Groups added, removed or renamed, shapes moved in or out, and Group connections. Polaris can create, fill, connect and read Groups. Tidy up keeps a Group's shapes together. A draw.io container or group comes in as a Group.
    Assumptions: the plain text uses the second wording in the task ("Group “…”: steps 4–6 → when finished: 7"). A Group's title wraps across its top rather than being cut. Split parts no longer apply, since COM-1960 always fits a flowchart on one page.
    To check on staging: draw a Group round two or three steps across two lanes, connect into it and out of it, then check the reading view, the PDF and the plain-text export. Try Remove both ways, then Undo.
- id: 01M7R70PDP4YJ7RNRJJ4QA4Y9T
  author: Steve Vine
  at: 2026-11-18T20:54:17.270347Z
  text: |-
    Pre-UAT on staging cbacf0c2 — Passed
    Flowchart: "E2E pre-UAT COM-1954 COM-1955 COM-1956 group line text" (two lanes). v1 plain, v2 with the Group, Text and Lines, v3 text styles. Also a draw.io import into "E2E pre-UAT COM-1954 draw.io container import" (draft). As E2E Admin A in E2E Test Company.
    - Add, title, fill, ungroup, resize, move, style, delete both ways: Passed.
      - Group these: I selected "Check the queue", "Work the oldest ticket" (Engineer lane) and "Update the requester", then chose Group these. A dashed, tinted Group appeared round them across both lanes, and I titled it "Repeat every hour" in its panel.
      - Dragging in and out: dragging a Text shape in made the Group highlight while over it, then "Holds 4 shapes". Dragging a step out gave "Holds 3", and Undo put it back.
      - Drawing round shapes: I added a second, empty Group (it lands in free space) and resized it round "Close the incident" and End, and it took both in ("Holds 2 shapes").
      - Moving: dragging the Group moved all four members by the same amount.
      - Resize floor: dragging the bottom edge up 150px and the right edge in 300px left it the size of what it holds. Dragging down grew it. Moving a member towards the top edge grew it upwards.
      - Styling: fill #fff0f6, Accent border, Dotted, Thick.
      - Removing: Remove asks "It holds 2 shapes. Keep them where they are, or remove them too?". "Remove its shapes too" removed both shapes and their connections, and Undo brought everything back. "Keep its shapes" left them in place. Ungroup with no connections just ungroups. On the main Group, both Remove and Ungroup list the 2 Group connections by name before doing anything (r2-11-remove-dialog.png, r2-13-remove-dialog-connections.png).
    - Connected to and from shapes outside, never inside; labels and line styles; across lanes: Passed. I dragged from "Raise the incident" to the Group, and from the Group to "Close the incident", labelled "Fixed", Curved and Dashed. The into-line is Thick and Accent. Its panel says "From the group … Out of a group: when it is finished…". Dragging the Group to "Check the queue", and that step back to the Group, made no connection.
    - Canvas, reading view, PDF, Word and downloads show it: Passed (r2-04-styled-labelled.png, r2-14-read-light.png, r2-dl-….png/.svg, r2-group-v2/v3.pdf/.docx).
    - Plain-text steps: Passed. "2. Service Desk: Raise the incident → “Repeat every hour” (steps 3–5); → 3" and "Group “Repeat every hour”: steps 3–5 → when finished: Fixed → 6" (r2-group-v2.txt).
    - Compare: Passed. It reads Group added, each shape "moved into the group", and both Group connections added (r2-16-compare-v1-v3.png).
    - draw.io container → Group: Passed. My own file has a container holding two steps, a line into the container and a line out of it. It came in as a Group "Repeat every hour" holding both, with "Start → the group" and "the group → Close it (Finished)" (r2-18/19).
    Observations, not failures:
    - The line from "Raise the incident" down to "Check the queue" runs straight through the Group's title.
    - Moving a Group so that it covers a shape that isn't in it takes that shape in (moving it down 37px took in "Close the incident").
    - Group title text styles aren't drawn (see COM-1957).
    Screenshots: ~/compass-uat/s6y6p7g/COM-1954/
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Steve, testing on staging, 2026-11-18: add a new shape type, Group. It's a larger shape you put other shapes into to group them together, a bit like lanes but stand-alone. Steve, same day: Groups can also be connected to shapes outside the group.

**What the author sees**
- **Adding one:** Group joins the shape buttons. It's a larger box with a title along its top edge (e.g. "Repeat every hour", "Out of hours only"), and it can be added by click or drag (COM-1946).
- **Membership:**
  - Dragging a shape into a Group puts it in the group; dragging it out takes it out. The Group shows a highlight while a shape is over it.
  - Drawing a Group around shapes that are already placed takes them in.
  - Selecting shapes and choosing **Group these** wraps them in a new Group. **Ungroup** removes the Group and leaves its shapes where they are.
- **Moving, resizing, deleting:**
  - Moving a Group moves everything in it, and its lines follow as COM-1945 sets out.
  - Resizing a Group (COM-1940) never cuts a shape in it in half. It can't be made smaller than what it holds, and it grows if a shape inside is moved or enlarged towards its edge.
  - Deleting a Group asks whether to keep its shapes (ungroup) or delete them too. Either way its own connections go, and Compass says how many.
- **Lanes:**
  - A Group can sit inside one lane or span several. Each shape inside keeps its own lane, so a Group can mark, say, a repeating cycle that crosses roles.
  - Groups can't be put inside other Groups in this task.
- **Connections to and from a Group:**
  - A Group can be connected to and from shapes **outside** it, the same way shapes are connected. The line meets the Group's edge, can have a label, and takes line styles (COM-1944).
  - A Group can't be connected to a shape inside itself.
  - Shapes inside keep their own connections too, including ones that cross the Group's edge.
  - Meaning: a connection **into** a Group means "go into this group", and one **out of** a Group means "when this group is finished, go on to…". The plain-text steps say so. For example: "3. Repeat every hour (steps 4–6) → when finished: 7. Close the incident".
  - Ungrouping or deleting a Group removes its own connections, and Compass names them first.
- **Not a step:** a Group still isn't counted as a step, and it doesn't carry Compass links (controls, documents, roles). Its connections are the only lines it has.
- **Styling:** fill, border colour, border pattern and weight work as for other shapes (COM-1942, COM-1951). The default is a light tinted fill with a dashed border, so it reads as a container.
- **Tidy up** keeps a group's shapes together, lays the Group around them, and routes the Group's own connections around steps like any other.

**What a reader sees**
- The reading view, PDF, Word and downloads show each Group with its title around its shapes, and its connections.
- A split flowchart (COM-1910) never cuts a Group across parts unless the Group is bigger than a whole page.
- The plain-text steps, search and Polaris mention groups and their connections, e.g. "Group 'Repeat every hour': steps 4–6 → when finished: step 7".

**Elsewhere**
- **Imports:** a draw.io container or group becomes a Group, including lines drawn to or from the container.
- **Polaris** can create, fill, connect and ungroup Groups like other shapes.
- **Compare versions** mentions Groups added, removed or renamed, shapes moved in or out, and Group connections added or removed.

**Done when**
- A Group can be added, titled, filled by dragging, drawing around shapes or Group these, ungrouped, resized, moved with its shapes, styled and deleted (keep or delete contents).
- It can be connected to and from shapes outside it (never inside), with labels and line styles. It works inside one lane or across several.
- Groups and their connections show correctly on the canvas, in the reading view, PDF, Word, downloads and split parts, and in the plain-text steps.
- Tests cover membership, moving, the resize floor, deleting both ways, crossing lanes, Group connections (and refusing one to a shape inside), and the plain text.

On the chain: the stored flowchart gains a new shape type, group membership and connections to a group, which the server checks.