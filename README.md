# How to Use UTM Hypervisor with Vagrant for Local Development Setups

We want to deploy our REST API along with its dependent services. For this, you need to spin up a Vagrant box using Vagrantfile. Treat this vagrant box as your production environment.

## Prerequisites
Before getting started, ensure you have the following prerequisites:

- Git installed on your machine
- Install UTM - `https://mac.getutm.app/` 

## How to Run ?

**Step-1**: Clone the Repository
```
$git clone https://github.com/SrivatsaRv/vagrant-utm-demo
```

**Step-2**: Setup your Env File
```
# .env file for MySQL and Flask API
MYSQL_ROOT_PASSWORD=<password>
MYSQL_DATABASE=<name-your-db-here>
DB_URL=mysql://root:<password>@${DB_HOST}:3306/<name-your-db-here>

NOTE - 
- remember to rename your env from (.env -> env) - so that UTM can mount it as a visible file (hidden files don't get mounted)
```


**Step-3**: Use Vagrant to Bring Up the Setup in 1 Click
```
$vagrant up

#Expected Output 

   default: 66b98279bfb9 Pull complete
    default: nginx Pulled
    default: Container mysql_container  Running
    default: Container flask_api2  Running
    default: Container flask_api1  Running
    default: Container nginx_container  Creating
    default: Container nginx_container  Created
    default: Container nginx_container  Starting
    default: Container nginx_container  Started
    default: API Services, NGINX, and MySQL deployed successfully.

NOTE - You will be prompoted for VM Download  by UTM - Click ALLOW -> Wait for It -> Mount your Milestone-5 Path (from your cloned dir setup) -> Click yes on CLI
- this is a MacOS specific constraint being addressed. 

```


**Step-4**: Services will be up on your ifconfig-a (newly created bridged network IP) 
```
bridge100: flags=8a63<UP,BROADCAST,SMART,RUNNING,ALLMULTI,SIMPLEX,MULTICAST> mtu 1500
        options=3<RXCSUM,TXCSUM>
        ether 52:a6:d8:7d:b1:64
        inet 192.168.64.1 netmask 0xffffff00 broadcast 192.168.64.255     --------------------------->>> THIS IS THE UP YOU NEED TO HIT YOUR BROWSER WITH + POSTMAN
        inet6 fe80::50a6:d8ff:fe7d:b164%bridge100 prefixlen 64 scopeid 0x14 
        inet6 fde0:80d1:a3d9:2b04:1014:fba:7999:30dd prefixlen 64 autoconf secured 
        Configuration:
                id 0:0:0:0:0:0 priority 0 hellotime 0 fwddelay 0
                maxage 0 holdcnt 0 proto stp maxaddr 100 timeout 1200
                root id 0:0:0:0:0:0 priority 0 ifcost 0 port 0
                ipfilter disabled flags 0x0
        member: vmenet0 flags=3<LEARNING,DISCOVER>
                ifmaxaddr 0 port 19 priority 0 path cost 0
        nd6 options=201<PERFORMNUD,DAD>
        media: autoselect
        status: active
```
