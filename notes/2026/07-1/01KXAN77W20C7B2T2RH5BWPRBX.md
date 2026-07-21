---
id: 01KXAN77W20C7B2T2RH5BWPRBX
created: 2026-07-12T07:56:11.522048365Z
updated: 2026-07-21T16:49:43.030729Z
type: task
title: Phase 3 exit test — scheduled AI analysis produces an evidenced Issue
project: 01KX671DATY39VW6GWK3M2T3DN
number: 43
sprint: syv1q8m
blocked_by:
- 01KXAN69WYA8JMKQ2RC69CEMAP
- 01KXAN6FR3SF2G2SGM56A419Z7
- 01KXAN6KNK5VX3WR8R69Q2C9G0
- 01KXAN6PK9DRP6D3CSMRNZB0FB
- 01KXAN6SH66338KMEH39WG35K8
- 01KXAN6Y3SZ1BPMCR7ZWDJVHHQ
- 01KXAN71BBPTMMVGD9BNTCDSWB
- 01KXAN748N21T1VRN0ZFAZGK2W
comments:
- id: 01KXBJY3G2K6XVKCJRTXZ8A2D5
  author: Steve Vine
  at: 2026-07-12T16:35:29.410496515Z
  text: |-
    PHASE 3 EXIT TEST: PASSED (all three legs), on staging, against real infrastructure.

    Setup: deployed a deliberately broken workload to g5 — payments-api in ns ise-acceptance, image nginx:v99-does-not-exist, so the kubelet can never pull it. Then touched nothing: the exit criterion is that the SCHEDULED pipeline catches it.

    LEG 1 — scheduled analysis produces a correct, evidenced Issue. PASS.
    The 30-min analyse dispatch fired unaided at 16:32:07 (run dbbf862f, claude-opus-4-8, 10.6k in / 1.4k out, $0.087) and raised:
      [high] "Deployment ise-acceptance/payments-api down: 0/2 replicas ready due to ImagePullBackOff" (confidence 0.97)
    It names the image-pull failure SPECIFICALLY — the bar set in advance was that restating "a workload is unhealthy" would be a miss. Evidence cites the native unhealthy_workload finding, the workloads slice (ready=0/desired=2), both pending_pod findings by pod name, and the two k8s_event ImagePullBackOff findings with timestamps. Correct root cause: "likely a bad/inaccessible image reference".

    LEG 2 — the agent-run viewer explains WHY. PASS.
    Transcript records the tool calls in order: get_state_slices -> list_open_findings -> get_slice_payload(workloads) -> (nodes) -> (config) -> (namespaces) -> final_result. Readable in the Agent runs UI.

    LEG 3 — Claude<->OpenAI switch is config-only. PASS.
    summarise-state flipped to openai/gpt-4o in Settings at 15:47:56. The next SCHEDULED run at 15:54:34 executed on gpt-4o for both systems (g5 $0.0030, datadog $0.0038), succeeded. No redeploy, no restart, no code change — a row update in ai_model_config. ADR 0013's model-agnostic claim demonstrated against two live providers.

    BUG FOUND AND FIXED (ISE-45, high, now on main): the broken workload immediately wedged sync for the WHOLE g5 system for ~25 minutes — no state, no findings. Kubernetes emits two distinct `Failed` events for one image-pull failure, both collapsing to the same finding source_key; _upsert_findings inserted a duplicate row and the UniqueViolation aborted the shared transaction. One broken pod blinded ISE to the entire cluster. Latent since Phase 2 — no synthetic fixture ever produced two events sharing one key. This is the argument for end-of-phase tests against live infrastructure.

    OBSERVATION for ISE-44: one broken workload produced 4 issues — 3 finding-promoted (mechanical, one per finding) + 1 AI (consolidating, with the root cause). Correct by design, but the signal-to-noise of promoted-vs-AI issues on the same problem is worth revisiting.
assignee: steve
label: null
priority: medium
task_status: done
---
Roadmap Phase 3 exit test, on staging. Deploy a deliberately broken workload (crash-loop pod, as the Phase 2 exit test) → scheduled analyse produces a correct, evidenced AI Issue (source='ai') within a cycle; the agent-run viewer explains WHY (transcript/tool-calls/outcome); flip a task type Claude↔OpenAI in Settings and confirm it is a config change only (OpenAI key already in env, no redeploy). Acceptance verification — no code PR (as ISE-19 Phase 1 / ISE-30 Phase 2). Needs an OpenAI API key provisioned in staging env.