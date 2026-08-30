---
id: 01M194DR53W6QGX7KCYFGVWQGV
created: 2026-08-30T10:46:11.875736Z
updated: 2026-08-30T12:08:29.113618Z
type: task
title: 'Extra fields: an admin defines them, a group carries them'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 528
sprint: sz42uhw
comments:
- id: 01M1994CT7AP2QA2CY7YN8DBF1
  author: Steve Vine
  at: 2026-08-30T12:08:28.230973Z
  text: |-
    Shipped — PR #534, merged to main as a007e14.

    Two tables. `extra_field_definitions` is tenant-wide, `extra_field_values` attaches to the Entra object id with **no FK** (the object is a group *or* a user *or* a device *or* a role *or* a policy — the `DirectoryRoleAssignment` precedent), which is also what makes it impossible for a sync to cascade a value away. Five field types, the guards exactly as specified: Access write to define, Access read to fill in. Nothing is ever required.

    Everything under "what survives" is built and tested: a deleted definition hides but keeps its values; values stay on a vanished object (and the panel says they read as history); renaming a pick-list option leaves the answers recorded against it alone — it just cannot be chosen again; and a recreated group is a new object id, so it starts empty.

    One decision worth naming: **a cleared field keeps its row with a NULL value.** Somebody emptying a field is a fact with an actor and a timestamp; deleting the row would collapse it into "nobody ever filled this in", which is the one distinction the history exists for. Only changed fields are written, so an unchanged save leaves the trail alone.

    The activity log writes the old and new text into the summary rather than "updated extra field value \<uuid\>" — done in the audit listener because that is the only place that still has the previous value in hand.

    **Built so the follow-ups are wiring.** The object-type enum names all five from the start (adding a value later would be a migration on an enum for what is otherwise pure wiring), `ExtraFieldsPanel` takes the object type as a prop, and the value routes are generic over it. COM-529 to COM-532 should each be one component call plus a test.

    **One thing to decide.** The task says "somewhere in Admin" and names the Access-write set as the definer, and those two do not quite meet: the Admin page is admin-only in the UI, so today an access_manager can define fields through the API but not through that screen. The API guard is as you specified and the screen is where you asked for it. Opening Admin to Access-write, or moving the tab into Access Control, is a one-line change either way — say which and I will do it.
assignee: steve
company: null
label:
- feature
priority: high
task_status: review
---
Compass mirrors the tenant but has nowhere to write down what the tenant does not know: why a group exists, which team owns it, what it is for. People keep that in a spreadsheet or in their heads. This is the foundation — an admin defines extra fields, and the first object type that carries them is the group.

**What an admin does.** Somewhere in Admin, an Access Manager or above (`_ACCESS_WRITE` — admin, access_manager, access_admin) picks an object type and defines the extra fields it should carry: a label, a type, optional help text, and an order. The set is tenant-wide, not per company — the directory mirror is global and these follow it.

**The field types, and only these.** Text · long text · date · yes/no · pick-list (the admin defines the options). Deliberately small. Person, link-to-a-Compass-object and number-with-units are all real asks and all drag in real work; they wait for evidence.

**What a user does.** Anyone who can see the object can fill the fields in — the whole Access read set (`_ACCESS_READ`: admin, access_manager, access_engineer, access_reviewer, access_admin), not a narrower group. No field is ever required in this task; nothing blocks and nothing nags.

**The separation that matters.** Directory objects are mirrors — Compass does not own them and reconciles them against Entra on every sync. Extra-field values are the opposite: Compass owns them outright and **a sync must never touch them**. Values attach to the Entra object id and live in their own table, keyed the same way the mirror is.

**What survives.**
- Deleting a field definition hides it everywhere but keeps the values. Recoverable, not destroyed.
- Values stay on an object that leaves the tenant, exactly as the mirror keeps `vanished_at` rows rather than deleting them.
- The sharp edge, and it is intended: a group deleted in Entra and recreated with the same name is a *new* object id, so it starts with empty fields.
- Changing a pick-list option does not rewrite the values already recorded against it.

**History.** Setting or changing a value is an activity-log event — who, when, old value, new value. Cheap now, awkward to retrofit, and for anything carrying a justification it is the point of the feature.

**The line to hold, and to state on the admin screen.** Extra fields are for local context Compass does not model. A field that starts carrying governance weight — a "Reviewed?" competing with recertification, an "Owner" competing with business roles — is a signal to build the real feature, not to keep the field.

Scope here: the definition machinery, the admin screen, and values on **groups**. Other object types and reporting stack behind this.