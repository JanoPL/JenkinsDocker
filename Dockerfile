FROM jenkins/jenkins:latest

USER root

RUN apt-get update &&\
    apt-get upgrade -y &&\
    apt-get install -y tzdata &&\
    apt-get install -y \
    wget \
    apt-transport-https \
    lsb-release \
    ca-certificates \
    apt-utils \
    gcc \
    g++ \
    make

ARG TARGET_NODEJS_VERSION=12
RUN curl -sL https://deb.nodesource.com/setup_${TARGET_NODEJS_VERSION}.x | bash -
RUN apt-get install -y nodejs

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

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

RUN apt-get remove -y \
    gcc \
    g++ \
    make

# Configure timezone.sh
ARG TZ
COPY ./scripts /tmp/scripts/
RUN chmod +x -R /tmp/
RUN /tmp/scripts/timezone.sh ${TZ}

RUN /tmp/scripts/composer_installer.sh

USER jenkins