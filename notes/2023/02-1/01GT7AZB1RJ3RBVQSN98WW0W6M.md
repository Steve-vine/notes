---
id: 01GT7AZB1RJ3RBVQSN98WW0W6M
created: 2023-02-26T17:05:23Z
updated: 2023-02-26T17:19:23Z
type: memo
title: Setup Linux DHCP Server
---
26-02-2023 17:05

Tags: #linux #dhcp

# Setup Linux DHCP Server

---
Install the DHCP Service
```Bash
sudo apt install isc-dhcp-server
```

Create a backup of the default config file
```Bash
sudo mv /etc/dhcp/dhcpd.conf{,.backup}
```

Edit config file
```Bash
sudo nano /etc/dhcp/dhcpd.conf
```

Example config
```Bash
default-lease-time 600;
max-lease-time 7200;
authoritative;
 
# DHCP Scope
subnet 10.0.0.0 netmask 255.255.255.0 {
    range 10.0.0.20 10.0.0.40;
    option routers 10.0.0.1;
    option domain-name-servers 10.0.0.1, 8.8.8.8;
    option domain-name "lab.local";
}

# Reservations
host archmachine {
    hardware ethernet e0:91:53:31:af:ab;
    fixed-address 10.0.0.10;
}
```

Bind the DHCP Server to an interface
Edit the config file
```Bash
sudo nano /etc/default/isc-dhcp-server
```

Add the following config to the end of the file
```Bash
INTERFACESv4="ens34"
```

Restart the DHCP Server
```Bash
sudo systemctl restart isc-dhcp-server.service
```

Check the service is running
```Bash
sudo systemctl status isc-dhcp-server.service
```



---
## References