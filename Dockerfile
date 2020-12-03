FROM php:7.1-fpm

COPY . /var/www/forum

COPY check_db.sh /entrypoint/

RUN ["chmod", "+x", "/entrypoint/check_db.sh"]

WORKDIR /var/www/forum

RUN ["chmod", "+x", "waitforit.sh"]


RUN apt-get update && \
  apt-get install -y \
    zlib1g-dev libpng-dev git wget && docker-php-ext-install gd zip pdo pdo_mysql
        
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

## RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
## && php -r "if (hash_file('SHA384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
## && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
## && composer install

RUN chown -R www-data:www-data /var/www/forum

ENTRYPOINT ["sh", "/entrypoint/check_db.sh"]
