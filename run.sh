#!/bin/bash
sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

if [ ! -e "/etc/apache2/external/cert.pem" ] || [ ! -e "/etc/apache2/external/key.pem" ]
then
  echo ">> generating self signed cert"
  openssl req -x509 -newkey rsa:4086 \
  -subj "/C=XX/ST=XXXX/L=XXXX/O=XXXX/CN=localhost" \
  -keyout "/etc/apache2/external/key.pem" \
  -out "/etc/apache2/external/cert.pem" \
  -days 3650 -nodes -sha256
  # echo ">> wilcard"
  # openssl req -new -x509 -newkey rsa:4086 \
  # -out "/etc/apache2/external/wildcard.localhost.cert.pem" \
  # -days 3650 -nodes -sha256 \
  # -subj "/CN=*.localhost"
fi

echo ">> copy /etc/apache2/external/*.conf files to /etc/apache2/sites-enabled/"
cp /etc/apache2/external/*.conf /etc/apache2/sites-enabled/ 2> /dev/null > /dev/null

a2enmod rewrite
a2enmod ssl
