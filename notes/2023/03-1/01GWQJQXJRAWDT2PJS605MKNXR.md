---
id: 01GWQJQXJRAWDT2PJS605MKNXR
created: 2023-03-29T21:00:23Z
updated: 2023-03-30T15:56:59Z
type: memo
title: Install MAAS
imported_from: Obsidian
---
			29-03-2023 11:35

Tags: #maas  


---
https://maas.io/docs/how-to-do-a-fresh-install-of-maas

Start with a clean install of Ubuntu and set a static IP address

Update apps repo
```Bash
sudo apt update
```

Check the latest stable release on snap
```Bash
snap info maas
```

Install the latest stable release of MAAS using snap
```Bash
sudo snap install --channel=3.3 maas
```

Install PostgreSQL
```Bashsudo apt install -y postgresqlsudo apt install -y postgresql
sudo apt install -y postgresql
```

Setup PostgreSQL Environmental variables for config.  E.g.
```Bash
export MAAS_DBUSER="maas-user"
export MAAS_DBPASS="maasdbpassword"
export MAAS_DBNAME="dbmaas"
export HOSTNAME="localhost"
```

Create a MAAS PostgreSQL User
```Bash
sudo -u postgres psql -c "CREATE USER \"$MAAS_DBUSER\" WITH ENCRYPTED PASSWORD '$MAAS_DBPASS'"
```

Create MAAS Database
```Bash
sudo -u postgres createdb -O "$MAAS_DBUSER" "$MAAS_DBNAME"
```

Add the database to the pg_hba.config file
```Bash
sudo nano /etc/postgresql/14/main/pg_hba.conf
```

Add the following line at the end, replacing $MAAS_DBNAME & $MAAS_DBUSER variables
```Bash
host    dbmaas    maas-user    0/0     md5
```

Initialise MAAS
```Bash
sudo maas init region+rack --database-uri "postgres://$MAAS_DBUSER:$MAAS_DBPASS@$HOSTNAME/$MAAS_DBNAME"
```

Check the status of MAAS (DHCP will be stopped)
```Bash
sudo maas status
```

Create an admin user
```Bash
sudo maas createadmin
```

Login to continue the setup process at the URL Provided during the init.  E.g.
http://192.168.2.2:5240/MAAS


---
## References