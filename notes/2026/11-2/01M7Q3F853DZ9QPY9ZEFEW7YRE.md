---
id: 01M7Q3F853DZ9QPY9ZEFEW7YRE
created: 2026-11-18T10:33:05.443474Z
updated: 2026-11-18T10:41:04.800794Z
type: memo
title: Employment contract review against the ten-year plan
project: 01M5DGVQF9WDNP89TXCARSYJ97
category:
- career
scope:
- personal
---
Reviewed 18 Nov 2026. Source: `career/reference/moneypenny-contract-2019.pdf`, Callitech Limited t/a Moneypenny, dated 5 Nov 2019, Infrastructure & Operations Manager, £65k, start 3 Feb 2020. Not legal advice. Caveat: this may not be the operative contract. Steve is now Head of Infrastructure and Cyber Security at £110k; a promotion contract or variation letter may exist with stricter IP, outside-interest or restrictive terms, and clause 13.3 lets Moneypenny make "reasonable changes". The non-contractual Working Life @ Moneypenny document (clause 1.3) may also carry outside-interests, IP and equipment-use policies.

**What gets in the way**

1. **Clause 2.4, outside work needs written approval.** "You must notify the Working Life Team immediately of any other trade, business, occupation or profession you undertake or intend to undertake ... and approval for such activities must be obtained in writing." Forming the company (CAR-21), taking paid work (CAR-23) and releasing Compass commercially all fall under this. Approval must come before, not after. The standing assumption "outside work allowed if it does not interfere" was wrong; corrected in CLAUDE.md.
2. **No IP clause, so the statutory test decides, and it is narrower than "Moneypenny owns what Steve makes".** s.11(2) CDPA 1988 gives the employer copyright only in work made "in the course of employment". Work that is merely in the employee's field, or made with the employer's facilities, is not enough: in Noah v Shuba [1991] FSR 14 a consultant's guide written in his own field, partly on his employer's equipment, stayed his because writing it was not what he was employed to do; in Stevenson Jordan & Harrison v MacDonald & Evans [1952] 1 TLR 101 the parts of a book an engineer wrote on his own initiative stayed his, the parts written as a job deliverable did not. The factors (Mei Fields Designs v Saffron Cards [2018] EWHC 1332 (IPEC), applied in Penhallurick v MD5 [2021] EWHC 293 (IPEC), upheld [2021] EWCA Civ 1770): the contract terms; whether making the work is the kind of task the employee is paid for; who initiated it; where and when it was made; whether the employer paid for or directed it; the employer's use and knowledge; later conduct. Penhallurick lost mainly because writing that software was "the central task" he was paid for, and separately because he had signed a 2008 agreement assigning it. Home working and own-time were weighed and did not save him, but they were not irrelevant.
   - Points for Steve: he is not employed as a software developer; nobody at Moneypenny commissioned a GRC platform (Moneypenny pays Carbide Secure for that); the contract claims nothing; if Compass began on his own initiative, own kit and own time, that is close to Noah's position.
   - Points against: Compass is a tool for doing exactly what he is paid to do (governing Moneypenny's security and compliance); the repo lives in the Moneypenny-Development GitHub org; it runs in Moneypenny's production AWS at Moneypenny's cost; it carries Moneypenny's SOC 2 evidence; any work done in working hours or presented internally as a work deliverable counts against him.
   - The deciding facts, to establish before any letter: when the first commit was and where; what fraction was written in working hours; whether any Moneypenny colleague contributed code; whether a manager asked for it or accepted it as a deliverable; whether the Head role description includes building tooling; whether Moneypenny has paid anything beyond hosting. Regardless of who owns the Compass code, the deployment repo, Moneypenny's configuration, policies, control wording and data are Moneypenny's and come out of any release.
   - Realistic outcomes: (a) Moneypenny confirms the code is Steve's personal project used under a licence, the right ask if the facts support it; (b) assignment to Steve with a perpetual free licence back; (c) Moneypenny keeps it and licenses Steve to commercialise. A solicitor drafts whichever the facts justify.
3. **Clause 11, confidentiality, indefinite.** Anything in Compass that is Moneypenny's (its control library wording, policies, configs, client or supplier data, integration settings) must be stripped from any release. Case studies for the consultancy cannot use Moneypenny internals.
4. **Clause 8.5(b), delete on leaving.** On termination Steve must "irretrievably delete any information relating to the business of Moneypenny" held outside the premises. Even if the code is Steve's, Moneypenny's configuration and data inside it are caught; if the code were held to be Moneypenny's, the clause reaches every copy. Settle the position while employed, in writing.
5. **Clause 3, hours.** 37.5 hours, "additional hours as and when required", no overtime, and Moneypenny may change the pattern. No contractual right to reduce hours, so the hybrid scenario (S4, 0.6 FTE from 2029/30) depends on a negotiated variation. Statutory flexible-working request is available (two per year, employer must answer within two months) but can be refused on business grounds.

**What does not get in the way**

- **Clause 10 is narrow.** During employment and for 6 months after: no competing with Moneypenny's business (outsourced reception, live chat, PA services) to customers Steve personally dealt with, and no soliciting those customers. IT and security consultancy, and GRC software, are not Moneypenny's business, and 10.2.2 expressly allows work of a kind Steve was not concerned with. No general non-compete, no restriction on working for a competitor, no non-solicitation of staff. Only 10.1.3 bites: never present the consultancy as connected with Moneypenny beyond "former employee".
- **Notice.** Steve gives 1 month (8.2); Moneypenny gives 1 week per complete year, so about 6 weeks now rising to 11 by 2031 (8.1), with garden leave possible for the notice period (8.6). Leaving is cheap and quick. The flip side: job security is thin, so the employed-to-65 scenario (S1) rests on Moneypenny wanting him, not on contract.
- **Place of work** Wrexham (5.1), UK only (5.2). No issue.

**Decisions and sequence**

1. Establish the Compass facts above (timeline, equipment, hours, contributors, who asked) and write them down with evidence; this decides which letter to send.
2. Find the current contract or promotion letter and the Working Life sections on outside interests, IP and equipment use (CAR-27).
3. One letter, after solicitor review, that asks for both the IP position (CAR-17) and clause 2.4 approval for the consultancy and for releasing Compass (CAR-28). Do not form the company or take paid work until the approval is in writing.
4. Keep Compass development, from now, on personal equipment, personal accounts and personal time, and keep a dated log; it will not fix the past but it bounds the future.
5. S4 (hybrid) now carries an extra dependency: a negotiated hours variation. Note it in the model's assumptions at the next October update (CAR-26).