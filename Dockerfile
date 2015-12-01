FROM php:5.6.15-apache
MAINTAINER Michaël Rivet <rivet.michael@gmail.com>

# Add php extensions
#   mcrypt, gd
RUN apt-get update && apt-get install -y \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libmcrypt-dev \
      libpng12-dev
RUN docker-php-ext-install mcrypt gd

# Adding vhost file
ADD vhost.conf /etc/apache2/sites-available/10-vhost.conf
RUN ln -s /etc/apache2/sites-available/10-vhost.conf /etc/apache2/sites-enabled/

# Adding php conf file
ADD php.ini /usr/local/etc/php/conf.d/zzz-php.ini

# Set Apache environment variables (can be changed on docker run with -e)
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data

ENV APACHE_SERVERADMIN admin@localhost
ENV APACHE_SERVERNAME localhost
ENV APACHE_SERVERALIAS docker.localhost
ENV APACHE_DOCUMENTROOT /var/www/html

# Tailing the apache logs
ADD run.sh /run.sh
RUN chmod 755 /run.sh
RUN ["bash", "/run.sh"]
