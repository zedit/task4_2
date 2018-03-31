#!/bin/bash

workdir=$(pwd)

function ntp_install() {
  apt-get install -y ntp
}

function ntp_config() {
  local ntp_conf_file="/etc/ntp.conf"
  local ntp_default_servers="ubuntu.pool.ntp.org"
  local ntp_server="pool ua.pool.ntp.org"
  sed -i "/${ntp_default_servers}/d" "${ntp_conf_file}"
  if ! grep "${ntp_server}" "${ntp_conf_file}"; then
    echo "${ntp_server}" >> "${ntp_conf_file}"
  fi
  cp "${ntp_conf_file}" "${workdir}/ntp_conf_backup"
  service ntp restart
}

function cron_config() {
  local cron_config="task"
  local cron_script="${workdir}/ntp_verify.sh"
  echo "MAILTO=root@localhost" >> "${cron_config}"
  echo "*/5 * * * * ${cron_script}" >> "${cron_config}"
  crontab -u $USER "${cron_config}"
  rm "${workdir}/${cron_config}"
}

ntp_install
ntp_config
cron_config
