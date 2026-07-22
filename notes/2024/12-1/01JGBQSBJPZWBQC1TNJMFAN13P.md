---
id: 01JGBQSBJPZWBQC1TNJMFAN13P
created: 2024-12-30T12:13:54.646999955Z
updated: 2025-08-14T19:03:34.279Z
type: memo
title: 2025 Strategy
imported_from: Obsidian
---
30-12-2024 12:13

Tags: 


---
### Roadmap
Sunshine Migration (Domains and Email) - January
Finance Audit
Cyber Essentials Plus
Decommision DR Site
Azure Cost Review
Automated Patch Management (Automox)
Email security upgrade (Abnormal / Mimecast M365) - February 
EDR (Defender or SentinelOne) - March
Proxmox / Veeam enrollment

Rebalance DR Laptops to 300
Replace Hyper-V servers
Replace monitors for use with OpenRita


Objective
Deploy OpenRita on scalable resilient infrastructure in the UK and US.

Key Results
Repeatable Infrastructure as Code process created to deploy OR environment into production and non-production accounts.
CI/CD Pipeline setup using Argo Workflows and Deployment, including testing and deployment logic.
Monitoring and alerting in place to detect and alert on anomalies within the production system.
Load tests completed, confirming that the system can cope with full production load and is able to scale up to at lease 200% current capacity.

Objective
Sunshine Migrated into Moneypenny organisation

Key Results
All legacy systems made secure and safe until they can be decommissioned
Strategic assets, such as domain names, brought into Moneypenny management systems
Email migrated into Moneypenny main email systems

Objective
Deploy automated patch management system

Key Results
All managed workstations across the group managed through central patch management system
All Windows servers across the group managed through central patch management system
All Linux servers across the group managed through central patch management system

Objective
Increase security capability of email systems to ensure they can cope with current known threats

Key Results
Identify, procure, and deploy best-in-class email systems to compliment existing security toolset.
Migrate all existing users and email processes into new email security tooling.
Ensure reporting metrics are available to determine and constantly improve the accuracy and capability of the email security systems.

Objective
Deploy Chinwag AI on scalable resilient infrastructure in the UK and US.

Key Results
Repeatable Infrastructure as Code process created to deploy OR environment into production and non-production accounts.
CI/CD Pipeline setup using Argo Workflows and Deployment, including testing and deployment logic.
Monitoring and alerting in place to detect and alert on anomalies within the production system.
Load tests completed, confirming that the system can cope with full production load and is able to scale up to at lease 200% current capacity.








### Focus on Areas
Reliability
	Reduce time to recover from failures
		Document systems
		Automate deployments
	Improve observability of performance and anomaly detection
		Increase synthetic monitoring 
		Include application metrics
		build more intelligent monitors and alerts
	Improve disaster recovery capability
		Improve documentation of systems
		Identify and document current recovery capability
		Identify and implement improvements 
	Reduce Complexity	
		Reduce technology footprint and consolidate on core tech
		Standardise CI/CD Pipelines across products
Security
	Separation of production and non-producion environments
		Migrate workloads into dedicated production and non-production accounts
		Build dedicated non-production infrastructure where it doesn't currently exist
		Agree and implement access controls and change management processes
	Improve vulnerability and risk management
		Identify and document current threats
		Document and track security risks
		Implement ongoing processes to identify, report and track vulnerabilities based on risk
	Improve access control to systems and assets
		Review and assess current access rights and agree roles and responsibilities
		Implement JIT processes for gaining access to systems
	Improve detection and removal of email based threats
		Extend scanning to internal email
		Implement AI based capability for detection and removal of malicious content
Value
	Reduce time to deploy
		Automate deployment processes
	Increase repeatability
		Develop a consistent approach to system design and implementation
	Reduce management overhead
		Reduce the number of systems providing duplicate functions
	Prioritise work based on greatest benefit
		Implement processes to track, rate and prioritise identified improvements
		Provide greater visibility of work pipeline
	Improve visibility of costs
		Consolidate cost reporting into one place
		Allocate costs based on product and usage
		Create greater visibility of tech costs
		Adopt a consistent approach to system reservation and economies of scale 
Performance
	Implement auto-scaling
		Identify systems with variable usage demands and implement auto-scaling capability
	Identify and remove bottlenecks
		Identify system constraints and develop improvements
Simplicity
	Remove complexity
	Keep solutions simple, don’t over engineer 




### Strategic Approach
Document all supported systems
Automate repeat processes
Build service based monitoring
Create business continuity procedures
Reduce Complexity


---
## References