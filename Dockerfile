FROM jenkins/jenkins:latest

FROM jenkins/jenkins:latest as builder
ARG TARGET_NODEJS_VERSION=16

LABEL version="2.0"
LABEL description="Jenkins in Docker with php 8.1 and aditional plugins"

USER root
RUN curl -sL https://deb.nodesource.com/setup_${TARGET_NODEJS_VERSION}.x | bash -

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    tzdata \
    wget \
    apt-transport-https \
    lsb-release \
    ca-certificates \
    apt-utils \
    gcc \
    g++ \
    make \
    nodejs

RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
  echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
  apt-get -qq update && apt-get -qqy upgrade

FROM builder as installerphp
ARG TARGET_PHP_VERSION=8.1
RUN apt-get install -y \
    php${TARGET_PHP_VERSION}  \
    php${TARGET_PHP_VERSION}-apcu \
    php${TARGET_PHP_VERSION}-mbstring  \
    php${TARGET_PHP_VERSION}-curl \
    php${TARGET_PHP_VERSION}-gd \
    php${TARGET_PHP_VERSION}-imagick \
    php${TARGET_PHP_VERSION}-intl \
    php${TARGET_PHP_VERSION}-bcmath \
    php${TARGET_PHP_VERSION}-mysql \
    php${TARGET_PHP_VERSION}-xdebug \
    php${TARGET_PHP_VERSION}-xml \
    php${TARGET_PHP_VERSION}-zip curl

FROM builder as installerplugins
COPY plugins.yaml /usr/share/jenkins/ref/plugins.yaml
RUN jenkins-plugin-cli --verbose -f /usr/share/jenkins/ref/plugins.yaml

FROM installerphp as cleaningbuild
RUN apt-get remove -y \
    gcc \
    g++ \
    make

FROM cleaningbuild as additionalconfiguration
# Configure timezone.sh
ARG TZ
COPY ./scripts /tmp/scripts/
RUN chmod +x -R /tmp/
RUN /tmp/scripts/timezone.sh ${TZ}
RUN /tmp/scripts/composer_installer.sh
USER jenkins