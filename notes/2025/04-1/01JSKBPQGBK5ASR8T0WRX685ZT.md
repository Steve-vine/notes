---
id: 01JSKBPQGBK5ASR8T0WRX685ZT
created: 2025-04-24T07:37:57.515Z
updated: 2025-04-24T08:59:53.348999Z
type: memo
title: Twingate Headless Client Gateway
---
24-04-2025 08:37

Tags: #twingate 


---
### Prerequisites
Create a server running Linux (Ubuntu/Debian)
This server will be known as the Twingate Router and will act as DNS resolution and gateway for other instances wanting to access Twingate resources.
Where multiple Twingate Routers have been deployed, instances must use the same Router for DNS and Gateway access as Routers may not return the same IP address for the same Resource.
Selective routing can be used so that not all traffic is directed through the Router e.g. 100.0.0.0/8 
Create security group rules

Create a Twingate Service with the required access and make a copy of the API key json.

Additional information: https://www.twingate.com/docs/headless-iot-gateway
### Configuration of the Router
Update the system
```
sudo apt update && sudo apt upgrade -y
```

Install Curl
```
sudo apt install curl -y
```

Download the install script
```
sudo curl https://raw.githubusercontent.com/Twingate-Solutions/general-scripts/main/twingate-headless-client-gateway/twingate-headless-client-gateway.sh -o gateway_config.sh
```

Create a file for the security key and paste the API json into it
```
sudo vim service_key.json
```

Make the install script executable
```
sudo chmod +x ./gateway_config.sh
```

Run the install script
```
sudo ./gateway_config.sh ./service_key.json <network-cidr>
```
The network-cidr should cover all instances that will need to use the Router

Once complete, test that you can access a resource on the Router e.g. curl it.


---
## References