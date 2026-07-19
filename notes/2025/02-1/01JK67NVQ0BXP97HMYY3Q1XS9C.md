---
id: 01JK67NVQ0BXP97HMYY3Q1XS9C
created: 2025-02-03T15:43:16.192Z
updated: 2025-02-05T17:10:27.335999Z
type: memo
title: Twingate Headless Client
---
03-02-2025 15:43

Tags: #aws #twingate


---
### Setup Router
The router will be used to forward on traffic via Twingate.

#### Configure Twingate
Create a service account in Twingate which the router will use.
Generate a key and make a note of the service token e.g.
```
{
  "version": "1",
  "network": "moneypenny.twingate.com",
  "service_account_id": "2cfbcc0d-cf37-446b-8b46-14e9e3e26a00",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQg0NBx7Z5SP/R49gCn\nAXveHFJwYB8VLTdLUzHXFLk+Y9ChRANCAAT6QW9Oa1P44yNsnBvEhcqTFQkV+Klr\nOC2aP5ZZYgA8ntwadLOiAXXMVG5tIcFj88kswcIA1g6GAxgsUhEnnlbi\n-----END PRIVATE KEY-----",
  "key_id": "_-Q4Jefez3oofgSmhzDW5a1iRcJ1Ajcd_a2SAmHn_Z8",
  "expires_at": "2026-02-03T15:47:38+00:00",
  "login_path": "/api/v4/headless/login"
}
```

Add the service account to the access list of the resource

#### Setup Twingate on the Router
Install the Twingate client
```
curl https://binaries.twingate.com/client/linux/install.sh | sudo bash
```

Create a file for the service key
```
nano /tmp/service_key.json
```
Paste the service token into the file and save it.

Setup the client in Headless mode and pass the token to it
```
sudo twingate setup --headless /tmp/service_key.json
```

Start Twingate
```
sudo twingate start
```

Enable IP Forwarding on the OS
```
sudo nano /etc/sysctl.conf
```
Uncomment the below line - net.ipv4.ip_forward=1
![[Pasted image 20250203164938.png]]
Save the file

Apply the changes
```
sudo sysctl -p
```

Update the OS routing table
```
sudo iptables --append FORWARD --in-interface enX0 --out-interface sdwan0 --jump ACCEPT
```
```
sudo iptables --append FORWARD --in-interface sdwan0 --out-interface enX0 --match state --state RELATED,ESTABLISHED --jump ACCEPT
```
```
sudo iptables -t nat --append POSTROUTING --out-interface sdwan0 --jump MASQUERADE
```

Make the changes persist
```
sudo apt install iptables-persistent -y
```










---

## References