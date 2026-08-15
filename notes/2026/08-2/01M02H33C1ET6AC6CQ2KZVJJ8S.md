---
id: 01M02H33C1ET6AC6CQ2KZVJJ8S
created: 2026-08-15T10:57:11.55376Z
updated: 2026-08-15T10:57:21.331413Z
type: task
title: The entity picker accepts any entity and never says the choice outlives the incident
project: 01KX671DATY39VW6GWK3M2T3DN
number: 732
sprint: sevhjex
assignee: steve
label:
- improvement
priority: high
task_status: backlog
tech: null
---
Found on the estate view for `mpwxdc01`, 2026-08-15: the host showed an active alert and an open incident for signals that have nothing to do with it. Traced to test attachments made on 2026-08-14 while exercising ISE-691, still live a day later.

**Two controls sit on the Impact panel, they look alike, and their blast radii are completely different.**

- **"Also affected"** (`IssueAffectedEntity`, ISE-691) is **incident-scoped** and its model says so at length: *"an operator saying 'this is affected' during an outage is making a claim about this event"*. It dies with the incident. This is the right tool for "these two were related just this once".
- **The entity picker in the unlinked state** sets `finding.entity_id` and stamps `entity_pinned_by`. It is **signal-scoped and durable**, per ISE-639: *"On the FINDING, not the incident: the answer then holds for every incident this signal goes on to raise."* A pin also makes the row authoritative — `link_findings_to_entities` leaves it alone — so it never self-corrects.

Nothing at the point of clicking distinguishes them. The operator is standing on an incident, picks an entity, and reasonably assumes the choice applies to that incident.

**What the audit shows.** One EntraID signal — *"secret on app registration MoneypennyDynamics_Sandbox expired"* — attached four times in six minutes:

```
08:27:16  → mpwxdc01 (host)
08:28:14  → mpwxdatawh (host)
08:30:55  → cluster-envstaginguk-ekscluster (cluster)
08:32:43  → mpwxdc01 (host)          ← never cleared
```

An EntraID app-registration credential expiry was bound to two Windows hosts and an EKS **cluster**, and ISE accepted every one without a murmur.

**Scope**

1. **Sanity-check the pairing.** Warn — not block — when a signal's kind has no plausible relationship to the entity's type. `app-credential-expiry` on a `host` or a `cluster` is the worked example. A warning, because the estate is messier than any rule, and a hard refusal would eventually be wrong about a legitimate case.

2. **State the scope at the point of use.** The picker must say what it is doing: *this records what the signal is about, and applies to every incident it raises from now on* — not just this one. Today that fact lives only in a backend docstring.

3. **Make the two controls visibly different.** One is a claim about the estate that outlives the incident; the other is a note about one event. They should not read as two spellings of the same act.

4. **Surface a pinned entity as pinned**, wherever it is shown. `entity_pinned_by` is already on the read model and displayed on the incident (ISE-691); a signal carrying a human's choice should be identifiable as such on the estate and signals surfaces too, so a wrong pin is findable rather than only discoverable by accident.

**Why it matters beyond tidiness.** A pin is durable, authoritative and invisible once made — the failure mode is that nobody notices, because a wrong subject looks exactly like a right one. Since ISE-697, stated impact also feeds the AI's working context, so a mis-pinned signal quietly becomes wrong context for every future question about that entity.

**Cleanup, separately from the fix:** three live test pins remain — IN-1333 (EntraID secret → mpwxdc01 host), IN-1294 (Kora frontend error spike → mpwxdc01 host), IN-1279/1229 (Kora synthetics → openanswer namespace). Clearing works and is the repair.

Related: ISE-696 made the picker say *which* entity; this is about whether it should be that entity at all, and for how long.