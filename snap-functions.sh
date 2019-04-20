#!/bin/bash

function install_snap_package() {
    command_id="snap_install"
    sudo snap install "${package}" \
        2> "${working_dir}/${command_id}_stderr.log" \
        1> "${working_dir}/${command_id}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_stderr.log"
}

function remove_snap_package() {
    command_id="snap_remove"
    sudo snap remove "${package}" \
        2> "${working_dir}/${command_id}_stderr.log" \
        1> "${working_dir}/${command_id}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_stderr.log"
}

function upgrade_snap_packages() {
    command_id="snap_upgrade"
    sudo snap refresh \
        2> "${working_dir}/${command_id}_stderr.log" \
        1> "${working_dir}/${command_id}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_stderr.log"
}

function search_for_snap_package() {
    result=$(snap search "${package}" 2>/dev/null | grep --color=never "^${package} ")
    if [[ -n $result ]]; then
        echo -e "\n \e[92mFound snap package with version:\e[m "
        echo -e "${result}"
    fi
}

function list_snap_packages() {
    command_id="list_snap_packages"
    snap list \
        2> "${working_dir}/${command_id}_${when}_stderr.log" \
        1> "${working_dir}/${command_id}_${when}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_${when}_stderr.log"
}

function is_snap_package_already_installed() {
    snap list | grep --color=never -P "^${package} "
}

function is_snap_package_exist() {
    snap search "${package}" | grep --color=never -P "^${package} "
}