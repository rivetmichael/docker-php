FROM php:5.6.15-apache

MAINTAINER Michaël Rivet <rivet.michael@gmail.com>

# Add php extensions and needed apps
RUN apt-get update && apt-get install -y \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libmcrypt-dev \
      libpng12-dev \
      mysql-client \
      ssmtp
RUN docker-php-ext-install mcrypt gd pdo_mysql mbstring

# Directory for SSL key / cert
RUN mkdir -p /etc/apache2/external
RUN chown -R www-data:www-data /etc/apache2/external

# Adding vhost file
ADD apache/vhost.conf /etc/apache2/sites-available/10-vhost.conf
ADD apache/ssl-vhost.conf /etc/apache2/sites-available/11-ssl-vhost.conf
RUN ln -s /etc/apache2/sites-available/10-vhost.conf /etc/apache2/sites-enabled/
RUN ln -s /etc/apache2/sites-available/11-ssl-vhost.conf /etc/apache2/sites-enabled/

# Adding php conf file
ADD php.ini /usr/local/etc/php/conf.d/zzz-php.ini

# Activating sendmail
RUN echo "sendmail_path = /usr/sbin/ssmtp -t" >> /usr/local/etc/php/conf.d/zzz-php.ini
RUN echo "mailhub=mail:25\nUseTLS=NO\nFromLineOverride=YES" > /etc/ssmtp/ssmtp.conf

# Set Apache environment variables (can be changed on docker run with -e)
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data

ENV APACHE_SERVERADMIN admin@localhost
ENV APACHE_SERVERNAME localhost
ENV APACHE_SERVERALIAS docker.localhost
ENV APACHE_DOCUMENTROOT /var/www/html

# Install Magerun
RUN curl -sS http://files.magerun.net/n98-magerun-latest.phar -o /usr/bin/n98-magerun.phar
RUN chmod +x /usr/bin/n98-magerun.phar
RUN mv /usr/bin/n98-magerun.phar /usr/bin/magerun

# Expose useful port
EXPOSE 80
EXPOSE 443

# Tailing the apache logs
ADD run.sh /run.sh
RUN chmod 755 /run.sh
RUN ["bash", "/run.sh"]
