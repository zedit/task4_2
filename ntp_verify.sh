#!/usr/bin/env bash

function ntp_checker() {
  if ! pgrep --full /usr/sbin/ntpd; then
    echo "NOTICE: ntp is not running" 
    /etc/init.d/ntp start
  fi
}

function ntp_conf_checker() {
  local ntp_conf_file="/etc/ntp.conf"
  local ntp_conf_backup="$(dirname $0)/ntp_conf_backup"
  if ! cmp "${ntp_conf_file}" "${ntp_conf_backup}" ; then
    echo "NOTICE: /etc/ntp.conf was changed. Calculated diff:" 
    echo "$(diff -U 0 "${ntp_conf_file}" "${ntp_conf_backup}")"
    cp "${ntp_conf_backup}" "${ntp_conf_file}"
    /etc/init.d/ntp restrat
  fi
}

ntp_checker
ntp_conf_checker
