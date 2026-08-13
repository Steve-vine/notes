---
id: 01KZ3Q91TGZQG9F5C2GAH6XTTZ
created: 2026-08-03T11:48:50.640104Z
updated: 2026-08-13T19:00:01.743662Z
type: task
title: Evidence from a pack
project: 01KX671DATY39VW6GWK3M2T3DN
number: 505
sprint: syte7bx
comments:
- id: 01KZG6KB3WSGN7R5EWAE68FPV8
  author: Steve Vine
  at: 2026-08-08T08:07:29.660054Z
  text: |-
    Done — PR #541 (branch feature/ise-505-pack-evidence).

    A pack's `evidence:` queries become the integration's evidence catalogue, usable in incident investigation and over MCP, on the same `evidence_catalogue`/`fetch_evidence` contract every connector implements.

    **Landed IN `ise.pack/v1`, additively** — a pack written before this parses unchanged, because the section is optional and no existing field changed. That's what `apiVersion` was introduced to make possible; burning a major version on a purely additive section would teach pack authors to fear upgrades for no reason. ADR 0094 §7 (which reserved evidence for Packs II) gets an **amendment block** rather than a rewrite, per the append-only rule.

    Three decisions the implementation forced, none of which §7 anticipated:

    1. **Core generates the parameter schema; the author does not supply it.** A query declares a small closed shape — name / description / `location: path|query` / `required` / `type` — and core turns that into the JSON Schema the agent drafts against. Letting a pack ship raw JSON Schema would hand the agent a surface core never validated, and the whole point of ADR 0031 §3's self-describing catalogue is that what the agent is *told* and what the server *enforces* are the same thing. Undeclared parameters are refused at fetch time, not merely discouraged by `additionalProperties: false`.

    2. **Parameterised paths are substitution, not templating** — and this is the security-critical bit of the sprint, because it's the *only* point in the whole pack story where a caller-supplied value reaches a URL. Placeholders are enumerated at install time; each must be backed by a declared `location: path` parameter, and the reverse too (an unslotted path parameter would be silently dropped and the query would fetch the wrong thing). At call time the value goes through `quote(..., safe="")`, which encodes `/` as well — so a value cannot add a path segment, climb out of one, or reach a different endpoint of the source. No expression language is reopened: the substituted value comes from a schema-validated argument, not from the document.

    3. **A parameterised endpoint cannot feed an `entities`/`alerts` mapping or the health probe.** Sync has nobody to ask for the argument, so the request would go out with a literal `{widget_id}` in the URL. Caught at upload, not discovered as a 404 on the integration's card.

    Bounded and it **says** so (ISE-53): one page only, capped by item count and serialised size, truncation reported in the summary. An agent reading forty rows of a thousand will reason confidently about the forty — silent truncation is worse than truncation. Over-long payloads are halved by whole records rather than byte-sliced, so what survives is still readable JSON.

    Still no action catalogue and no path to one. Evidence widens what can be *asked*, never what can be *done* — the same line ADR 0031 §5 drew for the generic MCP Type.

    13 new tests. One worth recording: my first encoding assertion read `httpx.URL.path`, which percent-**decodes** for display — it would have passed while proving nothing about what went on the wire. The assertions now read `str(request.url)`. Also carried forward the ISE-501 lesson: the stray-brace check started as a model validator reporting at `endpoints[2]` and became a field validator reporting at `endpoints[2].path`.

    Brief updated with the full `evidence` section and the parameterised-path rules, so ISE-508 can be authored against it.
assignee: steve
label: null
priority: medium
task_status: done
tech: null
---
Pack-declared parameterised read queries surface as the integration's evidence catalogue (name + description + JSON Schema params, same shape as `evidence_catalogue()`), usable in incident investigations and over the MCP surface. Degrades to `EvidenceResult(ok=False)` on failure like any connector.