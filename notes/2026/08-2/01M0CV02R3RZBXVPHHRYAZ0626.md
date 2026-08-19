---
id: 01M0CV02R3RZBXVPHHRYAZ0626
created: 2026-08-19T11:02:42.691375Z
updated: 2026-08-19T11:02:42.691375Z
type: memo
title: Clear mail send flag for Rita Message Queue
company:
- moneypenny
tech:
- SendGrid
- Rita
- MessageCentre
---
```
UPDATE cSET c.Confirmed = 'False'FROM dbo.Calls cWHERE EXISTS (     SELECT 1FROM dbo.EmailMessageStatus ems     WHERE ems.CallID = c.CallID       AND ems.[At] >= '2026-08-14 20:40:00'AND ems.RawStatus = 'Bounce'AND ems.FailureReason LIKE '550 5.7.511 Access denied%’
```