---
id: 01KXAN77W20C7B2T2RH5BWPRBX
created: 2026-07-12T07:56:11.522048365Z
updated: 2026-07-12T07:57:07.136869263Z
type: task
title: Phase 3 exit test — scheduled AI analysis produces an evidenced Issue
priority: medium
task_status: backlog
assignee: steve
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
---
Roadmap Phase 3 exit test, on staging. Deploy a deliberately broken workload (crash-loop pod, as the Phase 2 exit test) → scheduled analyse produces a correct, evidenced AI Issue (source='ai') within a cycle; the agent-run viewer explains WHY (transcript/tool-calls/outcome); flip a task type Claude↔OpenAI in Settings and confirm it is a config change only (OpenAI key already in env, no redeploy). Acceptance verification — no code PR (as ISE-19 Phase 1 / ISE-30 Phase 2). Needs an OpenAI API key provisioned in staging env.