---
id: 01M2RCVTM0JG830M5D8DA9P89Q
created: 2026-09-17T19:18:00.064849Z
updated: 2026-09-19T14:15:28.91816Z
type: memo
title: Draytek Support ticket
tech:
- Draytek
---
Hi

I purchased the Vigor 2867be and 2x VigorAP1070C AP's last week and have recently set them up with the AP's as a wireless mesh. Since commissioning, I have been experiencing multiple reboots or the router, generally up to 10 times per day but often clustered. I updated the router to the latest firmware at the time of installation (5.4.4) then once I noticed the issue rolled back to 5.4.3.1 then 5.4.4.1 when that was released and all versions have had the same issue. The AP's have been on 5.1.0 and  5.1.1 during the issue.

Initially the restarts happened during DFS Radar events:
2026-09-16 16:06:12 BST  [RDM]: Radar detected !!!!!!!!!!!!!!!!!
2026-09-16 16:06:12 BST  [DFS] Radar detected!!! (Current Channel 116)
2026-09-16 16:06:18 BST  [dmn] (5G) DFS cac detection is in progress. Waiting...
2026-09-16 16:06:18 BST  [DFS] Normal start. Enable MAC TX
2026-09-16 16:25:51 BST  [dmn] (5G) DFS cac detection is in progress. Waiting...
2026-09-16 16:25:53 BST  [DFS] Normal start. Enable MAC TX
I pinned the 5GHz to channel 36 and haven't seen any radar events since but I'm still seeing the reboots.

Remote syslog capture shows that each reboot is accompanied by one or more firmware processes terminating with signal 11 (SIGSEGV) and generating a coredump — specifically the wireless daemon wapp and the MQTT broker mosquitto. In a single recent window, the router cold-booted 6 times in 1 hour 48 minutes (16:39–18:27 BST, 17 Sep 2026), with intervals tightening toward the end — i.e. the problem is escalating, not occasional.

Across those 6 reboots:
wapp (wireless daemon) segfaulted in 6 of 6 reboots (100%)
mosquitto (MQTT broker) segfaulted in 4 of 6 reboots (67%)
All crashes are SIGSEGV (signal 11), each generating a coredump.

I have plaintext remote syslog covering the crashes and an encrypted debug/coredump export from the router, available.
Representative crash excerpt (first event in the cluster):
2026-09-17T16:39:21  sysklogd v2.4.0: restart.
2026-09-17T16:39:23  Coredump was generated, and (mosquitto loop) terminated with signal (11) !
2026-09-17T16:39:25  System clock wrong by 132.493408 seconds
2026-09-17T16:39:25  System clock was stepped by 132.493408 seconds
2026-09-17T16:39:32  Coredump was generated, and (wapp) terminated with signal (11) !
2026-09-17T16:39:37  sysklogd v2.4.0: restart.

Many thanks

Steve

---
### Submission response
Your technical query has been submitted; it will be allocated to a support technician.

Your reference number is 457636

We will reply to you at as soon as possible.

We do reply to all valid support requests, typically within 24 hours (exc. weekends), although during busy periods, it can take longer. If you have not received any response within 2 days, please email us but please check any anti-spam measures/folders.

If your query is not post-sales tech support or you are outside the UK/Ireland/CI then your query will not be passed to a UK post-sales technician.

For technical support outside of the UK/Ireland, please email to support@draytek.com.

For UK pre-sales queries, please email to info@draytek.co.uk


---

Settings
IP: 192.168.1.1

