![alt text](?raw=true)


# 5. Dokumentasi Vagrant dan Linux Server

Dokumentasi ini menjelaskan konfigurasi menggunakan Vagrantfile, termasuk pengaturan IP, CPU, RAM, disk, sinkronisasi direktori, serta proses deploy website baik secara manual maupun otomatis.

---

## A. Konfigurasi Vagrant Dasar

1. **Cek Box Tersedia**
   Gunakan perintah berikut untuk melihat daftar box yang tersedia:

   ```bash
   vagrant box list
   ```
   
> tersedia ubuntu 20 atau ubuntu/focal64

2. **Inisialisasi Box**
   Gunakan perintah:

   ```bash
   vagrant init ubuntu/focal64
   ```

   Alternatif : cari box dari Vagrant Cloud dan gunakan dokumentasi yang tertera di sana untuk initialize vagrantfile melalui link ini `https://portal.cloud.hashicorp.com/vagrant/discover`
(gambar website vagrant cloud dan box yang sudah tersedia didalam host)
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/1.1.vagrant-box-dan-cloud.png?raw=true)

3. **Struktur Dasar Vagrantfile**
Setelah melakukan vagrant init, akan muncul Vagrantfile dengan konfigurasi dasar dari vagrant, disini saya akan menjelaskan, melakukan beberapa tambahan dan perubahan konfigurasi. :
   * `Vagrant.configure("2") do |config|`: Mengatur konfigurasi dengan vagrant versi 2.
   * `config.vm.box = "focal64"`: Menentukan OS box. focal64 bisa disesuaikan dengan OS yang diinginkan di vagrant cloud/vagrant box list.
   * `config.vm.network "private_network", ip: "192.168.56.14"`: Menentukan jenis network dan IP-nya. bisa dengan NAT (hanya internet saja) atau ditambah dengan bridge/public netowrk

(gambar konfigurasi vagrantfile)
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/1.2.network-config.png?raw=true)
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/1.4.config-last.png?raw=true)
4. **Spesifikasi VM (CPU, RAM, Disk, Nama)**
didalam menentukan nama yang tertera di virtual box, ram, cpu, juga disk mereka harus berada didalam blok vm.provider seperti ini

* Ralat :
untuk pengaturan Disk, perlu plugin tambahan agar disk nya bisa diatur. 
   ```ruby
   config.vm.provider "virtualbox" do |vb|
     vb.name = "web01"
     vb.memory = 2048
     vb.cpus = 2
   end
   ```

6. **Provisioning**
   Bisa menambahkan script provisioning untuk update/install2. Jangan sampai ada konfirmasi ketika provisioning, beberapa command yang perlu verifikasi biasanya diikuti dengan command -y:

```ruby
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y apache2
  SHELL
  ```
7. **Sync Directories**
	Pada dasarnya direktori yang ada Vagrantfile tempat kita membuat vm dengan `vagrant up`, dengan direktori vm yang sudah di buat dengan `vagrant up`, akan tersambung direktorinya di /vagrant. Fungsinya untuk copy paste antara vm dengan host ataupun sebaliknya. Direktori yang terhubung pun bisa diatur antara host dan vm mau terhubung lewat direktori mana dengan konfigurasi berikut :
```
config.vm.synced_folder "F:\\scripts\\shellscripts", "/opt/scripts"
```
berikut adalah contoh gambarnya, juga gambar dari konfigurasi spesifikasi, provisioning, maupun sync directories.
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/1.3.sync-dir.png?raw=true)
dan berikut Vagrantfile untuk konfigurasi filenya
[Vagrantfile-Basic](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/Vagrantfile-1-Basic)

## B. Deploy Website Secara Manual

1. **Siapkan VM CentOS dengan Vagrant**

   * Gunakan `vagrant init centos/8` atau centos/9
   * Edit Vagrantfile:

     * Private atur ip misal 192.168.56.22 dan Public Network seperti yang sudah dijelaskan sebelumnya.
     * `vb.name = "4.WebsiteManual"`, `vb.memory = 2048` (atau 1024), `vb.cpus = 1`
berikut untuk Vagrantfile website manual, setelah download agar bisa digunakan, ganti namanya dengan vagrantfile

[Vagrantfile-ManualWebsite](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/Vagrantfile-2-ManualWeb)
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/2.1.konfigurasi-web-man.png?raw=true)
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/2.2.konfigurasi-web-man.png?raw=true)

2. **Download Template Website**
   Masuk ke folder /tmp dengan command `cd /tmp` agar file hanya berada  sementara zip nya.
   Unduh file dari host windows dan copy melalui sync direktori yang terhubung dengan vm. Lalu dari vm bisa masuk ke direktori /vagrant dan copy paste ke /tmp. berikut webnya. [Tooplate - Mini Finance](https://www.tooplate.com/view/2135-mini-finance)
bisa copy paste menggunakan sync directories atau lainnya
3. **Mengambil Link Download (Opsional via DevTools)**
   * Opsi ini dilakukan setelah melakukan `vagrant up` dan didalam vm
   * Buka F12 > Tab Network
   * Klik tombol download, salin link, lalu `wget` di VM:

     ```bash
     wget https://www.tooplate.com/zip-templates/2135_mini_finance.zip
     ```
(gambar pengambilan link download linux via brave browser)
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/2.3.network-brave.png?raw=true)

4. **Ubah Hostname dan logout serta login lagi untuk perubahan**

   ```bash
   sudo hostnamectl set-hostname finance
   exec bash
   ```
(gambar download link serta penggantian hostname)
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/2.6.jalan.png?raw=true)
5. **Install Apache & Tools serta jalankan httpd**

   ```bash
   sudo yum install httpd wget unzip vim nano zip -y
   ```
   ```
   sudo systemctl start httpd
   ```
   ```
   sudo systemctl enable httpd
   ```
enable berfungsi untuk mengaktifkan systemd untuk httpd agar ketika restart vm, httpd akan jalan secara otomatis

![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/2.7.httpd-service.png?raw=true)
6. **Deploy Website**

   ```bash
   unzip 2135_mini_finance.zip
   sudo cp -r /tmp/2135_mini_finance/* /var/www/html
   sudo systemctl restart httpd
   sudo systemctl status httpd
   ```
   Pastikan firewall mati atau port 80 terbuka.
   Lalu website bisa diakses menggunakan ip di browser
   (gambar ekstrak file dan restart website serta hasil)
   ![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/2.8.unzip-cp-restart.png?raw=true)
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/2.9.hasil.png?raw=true)
## C. Deploy Website Secara Otomatis dengan Vagrant

Gunakan provisioning shell script dalam Vagrantfile, lalu tinggal `vagrant up`. screenshot dan filenya ada disini.


[Vagrantfile-WebAuto](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/Vagrantfile-3-AutoWeb)
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/3.1.Auto-Web.png?raw=true)
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/3.2.Auto-Web.png.png?raw=true)


## D. Instalasi Wordpress di Ubuntu

### 1. Install Dependencies
pada step ini saya lebih suka menggunakan shell script seperti di screenshot, namun apabila ingin melakukan secara manual bisa menggunakan script berikut :
```bash
sudo apt update -y
sudo apt install apache2 \
                 ghostscript \
                 libapache2-mod-php \
                 mysql-server \
                 php \
                 php-bcmath \
                 php-curl \
                 php-imagick \
                 php-intl \
                 php-json \
                 php-mbstring \
                 php-mysql \
                 php-xml \
                 php-zip -y
```


![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/4.1.install-dependencies.png?raw=true)

*Tambahan 
berikut untuk vagrantfile yang saya gunakan yang belum sempat saya dokumentasikan prosesnya
[Vagrantfile-ManualWordpress](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/Vagrantfile-4-ManualWordpress)

### 2. Install Wordpress dan Konfigurasi Apache
Pada step ini saya membuat folder, mengubah kepemilikan owner dan mendownload wordpress ke lokasi yang saya tentukan
```bash
sudo mkdir -p /srv/www
sudo chown www-data: /srv/www
curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /srv/www
```
(gambar installasi wordpress)
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/4.2.Install-Wordpress.png?raw=true)

**Apache Configuration:**
buat File ini dengan command berikut: `sudo nano /etc/apache2/sites-available/wordpress.conf`
> Konfigurasi ini untuk mengatur lokasi documentroot 
```apache
<VirtualHost *:80>
    DocumentRoot /srv/www/wordpress
    <Directory /srv/www/wordpress>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
    <Directory /srv/www/wordpress/wp-content>
        Options FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost>
```

Aktifkan config:

```bash
sudo a2ensite wordpress
sudo a2enmod rewrite
sudo a2dissite 000-default
sudo service apache2 reload
```

(gambar config apache)
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/4.3.konfigurasi-apache-dan-start-wordpress.png?raw=true)

### 3. Konfigurasi Database
untuk mengkonfigurasinya, kita perlu membuat database di mysql.
> Login ke root
```sql
sudo mysql -u root
```
> Membuat database dan melihatnya
```
CREATE DATABASE wordpress;
```
```
show databases; 
```
> Membuat user dan password, memberi hak akses command sql kepada wordpress, dan menerapkan semua perubahan. JANGAN LUPA UNTUK MENGGANTI '<your-password>' dengan password anda
```
CREATE USER 'wordpress'@'localhost' IDENTIFIED BY '<your-password>';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON wordpress.* TO wordpress@localhost;
FLUSH PRIVILEGES;
quit;
```
(gambar konfigurasi datbaase mysql)
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/4.4.konfigurasi.database.png?raw=true)
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/4.5.konfigurasi-database.png?raw=true)

### 4. Konfigurasi Wordpress
pertama untuk konfigurasinya, kita copy konfigurasi sample yang didapat dari wordpress
```bash
sudo -u www-data cp /srv/www/wordpress/wp-config-sample.php /srv/www/wordpress/wp-config.php
```
selanjutnya atur kredensial database didalam file konfigurasi dengan menjalankan command ini. Perlu diketahui disini `<your-password>` perlu diganti dengan password yang kita buat pada step konfigurasi database mysql sebelumnya.
```
sudo -u www-data sed -i 's/database_name_here/wordpress/' /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i 's/username_here/wordpress/' /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i 's/password_here/<your-password>/' /srv/www/wordpress/wp-config.php
```
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/4.6.wp-config-php.png?raw=true)
terakhir di step ini, edit file di nano dengan perintah ini

```bash
sudo -u www-data nano /srv/www/wordpress/wp-config.php
```

cari kalimat ini
```
define( 'AUTH_KEY',         'put your unique phrase here' );
define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
define( 'NONCE_KEY',        'put your unique phrase here' );
define( 'AUTH_SALT',        'put your unique phrase here' );
define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
define( 'LOGGED_IN_SALT',   'put your unique phrase here' );
define( 'NONCE_SALT',       'put your unique phrase here' );
```
hapus semua dengan kalimat diatas dengan ctrl + k, ganti dengan konten di web ini yang mana setiap kali kita klik akan menghasilkan kunci secara acak, berfungsi agar kunci nya susah untuk ditebak. https://api.wordpress.org/secret-key/1.1/salt/
kalau sudah, keluar dan simpan dari nano/vim. 

(gambar pengeditan uniq dan web generatenya)
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/4.91.ketinggalan-generate-key.png?raw=true)


### 5. Setup Akhir Wordpress

Step terakhir, kita bisa membuka wordpress melalui IP yang sudah diatur di vagrant, mengatur title, username, password, serta menginstall wordpressnya dan wordpress siap digunakan.
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/4.7.sign-up-wordpress.png?raw=true)
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/4.8.login-wordpress.png?raw=true)
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/4.9.tampilan-wordpress.png?raw=true)


## E. Penutup

Semua proses di atas bisa diotomasi menggunakan Vagrant provisioning dengan shell script. Lampiran kode dan screenshot bisa dilihat di bagian akhir.


![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/4.92.config-word-auto.png?raw=true)
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/4.93.config-word-auto.png.png?raw=true)
![alt text](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/images/4.94.config-word-auto.png.png?raw=true)
[Vagantfile-AutoWordpress](https://github.com/DitoIhkam/vprofile/blob/learn-devops/5.Vagrant-x-Linux-Servers/Vagrantfile-5-AutoWordpress)
