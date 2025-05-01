# Prerequisites

Untuk mempersiapkan project ini, ada beberapa yang perlu dipersiapkan

## 1. Tools yang diperlukan :

- Chocolatey ✅
- Git bash ✅
- Vagrant ✅
- Oracle virtualbox ✅
- JDK (java development kit) atau paket java ✅
- Maven✅
- VSCode✅
- Sublime Text✅
- Intellij (opsional)✅
- AWS CLI  ✅
    (gambar 1)  
    (gambar 2)

### 1.1 Install chocolatey with powershell (terminal harus run as administrator)

Chocolatey adalah paket manajer untuk Windows, yang memungkinkan instalasi perangkat lunak secara mudah, mirip dengan apt di Ubuntu. Untuk memulai, jalankan perintah berikut di PowerShell dengan hak akses administrator.
Sumber web yang saya gunakan bisa dilihat disini :

```
https://docs.chocolatey.org/en-us/choco/setup/
```

(gambar choco)
1. Cek status Execution Policy:

```
Get-ExecutionPolicy
```
2. Ubah Execution Policy agar dapat mengizinkan skrip untuk dijalankan:
```
Set-ExecutionPolicy AllSigned
```
3. Install Chocolatey
```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### 1.2 Install tools with choco
Berikut adalah cara menginstall software yang diperlukan dengan menggunakan chocolatey :
- virtual box :

```
choco install virtualbox --version=7.1.4 -y
```

- vagrant :

```
choco install vagrant --version=2.4.3 -y
```

- git :

```
choco install git -y
```

- jdk :

```
choco install corretto17jdk -y
```

- maven :

```
choco install maven -y
```

- awscli :

```
choco install awscli -y
```

- intellij (opsional) :

```
choco install intellijidea-community -y
```

- vscode :

```
choco install vscode -y
```

- sublimetext :

```
choco install sublimetext3 -y
```

untuk penginstallan di ubuntu (menggunakan apt dan tidak menggunakan choco), bisa dilihat di branch prereqs.

## Sign Up :

- Github
- Domain Purchase (godaddy misalnya)
- Dockerhub
- Sonarcloud  
    (gambar 3 sign up)

## AWS :

- Freetier account
- IAM with MFA
- Billing Alarm
- Certificate Setup  
    (gambar 4 aws)

## Tools yang diperlukan :




## Untuk bagian Signup dan AWS masih dalam proses
