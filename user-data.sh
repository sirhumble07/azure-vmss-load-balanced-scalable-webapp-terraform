#!/bin/bash
# Terramino PHP Game Deployment Script - BASH version
set -euo pipefail


# 1) Packages #

export DEBIAN_FRONTEND=noninteractive

# Update & install Apache, PHP, jq
apt-get update -y
apt-get install -y apache2 php php-curl libapache2-mod-php php-mysql jq

# Allow HTTP/HTTPS if UFW exists (ignore if not installed)
ufw allow 'Apache Full' 2>/dev/null || true


# 2) Web root + permissions#

mkdir -p /var/www/html
chown -R www-data:www-data /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;


# 3) Replace default page   #

cd /var/www/html
rm -f index.html   # IMPORTANT: ensures PHP is served, not the Apache default


# 4) Download and pull my PHP Terramino game from GitHub as index.php.

curl -fsSL -o index.php \
https://raw.githubusercontent.com/sirhumble07/terramino-php-game/refs/heads/main/index.php


# 5) Ensure Apache prefers PHP    #

if ! grep -q "DirectoryIndex index.php" /etc/apache2/apache2.conf; then
  echo "DirectoryIndex index.php index.html" >> /etc/apache2/apache2.conf
fi


# 6) Enable & restart PHP Apache #

a2enmod php* >/dev/null 2>&1 || true
systemctl enable apache2
systemctl restart apache2

echo "Deployment complete. Visit http://<vm-ip>/ to see Terramino + IMDS metadata."
