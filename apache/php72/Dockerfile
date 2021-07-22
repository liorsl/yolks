FROM php:7.2-apache

LABEL       author="Lior Slakman" maintainer="****@protonmail.com"

LABEL       org.opencontainers.image.source="https://github.com/liorsl/yolks"
LABEL       org.opencontainers.image.licenses=MIT

RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN apt-get update && apt-get install -y \
      libicu-dev \
      libpq-dev \
      #libmcrypt-dev \
      default-mysql-client \
      git \
      zip \
      libcurl3-dev \
      unzip \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      #libmcrypt-dev \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-install \
      curl \
      mbstring \
      exif \
      hash \
      json \
      mysqli \
      pdo_mysql \
      pdo_pgsql \
      pgsql \
      posix \
      zip \
      session
RUN docker-php-ext-install -j$(nproc) iconv #mcrypt
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd
RUN apt-get update && \
    apt-get install -y --no-install-recommends git zip

# Pterodactyl stuff go here
RUN adduser -D -h /home/container container

USER container
ENV  USER=container HOME=/home/container
WORKDIR     /home/container
ENV APACHE_DOCUMENT_ROOT /home/container

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

COPY entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]


# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# RUN composer
