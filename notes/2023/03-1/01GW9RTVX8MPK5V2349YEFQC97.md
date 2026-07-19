---
id: 01GW9RTVX8MPK5V2349YEFQC97
created: 2023-03-24T12:17:29Z
updated: 2023-03-30T19:33:58Z
type: memo
title: Integrating Juju with MAAS
imported_from: Obsidian
---
juju24-03-2023 12:17

Tags: #juju #maas


---
https://juju.is/docs/olm/maas

Begin an interactive session
```bash
juju add-cloud --local
```

Give the cloud a name

Provide the MAAS endpoint e.g.
```Bash
http://192.168.3.11:5240/MAAS
```

Confirm that the cloud has been added
```Bash
juju clouds --local
```

Add credentials
```bash
juju add-credential <CloudName>
```

Give the creds a name e.g. cloudname-creds

Paste in the MAAS API key which can be found in user preferences

Confirm credentials are added correctly
```Bash
juju credentials
```

```Bash
juju credentials --local
```

Bootstrap a new controller
```Bash
juju bootstrap maas-cloud
```


---
## References