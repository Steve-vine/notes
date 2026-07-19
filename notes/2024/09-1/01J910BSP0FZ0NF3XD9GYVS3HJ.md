---
id: 01J910BSP0FZ0NF3XD9GYVS3HJ
created: 2024-09-30T08:22:16Z
updated: 2024-09-30T08:25:34Z
type: memo
title: Logs
---
30-09-2024 09:22

Tags: #datadog #api


---
### Query logs
```
curl -L -X POST "https://api.datadoghq.eu/api/v2/logs/events/search" -H "Content-Type: application/json" -H "DD-API-KEY: <api-key>" -H "DD-APPLICATION-KEY: <application-key>" --data-raw '{
	"filter": {
		"from": "2024-09-27T00:00:00+00:00",
		"to": "2024-09-27T00:15:00+00:00",
		"query": "*"
	}
}'
```

---
## References

Datadog documentation - Log Management
[Log Search Syntax (datadoghq.com)](https://docs.datadoghq.com/logs/explorer/search_syntax/)
