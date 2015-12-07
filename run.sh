#!/bin/bash
set -o errexit

sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

# Generating pub key and certificates for Apache.
if [ ! -e "/etc/apache2/external/cert.pem" ] || [ ! -e "/etc/apache2/external/key.pem" ]
then
  echo ">> generating self signed cert"
  openssl req -x509 -newkey rsa:4086 \
  -subj "/C=XX/ST=XXXX/L=XXXX/O=XXXX/CN=localhost" \
  -keyout "/etc/apache2/external/key.pem" \
  -out "/etc/apache2/external/cert.pem" \
  -days 3650 -nodes -sha256  1>&2
fi

# Activating email sending via SSMTP.
if [ ! -e "/usr/local/etc/php/conf.d/docker-ssmtp.ini" ]
then
  echo "sendmail_path = /usr/sbin/ssmtp -t" > /usr/local/etc/php/conf.d/docker-ssmtp.ini
  echo "mailhub=mail:25\nUseTLS=NO\nFromLineOverride=YES" > /etc/ssmtp/ssmtp.conf
fi

# Activating mod rewrite and SSL support.
a2enmod rewrite
a2enmod ssl
