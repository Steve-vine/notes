---
id: 01KZTRPZ49HHVW5BAQTR789HKH
created: 2026-08-12T10:36:27.145896Z
updated: 2026-08-12T10:36:27.145896Z
type: memo
title: Anand Shiva Singh
meeting:
- Interview
---
Opening — career shape

You've spent most of your career at Cognizant before Deloitte — largely consultancy delivery across client engagements. This is a small in-house team owning Moneypenny's own platform for the long haul. What's pulling you toward that, and where do you expect the adjustment to be hardest?
Listening for: appetite for long-term ownership versus rotating off engagements before the consequences land. He's been at Deloitte since 2022, which is more continuity than pure project-hopping — worth acknowledging that and probing whether he stayed close to one platform or moved across accounts.

Security & DevSecOps — his strongest card, so press it hard

This is where Anand is genuinely differentiated (AWS Security Specialty + Azure Security Engineer, hands-on Trivy/Snyk/SonarQube/Checkov with severity gates). Don't just confirm he's done it — test the depth.

You've embedded Trivy, Snyk, SonarQube and Checkov with configurable severity gates. Walk me through how you set the thresholds. How do you stop a hard "block on critical" gate from either flooding engineers with noise or getting quietly bypassed?
The JD calls out the OWASP Top 10 CI/CD security risks specifically — which is different from the app-level Top 10. Which of those CI/CD risks do you think teams most often miss, and how have you defended a pipeline against it?
You claim "zero vulnerabilities reach production." That's a strong statement — how do you actually hold that line when a critical CVE lands in a base image or transitive dependency with no patch available? What's the process, not just the tool?
You implemented a WAF and cloud security guardrails. Tell me about a real security finding you traced through infrastructure — Terraform, IAM, live config — and remediated end to end.
Listening for: whether "DevSecOps" is a tool inventory or genuine threat-model understanding. Strong answers cover poisoned pipeline execution, compromised runners, over-privileged pipeline credentials, supply-chain/dependency risk — and the human problem of gates that engineers learn to rubber-stamp. Given Moneypenny's ISO 27001 / SOC 2 / GDPR / PCI DSS surface, this is the area where he could add the most, so it's worth the airtime.

Compliance in a regulated environment

Moneypenny carries ISO 27001, SOC 2, GDPR and PCI DSS. In a regulated financial-services context at Deloitte you'll have hit auditors — have you built delivery controls to satisfy one? Segregation of duties, auditable deployment trails, evidence collection — and how did you keep that from becoming a ticket queue that slows delivery?
Listening for: his Deloitte work was in "a regulated financial services environment" with Bedrock/Aurora/KMS — so he should have real exposure here. Test whether he operated the controls or sat adjacent to a compliance team who owned them.

Leadership — the step from mentoring to managing

Your CV says you mentored a team of 4. Tell me about that — were they your direct reports, or peers you guided technically? What did you actually own for them?
This role is different from mentoring: you'd be the lead for three engineers — their direction, their growth, and their underperformance. Have you managed people formally, and if not, why do you think you're ready for the step?
One of your three engineers keeps shipping work that's technically sound but consistently late, and it's straining the on-call rota. How do you handle it?
Listening for: the honest scope of that "team of 4." Mentoring four juniors on best practice is real but isn't line-management — you want him clear-eyed about the gap, not inflating it. The scenario tests instinct where formal experience may be missing.

GitOps — a genuine relative gap

Anand's GitOps evidence is lighter than Jiasong's or the Sairams' — he lists ArgoCD in skills and did Helm-based EKS, but his pipelines read more classic-CI/CD (Azure DevOps, Jenkinsfile) than GitOps-native. This is worth honest probing since it's central to how Moneypenny runs.

Our delivery model is Argo CD GitOps — declarative desired state in git, rollback is a git revert. How much have you run in a true GitOps model versus push-based pipelines? Walk me through repo structure, environment promotion, and how you handled secrets.
Where does GitOps get hard or break down, in your experience?
Listening for: whether he's genuinely operated GitOps or mostly done Azure DevOps release pipelines with ArgoCD bolted on. Either answer is usable — you just want to know honestly where he is, since he'd be ramping into it.

Fit with the Moneypenny stack

Your IaC is all Terraform. Ours is Crossplane-first — Kubernetes-native infra provisioned through GitOps. How do you get productive in an IaC paradigm you haven't used, and how would you avoid quietly steering our stack back toward Terraform because it's what you know?
You've built a lot of CI/CD across Azure DevOps and Jenkins. This role is about reducing tooling divergence, not adding to it. If you joined and found several competing pipeline systems, how would you decide what to standardise on, and how would you get engineers and dev teams to actually adopt it?
Listening for: intellectual flexibility over tool loyalty, and the JD's core competency — driving consistency and influencing adoption, not just having a technical opinion.

Breadth check — the data/analytics thread

A big chunk of your history is data-platform work — Azure Data Factory, Synapse, SAS-to-AWS, data lakes. This role is core platform/DevOps, not DataOps. Is that a direction you're deliberately moving away from, or something you'd want to keep a foot in?
Listening for: whether platform DevOps is genuinely where he wants to be, or whether he's a data-platform engineer applying broadly. Not disqualifying — but you want his centre of gravity to match the role.

Close

What would you change in your first 90 days — and, harder, what would you deliberately leave alone until you understood why it was built that way?
What do you want to ask me about the team, the platform, or how success is measured here?
Listening for: restraint in the first answer — a good lead resists rewriting everything on day one. His questions back to you often reveal more than his answers.

Two interviewer notes. First, spend the bulk of your time in the security section — it's where Anand is strongest and where Moneypenny has the most to gain, so it's worth confirming the depth is real rather than certification-deep. Second, be direct about the GitOps and Crossplane gaps rather than dancing around them; how he responds to "here's where you're light for us" is itself a useful signal about how he'll take feedback as a lead.

Want me to build a scoring sheet that rates his answers against the JD criteria, or line his security depth up head-to-head against the two Sairams so you can compare across the three after the interviews?