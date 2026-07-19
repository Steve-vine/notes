---
id: 01GT7D4GXG05HQ1ZY1K4ZWX5MD
created: 2023-02-26T17:43:10Z
updated: 2023-02-26T18:42:33Z
type: memo
title: Setup Linux Bind Server
---
26-02-2023 17:43

Tags: #linux #bind #dns

# Setup Linux Bind Server

---
Install Bind and bind tools
```Bash
sudo apt install bind9 bind9-utils bind9-dnsutils -y
```

Check named is enabled
```Bash
sudo systemctl is-enabled named
```

Check named service status
```Bash
sudo systemctl status named
```

Configure named to run on IPv4 only
Edit the named config file
```bash
sudo nano /etc/default/named
```

Change the options line to read
```Bash
OPTIONS="-4 -u bind"
```

Configure Bind port and forwarders
Edit the options file
```Bash
sudo nano /etc/bind/named.conf.options
```

Add the below config below the Directory parameter
```Bash
// listen port and address 
listen-on port 53 { localhost; 10.0.0.1; }; 

// for public DNS server - allow from any 
allow-query { any; }; 

// define the forwarder for DNS queries (1.1.1.1 = Cloudflare)
forwarders { 1.1.1.1; }; 

// enable recursion that provides recursive query 
recursion yes;
```
Comment out the IPv6 Listener
```Bash
// listen-on-v6 { any; };
```

Check the bind configuration for error
```Bash
sudo named-checkconf
```

#### Setting up a DNS Zone

Edit the Bind config file
```Bash
sudo nano /etc/bind/named.conf.local
```

Add the forward and reverse zones for the domain (lab.local)
```Bash
zone "lab.local" {
    type master;
    file "/etc/bind/zones/forward.lab.local";
};

zone "0.0.10.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/reverse.lab.local";
};
```

Create the zones folder
```Bash
sudo mkdir -p /etc/bind/zones/
```

Copy default forward zone config to the folder
```Bash
sudo cp /etc/bind/db.local /etc/bind/zones/forward.lab.local
```

Copy default reverse zone config to the folder
```Bash
sudo cp /etc/bind/db.127 /etc/bind/zones/reverse.lab.local
```

Edit the Forward zone config
```Bash
sudo nano /etc/bind/zones/forward.lab.local
```

Replace the config with
```Bash
;
; BIND data file for the local loopback interface
;
$TTL    604800
@       IN      SOA     lab.local. root.lab.local. (
                            2         ; Serial
                        604800         ; Refresh
                        86400         ; Retry
                        2419200         ; Expire
                        604800 )       ; Negative Cache TTL

; Define the default name server to ns1.lab.local
@       IN      NS      ns1.lab.local.

; Resolve ns1 to server IP address
; A record for the main DNS
ns1     IN      A       10.0.0.1


; Define MX record for mail
lab.local. IN   MX   10   mail.lab.local.


; subdomains for lab.local
web01   IN      A       10.0.0.10
web02   IN      A       10.0.0.11
mail    IN      A       10.0.0.1
```

Edit the reverse zone config
```Bash
sudo nano /etc/bind/zones/reverse.lab.local
```

Replace the config with
```Bash
;
; BIND reverse data file for the local loopback interface
;
$TTL    604800
@       IN      SOA     lab.local. root.lab.local. (
                            1         ; Serial
                        604800         ; Refresh
                        86400         ; Retry
                        2419200         ; Expire
                        604800 )       ; Negative Cache TTL

; Name Server Info for ns1.lab.local
@       IN      NS      ns1.lab.local.


; Reverse DNS or PTR Record for ns1.lab.local
; Using the last number of DNS Server IP address: 10.0.0.1
10      IN      PTR     ns1.lab.local.


; Reverse DNS or PTR Record for mail.lab.local
; Using the last block IP address: 10.0.0.1
20      IN      PTR     mail.lab.local.
```

Check the main configuration for BIND
```Bash
sudo named-checkconf
```


Check forward zone forward.lab.local
```Bash
sudo named-checkzone lab.local /etc/bind/zones/forward.lab.local
```


Check reverse zone reverse.lab.local
```Bash
sudo named-checkzone lab.local /etc/bind/zones/reverse.lab.local
```

Restart named service
```Bash
sudo systemctl restart named
```

Verify named service
```Bash
sudo systemctl status named
```




---
## References