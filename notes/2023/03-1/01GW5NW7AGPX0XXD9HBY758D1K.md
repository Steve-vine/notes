---
id: 01GW5NW7AGPX0XXD9HBY758D1K
created: 2023-03-22T22:08:50Z
updated: 2023-08-30T06:41:03Z
type: memo
title: Setup SSH Keys on Remote Server
imported_from: Obsidian
---
22-03-2023 22:09

Tags: #ssh 


---
https://www.cloudpanel.io/tutorial/set-up-ssh-keys-on-ubuntu-20-04/

## Generate the keys

On the client computer generate a new key pair
```Bash
ssh-keygen
```

Show the public key
```Bash
cat ~/.ssh/id_rsa.pub
```

## Copy public key to server (ssh-copy-id - Linux)

```Bash
ssh-copy-id -i ~/.ssh/id_rsa.pub steve@192.168.3.11
```

## Copy public key to server (Powershell - Windows)

```Bash
type $env:USERPROFILE\.ssh\id_rsa.pub | ssh steve@192.168.3.12 "cat >> .ssh/authorized_keys"
```

## Manually copy the key to the server

Add the key to the authorized_keys file
```Bash
echo {string} >> ~/.ssh/authorized_keys
```

Remove all 'group' and 'other' permissions from the key
```Bash
chmod -R go= ~/.ssh
```

Make sure the key is owned by you
```Bash
chown -R steve:steve ~/.ssh
```

---
## References