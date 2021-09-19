#!/bin/bash
TZ=$1;

if ! test -z $TZ
then
  rm -f /etc/localtime;
  ln -s /usr/share/zoneinfo/$TZ /etc/localtime;
  echo $TZ > /etc/timezone;
  dpkg-reconfigure --frontend noninteractive tzdata;
else
  echo "Current timezone is universal UTC"
fi