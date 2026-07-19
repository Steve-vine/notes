---
id: 01HMNZW0A3VXQ5V8E66K2991KQ
created: 2024-01-21T12:28:03.267Z
updated: 2024-01-22T12:24:23.433Z
type: memo
title: Flush DNS
---
21-01-2024 12:28

Tags: #terminal


---
# Flush DNS
```
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
```
# Create bcrypt password
```
htpasswd -c -b [path_to_htpasswd_file] [username] [password]
```

---
## References