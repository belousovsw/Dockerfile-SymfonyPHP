FROM php:7.4-fpm

RUN apt-get update 
RUN apt-get install -y sudo apt-utils libonig-dev libpq-dev libzip-dev wget mc libssh2-1-dev libssh2-1 libxml2-dev libcurl4-openssl-dev libpng-dev git wget supervisor net-tools

ENV TZ Europe/Moscow

RUN pecl install ssh2-1.2
RUN pecl install apcu

RUN docker-php-ext-install pdo_mysql mysqli zip mbstring xml curl gd mbstring json soap intl pcntl opcache
RUN docker-php-ext-enable ssh2 apcu 

EXPOSE 19321

RUN echo "www-data ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /var/www

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer

RUN curl -sS https://get.symfony.com/cli/installer | bash
RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony

RUN service supervisor start
