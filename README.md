# Prerequisites

Untuk mempersiapkan project ini, ada beberapa yang perlu dipersiapkan 

## Tools :
- Chocolatey
- Git bash
- Vagrant
- Oracle virtualbox
- JDK (java development kit) atau paket java
- Maven
- VSCode
- Sublime Text
- Intellij (opsional)
- AWS CLI
(gambar 1)
(gambar 2)

## Sign Up :
- Github
- Domain Purchase (godaddy)
- Dockerhub
- Sonarcloud
(gambar 3 sign up)

## AWS :
- Freetier account
- IAM with MFA
- Billing Alarm
- Certificate Setup
(gambar 4 aws)



### Install choco with powershell (terminal run as administrator)

fungsinya untuk menginstall software2 dengan mudah seperti halnya apt di ubuntu, menginstall software yang dibutuhkan.
Sumber web yang saya gunakan bisa dilihat disini :
```
https://docs.chocolatey.org/en-us/choco/setup/
```
(gambar choco)

```
Get-ExecutionPolicy
```
```
Set-ExecutionPolicy AllSigned
```
```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### Install tools with choco


virtual box :
```
choco install virtualbox --version=7.1.4 -y
```
vagrant :
```
choco install vagrant --version=2.4.3 -y
```
git :
```
choco install git -y
```
jdk :
```
choco install corretto17jdk -y
```
maven :
```
choco install maven -y
```
awscli :
```
choco install awscli -y
```
intellij (opsional) :
```
choco install intellijidea-community -y
```
vscode :
```
choco install vscode -y
```
sublimetext :
```
choco install sublimetext3 -y
```

untuk penginstallan di ubuntu (menggunakan apt dan tidak menggunakan choco), bisa dilihat di branch prereqs.

