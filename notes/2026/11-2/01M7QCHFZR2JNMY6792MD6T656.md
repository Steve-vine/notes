---
id: 01M7QCHFZR2JNMY6792MD6T656
created: 2026-11-18T13:11:36.184687Z
updated: 2026-11-18T13:13:09.679511Z
type: task
title: 'A Group shape: a titled box that holds other shapes together, like a lane but standing on its own'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1954
sprint: s6y6p7g
assignee: steve
label:
- feature
priority: medium
task_status: todo
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