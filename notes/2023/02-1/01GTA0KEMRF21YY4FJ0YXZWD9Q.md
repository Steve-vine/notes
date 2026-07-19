---
id: 01GTA0KEMRF21YY4FJ0YXZWD9Q
created: 2023-02-27T18:01:51Z
updated: 2023-03-17T17:33:31Z
type: memo
title: Setup nginx Load Balancer
imported_from: Obsidian
---
27-02-2023 17:45

Tags: #nginx #proxy #loadbalancer

# Setup nginx Load Balancer

---
https://upcloud.com/resources/tutorials/configure-load-balancing-nginx
https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/

Update app repo
```Bash
sudo apt upodate
```

Install nginx
```Bash
sudo apt install nginx
```

List applications profiles available to the firewall
```Bash
sudo ufw app list
```

Should look something like
```Bash
Available applications:
  Nginx Full
  Nginx HTTP
  Nginx HTTPS
  OpenSSH
```

Enable the required profile e.g.
```Bash
sudo ufw allow 'Nginx Full'
```

Create the configuration file
```Bash
sudo nano /etc/nginx/conf.d/load-balancer.conf
```

Example configuration file with multiple endpoints based on folders
```Bash
upstream nginx {
    server 192.168.1.156:30000;
}

upstream apache {
    server 192.168.1.156:31000;
}

server {
    listen 80;
    
    location ^~ /nginx/ {
        rewrite ^/nginx/(.*)$ /$1 break;
        proxy_pass http://nginx;
	}

    location ^~ /apache/ {
        rewrite ^/apache/(.*)$ /$1 break;
        proxy_pass http://apache;
    }
}
```

Example configuration file with multiple endpoints based on sub domains
```Bash
upstream nginx {
    server 192.168.1.156:30000;
}

upstream apache {
    server 192.168.1.156:31000;
}

server {
    listen 80;
    
    location ^~ /nginx/ {
        rewrite ^/nginx/(.*)$ /$1 break;
        proxy_pass http://nginx;
	}

    location ^~ /apache/ {
        rewrite ^/apache/(.*)$ /$1 break;
        proxy_pass http://apache;
    }

server {
        server_name nginx.lab.local;
        location / {
            proxy_pass       http://nginx;
        }
 }
 server {
        server_name apache.lab.local;
        location / {
            proxy_pass       http://apache;
        }
 }

```

Retstart nginx
```Bash
sudo service nginx restart
```

Check nginx is running
```Bash
systemctl status nginx
```

---
## References