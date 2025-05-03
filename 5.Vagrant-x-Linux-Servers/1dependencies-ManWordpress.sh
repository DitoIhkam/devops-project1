#!/bin/bash

echo "Memulai pembaruan sistem..."
sudo apt update -y

echo "Menginstal paket yang diperlukan..."
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

echo "Instalasi selesai!"
echo "Pastikan untuk memeriksa konfigurasi dan layanan sebelum digunakan."
