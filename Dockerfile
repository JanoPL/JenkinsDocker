FROM  jenkins/jenkins:lts-alpine

USER root

RUN apk update && \
    apk upgrade

RUN apk --no-cache add libssh2 libpng freetype libjpeg-turbo libgcc \
libxml2 libstdc++ icu-libs libltdl libmcrypt

RUN apk --no-cache add php7 php7-fpm php7-opcache php7-gd php7-pdo_mysql \
php7-mysqli php7-mysqlnd php7-mysqli php7-zlib php7-curl php7-phar \
php7-iconv php7-pear php7-xml php7-pdo php7-ctype php7-mbstring \
php7-soap php7-intl php7-bcmath php7-dom php7-xmlreader php7-openssl \
php7-tokenizer php7-simplexml php7-json

# Download and install composer installer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer
RUN rm -f composer-setup.php

USER jenkins

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
