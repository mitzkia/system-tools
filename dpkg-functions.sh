#!/bin/bash

function install_dpkg_package() {
    command_id="dpkg_install"
    sudo dpkg --install "${package}" \
        2> "${working_dir}/${command_id}_stderr.log" \
        1> "${working_dir}/${command_id}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_stderr.log"
}

function list_apt_packages() {
    command_id="list_apt_packages"
    dpkg -l \
        2> "${working_dir}/${command_id}_${when}_stderr.log" \
        1> "${working_dir}/${command_id}_${when}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_${when}_stderr.log"
}

function is_apt_package_already_installed() {
    dpkg -l | grep "^ii  ${package} "
}