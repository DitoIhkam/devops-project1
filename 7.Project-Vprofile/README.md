![alt text](?raw=true)
# Introduction

This document provides a step-by-step guide to provision multiple services in a virtual environment using Vagrant and VirtualBox. The environment includes several services like:

**1. Mariadb**

**2. Memcache**

**3. RabbitMQ**

**4. Tomcat**

**5. Nginx.**

All services will be configured manually, in a specific order, to simulate a real production-like application infrastructure. Once the manual steps are well understood, the configured will be automated. 

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/000.png?raw=true)

# Prerequisite

**1. Oracle VM Virtualbox**

**2. Vagrant**

**3. Vagrant Plugins**

Execute below command in your computer (i'm using git bash) to install hostmanager plugin
```
vagrant plugin instlal vagrant-hostmanager
```

**4. Git Bash**

# VM Setup
**1. Clone Source Code `https://github.com/DitoIhkam/devops-project1`**  
**2. cd into the repo**  
**3. verify branch at `master` branch**  
**4. cd into vagrant/Manual_provisioning (there is a Vagrantfile)**  
Bring up vm's
```
varant up
```
> INFO : aal the vm hostname and /etc/hosts will be automatically updated

# Provisioning
### Services
1. Nginx           => Web Service for HTTP  
2. Tomcat          => Application Server for JAVA  
3. RabbitMQ        => Broker/Queuing Agent  
4. Memcache        => DB Caching to speed up data access from the database  
5. MySQL           => SQL Database   

### Setup should be done in below mentioned order (SVC mean Service)
MySQL        => Database SVC. Because all the service depends on database  
Memcache     => DB Caching SVC. Speed up caching to database  
RabbitMQ     => Broker/Queue SVC. Broker message service for app  
Tomcat       => Application SVC. running app after database, cache, and broker ready  
Nginx        => Web SVC. Last installed, since it acts as the front-facing proxy   

(Flow Image)
![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/0.flow.png?raw=true)

# 1. MySQL Setup
### Login to the db VM and login to user root

```
vagrant ssh db01
```
```
sudo -i
```

### Verify Hosts entry, if entries missing update it with IP and hostnames
```
cat /etc/hosts
```

### Update OS with latest patches and Set Repository

```
sudo dnf update -y
```
```
sudo dnf install epel-release -y
```


(image of login, etc host, and dnf update)

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/1.1.DNF-UPDATE-DB01.png?raw=true)

### Install MariaDB Package

```
sudo dnf install git mariadb-server -y
```

(image of install mariadb)

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/1.2.Install-mariadb.png?raw=true)

### Starting & enabling mariadb-server

```
sudo systemctl start mariadb
```
```
sudo systemctl enable mariadb
```

(image of start dan enable mariadb)

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/1.3.Start-enable-maria.png?raw=true)

RUN mysql secure installation script to apply standard secure of mariadb

```
mysql_secure_installation
```

NOTE: Set db root password, I will be using admin123 as password.

(image of mysql secure)

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/1.4.Mysql-secure.png?raw=true)

### Login to MySQL as root

```
mysql -u root -padmin123
```

### Run this command SQL in MySQL shell

```
create database accounts;
```
```
grant all privileges on accounts.* TO 'admin'@'localhost' identified by 'admin123';
````
```
grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin123';
```
```
FLUSH PRIVILEGES;
```
```
exit;
```

(image of edit configuration in mariadb)

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/1.5.login-and-config-mariadb.png?raw=true)

### Download Source Code & Initialize Database

```
cd /tmp/
```
```
git clone -b local https://github.com/hhkcoder/vprofile-project.git
```
```
cd vprofile-project
```
```
mysql -u root -padmin123 accounts < src/main/resources/db_backup.sql
```
```
mysql -u root -padmin123 accounts
```

restart mariadb

```
systemctl restart mariadb
```
```
systemctl status mariadb
```

(image of download and initialize db)

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/1.6.Download-initDB-restart-status.png?raw=true)


---

# 2. Memcache Setup
### Login to root user and VM Memcache

```
vagrant ssh mc01
```
```
sudo -i
```

### Check the Host entry 

```
cat /etc/hosts
```
### Update OS with latest patches

```
dnf update -y
```
```
sudo dnf install epel-release -y
```

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/2.1.DNF-UPDATE-MC01.png?raw=true)

(gambar login, etc host, dan dnf update)(gaada etc host wkwkkw)

### Install, start, and enable Memcached on port 11211

```
sudo dnf install memcached -y
```

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/2.2.Install-Memcache.png?raw=true)

(gambar install memcache)

```
sudo systemctl start memcached
```
```
sudo systemctl enable memcached
```

### Optional: Check status Memcached

```
sudo systemctl status memcached
````

### Change the binding IP to allow external access (0.0.0.0)

```
sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached
```

### Restart memcached after config changed

```
sudo systemctl restart memcached
```

### Specifying the Memcache port

```
sudo memcached -p 11211 -U 11111 -u memcached -d
```

(start enable until the end)

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/2.3.Start-enable-status-configip.png?raw=true)

# 3. RabbitMQ Setup

### Login to the rabbitmq vm and login into root user

```
vagrant ssh rmq01
```
```
sudo -i
```

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/3.1.DNF-UPPDATE-RMQ01.png?raw=true)


### Verifiy the host entry

```
cat /etc/hosts
```

### Update OS and set EPEL Repo

```
dnf update -y
```
```
dnf install epel-release -y
```
### Install Dependencies

```
dnf install wget -y
```
```
dnf -y install centos-release-rabbitmq-38
```

(image of install wget and rabbit)

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/3.2.Install-wget-rabbit.png?raw=true)

```
dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server
```

image of install repo rabbit

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/3.3.Enable-repo-rabbit.png?raw=true)

```
systemctl enable --now rabbitmq-server
```

(image of enable rabbitmq in systemd)

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/3.4.Enable-systemd.png?raw=true)

### Setup Access to user test

```
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
```
```
sudo rabbitmqctl add_user test test
```
```
sudo rabbitmqctl set_user_tags test administrator
```
```
rabbitmqctl set_permissions -p / test ".*" ".*" ".*"
```
```
sudo systemctl restart rabbitmq-server
```
```
sudo systemctl status rabbitmq
```

(image of Setup access)

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/3.5.Setup-access-user.png?raw=true)

# 4. Tomcat

### Login ssh to vm and verify hosts and update OS also

```
vagrant ssh app01
```
```
cat /etc/hosts
```
```
dnf update -y
```
```
dnf install epel-release -y
```

(image of dnf update)

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/4.1.DNF-UPDATE-APP01.png?raw=true)

### Install Java and wget


```
dnf -y install java-17-openjdk java-17-openjdk-devel
```
```
dnf install git wget -y
```

(image of install java and wget)

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/4.2.Install-java-wget.png?raw=true)

### Download and add user

```
cd /tmp/
```
```
wget https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.26/bin/apache-tomcat-10.1.26.tar.gz
```
```
tar xzvf apache-tomcat-10.1.26.tar.gz
```


(image of download and untar)

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/4.3.cdtmp-wget-tar.png?raw=true)

### Add User tomcat

```
useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat
```

### Copy data to tomcat home dir

```
cp -r /tmp/apache-tomcat-10.1.26/* /usr/local/tomcat/
```

### Make tomcat user owner of tomcat home dir
```
chown -R tomcat.tomcat /usr/local/tomcat

```


### Setup systemctl command for tomcat

```
nano  /etc/systemd/system/tomcat.service
```

Update the file with below content

```
[Unit]
Description=Tomcat
After=network.target

[Service]
User=tomcat
Group=tomcat
WorkingDirectory=/usr/local/tomcat
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_PID=/var/tomcat/%i/run/tomcat.pid
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINA_BASE=/usr/local/tomcat
ExecStart=/usr/local/tomcat/bin/catalina.sh run
ExecStop=/usr/local/tomcat/bin/shutdown.sh
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
```

(image of config edit)


![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/4.5.konfig-pengeditan.png?raw=true)



### Reload, start, and enable tomcat

```
systemctl daemon-reload
```
```
systemctl start tomcat
```
```
systemctl enable tomcat
```

(image from useradd to enable)

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/4.4.Useradd-sampeabis.png?raw=true)

---
# Code Build and Deploy (App01)
### Maven Setup

```
cd /tmp/
```
```
wget https://archive.apache.org/dist/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.zip
```
```
unzip apache-maven-3.9.9-bin.zip
```
```
cp -r apache-maven-3.9.9 /usr/local/maven3.9
```
```
export MAVEN_OPTS="-Xmx512m"
```

image of setup

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/4.7-codebuild-cdtmp-down-unzip.png?raw=true)

### Download Source Code

```
git clone -b local https://github.com/hkhcoder/vprofile-project.git
```

image of cp -r to clone
![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/4.8.cpr-sampai-gitclone.png?raw=true)


### Update Configuration

```
cd vprofile-project
```
```
vim src/main/resources/application.properties
```

(image of script)
![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/4.9.code-app-propert.png?raw=true)

### Build code

```
/usr/local/maven3.9/bin/mvn install
```

(build image)
![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/4.91.vim-build.png?raw=true)

### Deploy artifact

```
systemctl stop tomcat
```
```
rm -rf /usr/local/tomcat/webapps/ROOT*
```
```
cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
```
```
systemctl start tomcat
```
```
chown tomcat.tomcat /usr/local/tomcat/webapps -R
```
```
systemctl restart tomcat
```

(image will be added later)

# 5. Nginx Setup

### Login to the nginx vm and to the root user

```
vagrant ssh web01
```
```
sudo -i
```

 ### Verify Hosts entry 
 
```
cat /etc/hosts
```


### update package OS

```
apt update -y
```
```
apt upgrade -y
```

(image from login to update OS)

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/5.1.APT-UPDATE-WEB01.png?raw=true)

### Install Nginx

```
apt install nginx -y
```

(image of install nginx)

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/5.2.install-nginx.png?raw=true)

### create nginx config file

```
nano /etc/nginx/sites-available/vproapp
```
update with below content
```
upstream vproapp {
    server app01:8080;
}

server {
    listen 80;
    server_name yourdomain.com;  # Tambahkan domain atau gunakan _ untuk menangkap semua

    location / {
        proxy_pass http://vproapp;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

(image of editing)

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/5.3.nginx-config.png?raw=true)


 ### Remove default nginx conf

```
rm -rf /etc/nginx/sites-enabled/default
```

### Create link to activate website

```
ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp
```

### Restart Nginx

```
systemctl restart nginx
```

(image of delete, create link, and restart)

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/5.4.last.png?raw=true)

### Finally, Open the browser and see the result

**Login interface**

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/6.1.Tampilan-login.png?raw=true)

**UI After Login**

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/6.2.Sudah-login.png?raw=true)

**RabbitMQ Test**

![alt text](?https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/6.3.Test-rabbit.pngraw=true)


**Memcache Test**

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/6.4.test-memcache.png?raw=true)

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/6.5.test%20memcache2.png?raw=true)

![alt text](https://github.com/DitoIhkam/devops-project1/blob/learn-devops/7.Project-Vprofile/image/6.6.test-memcache3.png?raw=true)
