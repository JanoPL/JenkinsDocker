FROM jenkins/jenkins:latest

USER root

RUN apt-get update &&\
    apt-get upgrade -y &&\
    apt-get install -y tzdata &&\
    apt-get install -y \
    wget apt-transport-https lsb-release ca-certificates apt-utils acl nano iproute2

RUN \
  apt-get -yqq install apt-transport-https lsb-release ca-certificates && \
  wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
  echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
  apt-get -qq update && apt-get -qqy upgrade

ARG TARGET_PHP_VERSION=7.4
RUN apt-get update &&\
    apt-get upgrade -y &&\
    apt-get install -y \
    php${TARGET_PHP_VERSION} php${TARGET_PHP_VERSION}-apcu php${TARGET_PHP_VERSION}-mbstring php${TARGET_PHP_VERSION}-curl php${TARGET_PHP_VERSION}-gd \
    php${TARGET_PHP_VERSION}-imagick php${TARGET_PHP_VERSION}-intl php${TARGET_PHP_VERSION}-bcmath \
    php${TARGET_PHP_VERSION}-mysql php${TARGET_PHP_VERSION}-xdebug php${TARGET_PHP_VERSION}-xml php${TARGET_PHP_VERSION}-zip curl

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

USER jenkins