---
id: 01M02H33C1ET6AC6CQ2KZVJJ8S
created: 2026-08-15T10:57:11.55376Z
updated: 2026-08-15T17:17:23.299539Z
type: task
title: The entity picker accepts any entity and never says the choice outlives the incident
project: 01KX671DATY39VW6GWK3M2T3DN
number: 732
sprint: sevhjex
comments:
- id: 01M02X6J5KRW6JWV2XH1HXG5SJ
  author: Steve Vine
  at: 2026-08-15T14:28:47.923634Z
  text: |-
    Done — PR #680, merged to main 2026-08-15. All four scope items.

    **1. The sanity check is the estate's own history, not a hand-written table.** A kind → allowed-type map would be wrong the day a connector grows a new signal kind and nobody would notice. `signal_subject` asks instead: *what has this signal's own system ever been about?* — the types it has **discovered** (its aliases) plus the types its signals have been linked to **automatically**. Human pins are excluded, or a wrong pin becomes the evidence that the next identical pin is fine.

    Including automatic links makes it **self-correcting**: DataDog creates only host entities here but its monitors legitimately concern workloads, and the first monitor that resolves to one teaches the rule. A system with **no** history gets no opinion at all — that is what keeps Status Pages, the webhook system and ISE Estate silent.

    **Measured against staging before writing it.** Across 2,243 entity-linked signals it fires **twice**, both human pins:

    ```
     name    | connector | type     | kind                  | pinned
    ---------+-----------+----------+-----------------------+--------
     EntraID | entraid   | cluster  | app-credential-expiry | t
     datadog | datadog   | workload | monitor_alert         | t
    ```

    Zero automatic links trip it. An earlier draft using discovery alone fired **292** times, almost all ISE's own `estate_drift` observations on load balancers — which is what sent me looking for the auto-link half.

    Worth noting: EntraID discovers `app-registration, identity-group, policy, user` and nothing else, so all four bad attachments in your audit would have warned.

    **2. Scope stated at the point of use**, with the durable one now visibly a different act — pin icon, its own heading, and *"saved on the **signal**, not this incident… to say something was caught up in **this** outage only, use Also affected below"*. That covers scope items 2 and 3 together, since they are the same problem seen twice.

    **3. A warning, never a block**, as you specified — phrased as what the integration DOES describe, because that is the sentence that lets an operator spot their own mistake. Attaching anyway records the caution in the audit, so a pin made against the advice is findable; after the fact a wrong pin is otherwise indistinguishable from a right one.

    **4. A pinned subject now says so on the signals surface**, not just the incident.

    **Still outstanding, and it is data not code:** the three live test pins need clearing on staging. I have not touched them — clearing is a deliberate act on production-shaped data and it is a one-click repair in the UI now that the pins are visible on the signal.

    Two test traps worth recording: `datadog` is **not a source of record**, so a fixture that discovers through it silently creates nothing and the test fails with a confusing `KeyError`; and the existing frontend stub's `includes('/api/v1/findings/f-1/entity')` swallowed the new `entity-fit` GET, surfacing as a phantom empty POST in an unrelated assertion.
assignee: steve
label:
- improvement
priority: high
task_status: done
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