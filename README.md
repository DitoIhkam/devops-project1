## Tools Prerequisites for CentOS 9, RHEL 9 & Rocky Linux

---

### Installing VirtualBox

```
sudo yum update
```

```
sudo yum install patch gcc kernel-headers kernel-devel make perl wget -y
```

```
sudo reboot
```

Setelah reboot, login kembali dan jalankan:

```
sudo wget http://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo -P /etc/yum.repos.d
```

```
sudo yum install VirtualBox-7.1 -y
```

---

### Installing Vagrant

```
sudo dnf update -y
```

```
sudo dnf config-manager --add-repo=https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
```

```
sudo dnf install vagrant -y
```

---

### Installing VSCode

```
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
```

```
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
```

```
dnf check-update
```

```
sudo dnf install code -y
```

---

### Installing Git

```
sudo dnf install git -y
```

---

### Installing JDK & Maven

```
sudo dnf install java-17-openjdk java-17-openjdk-devel -y
```

```
sudo dnf install maven-openjdk17 -y
```
