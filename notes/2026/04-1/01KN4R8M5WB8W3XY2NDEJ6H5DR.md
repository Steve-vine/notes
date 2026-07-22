---
id: 01KN4R8M5WB8W3XY2NDEJ6H5DR
created: 2026-04-01T14:48:21.43605922Z
updated: 2026-04-01T15:28:16.729218115Z
type: memo
title: Composio
imported_from: Obsidian
---
01-04-2026 15:48

Tags: 


---
**Rate Limits**

Just on the rate limits (2 x Average daily based only monthly average), that’s far too low, just adding a single customer could blow that in the early days.  But also having a defined monthly limit would mean we need to monitor it and then have a potential lead time to get that changed if we start getting low.  Might be better to stick with the daily usage average but increase that to 10x initially and review that as we onboard more clients. 

- ### TBD - 10x Average daily usage?
---
**SLAs**

On SLA, a more realistic target would be:

Critical issues

- Response 30 minutes (currently 1 hour)
    
- Resolution target 6 hours (currently 24 hours)
    

Non-critical

- 1 business day (currently 2 business days)
    
- Resolution target 2 business day (currently 5 business days) 
    

- ### TBD - Happy with above?
---
**Service Availability**

The section on service availability (99.9% target) and service credits is meaningless as it excludes:

- Third party service failures (Which is basically everything they offer)
    
- Denial of service attacks, hacking attempts, or other malicious activities
    

This makes me think that they don’t have any king of failover/DR capability, that’s a thing we should dig into, along with what were their “real” uptime figures for the past 24 months is you add in third party failures.

- ### What are actual uptime figures including 3rdP?
---
**GDPR**

We should push them on UK data processing.  They mentioned that they don’t ‘currently’ have this and the MSA states - _with regional options only available "where expressly made available."_

We could potentially say we would need this in place before the next renewal.  Otherwise, this will limit our ability to sell the service, for most of our bigger clients (particularly in the legal sector) non-EU data processing or storage is just a straight no.

Section 8.2 Transfer Mechanisms isn’t very clear, they mention the EU-US Data Privacy Framework, but it isn’t clear is they are certified under the DPF. The UK International Data Transfer Addendum is mentioned but there are no details.  I think we should ask for more details around what safeguards and controls are in place and how these are measured.

Section 5 says “Composio will notify Customer without undue delay after becoming aware of a breach “.  The GDPR requirement is 72 hours, suggest they should tell us within 48 hours .  It also says "customer bears responsibility for notifying the ICO and data subjects". There's no commitment on the minimum information Composio will provide to help us meet GDPR obligations.  It should say that Compose will provide a minimum content requirement aligned with Article 33(3) UK GDPR.

- ### When will UK data processing be available, and could we easily migrate?
- ### What safeguards and controls are in place around section 8.2?
- ### Composio will notify Customer without undue delay within 48 Hours after becoming aware of a breach
---
**Governance**

I’ve requested copies of their SOC2, ISO27001 reports and policies from their trust portal.

- ### Who completed the SOC2 accreditation (Through Delve/Accorp)?
---
**Other**

Section 16 says - "Composio may use Customer’s name/logo in customer lists and marketing. Customer may opt-out by notice to [tech@composio.dev](mailto:tech@composio.dev)”. We may or may not be happy with this.
- ### TBD - Are we happy with this?
---
Section 9 says - "Integrations depend on Third-Party Service availability and terms. Composio is not responsible for those services. Customer is responsible for its agents’ compliance with third-party terms and policies.” I read that as "If a connected service changes its API or terms and breaks our workflow, Composio is not liable and may not even be obligated to fix it.”  Maybe that’s just the nature of this kind of service but it feels fragile.

- ### TBD - Are we OK with this?

