---
id: 01M7Q3F853DZ9QPY9ZEFEW7YRE
created: 2026-11-18T10:33:05.443474Z
updated: 2026-11-18T10:33:05.443474Z
type: memo
title: Employment contract review against the ten-year plan
category: career
scope: personal
project: 01M5DGVQF9WDNP89TXCARSYJ97
---
Reviewed 18 Nov 2026. Source: `career/reference/moneypenny-contract-2019.pdf`, Callitech Limited t/a Moneypenny, dated 5 Nov 2019, Infrastructure & Operations Manager, £65k, start 3 Feb 2020. Not legal advice. Caveat: this may not be the operative contract. Steve is now Head of Infrastructure and Cyber Security at £110k; a promotion contract or variation letter may exist with stricter IP, outside-interest or restrictive terms, and clause 13.3 lets Moneypenny make "reasonable changes". The non-contractual Working Life @ Moneypenny document (clause 1.3) may also carry outside-interests, IP and equipment-use policies.

**What gets in the way**

1. **Clause 2.4, outside work needs written approval.** "You must notify the Working Life Team immediately of any other trade, business, occupation or profession you undertake or intend to undertake ... and approval for such activities must be obtained in writing." Forming the company (CAR-21), taking paid work (CAR-23) and releasing Compass commercially all fall under this. Approval must come before, not after. The standing assumption "outside work allowed if it does not interfere" was wrong; corrected in CLAUDE.md.
2. **No IP clause at all.** Nothing assigns inventions or copyright, and nothing carves personal projects out. The statutory default applies: s.11(2) CDPA 1988, employer owns work made in the course of employment. Silence does not help Steve; the "course of employment" test decides, and the facts in the vault point the wrong way: Compass's repo is in the Moneypenny-Development GitHub org, it is installed in Moneypenny's production AWS (release 0.1.0, Sept 2026), it runs Moneypenny's SOC 2 evidence and controls, and governance of infrastructure and cyber security is Steve's job. Penhallurick v MD5 found employer ownership on weaker facts. CAR-17 is therefore not a formality: the realistic outcomes are (a) Moneypenny confirms Steve owns it (unlikely without negotiation), (b) assignment to Steve with a perpetual free licence back to Moneypenny, or (c) Moneypenny keeps it and grants Steve a licence to commercialise, possibly with a revenue share. A solicitor should draft whichever is asked for.
3. **Clause 11, confidentiality, indefinite.** Anything in Compass that is Moneypenny's (its control library wording, policies, configs, client or supplier data, integration settings) must be stripped from any release. Case studies for the consultancy cannot use Moneypenny internals.
4. **Clause 8.5(b), delete on leaving.** On termination Steve must "irretrievably delete any information relating to the business of Moneypenny" held outside the premises. If Compass's code is treated as Moneypenny's, that clause reaches the repo and every copy. Another reason the IP position must be settled while employed, in writing.
5. **Clause 3, hours.** 37.5 hours, "additional hours as and when required", no overtime, and Moneypenny may change the pattern. No contractual right to reduce hours, so the hybrid scenario (S4, 0.6 FTE from 2029/30) depends on a negotiated variation. Statutory flexible-working request is available (two per year, employer must answer within two months) but can be refused on business grounds.

**What does not get in the way**

- **Clause 10 is narrow.** During employment and for 6 months after: no competing with Moneypenny's business (outsourced reception, live chat, PA services) to customers Steve personally dealt with, and no soliciting those customers. IT and security consultancy, and GRC software, are not Moneypenny's business, and 10.2.2 expressly allows work of a kind Steve was not concerned with. No general non-compete, no restriction on working for a competitor, no non-solicitation of staff. Only 10.1.3 bites: never present the consultancy as connected with Moneypenny beyond "former employee".
- **Notice.** Steve gives 1 month (8.2); Moneypenny gives 1 week per complete year, so about 6 weeks now rising to 11 by 2031 (8.1), with garden leave possible for the notice period (8.6). Leaving is cheap and quick. The flip side: job security is thin, so the employed-to-65 scenario (S1) rests on Moneypenny wanting him, not on contract.
- **Place of work** Wrexham (5.1), UK only (5.2). No issue.

**Decisions and sequence**

1. Find the current contract or promotion letter and the Working Life sections on outside interests, IP and equipment use (new task).
2. One letter, after solicitor review, that asks for both the IP position (CAR-17) and clause 2.4 approval for the consultancy and for releasing Compass (new task). Do not form the company or take paid work until the approval is in writing.
3. Keep Compass development, from now, on personal equipment, personal accounts and personal time, and keep a dated log; it will not fix the past but it bounds the future.
4. S4 (hybrid) now carries an extra dependency: a negotiated hours variation. Note it in the model's assumptions at the next October update (CAR-26).