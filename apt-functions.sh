#!/bin/bash

function install_apt_package() {
    echo -e "\n    \e[33mStarting subtask - install apt package\e[m " "${package}"
    command_id="apt_install"
    sudo apt-get install --yes --no-install-recommends "${package}" \
        2> "${working_dir}/${command_id}_stderr.log" \
        1> "${working_dir}/${command_id}_stdout.log"
    handle_execution_error "${working_dir}/${command_id}_stderr.log"
}

function remove_apt_package() {
    echo -e "\n    \e[33mStarting subtask - remove apt package\e[m " "${package}"
    command_id="apt_remove"
    sudo apt-get remove --purge --yes "${package}" \
        2> "${working_dir}/${command_id}_stderr.log" \
        1> "${working_dir}/${command_id}_stdout.log"
    handle_execution_error "${working_dir}/${command_id}_stderr.log"
}

function autoremove_apt_packages() {
    echo -e "\n    \e[4m\e[93mAutoremove apt packages\e[m "
    command_id="apt_autoremove"
    sudo apt-get autoremove --yes \
        2> "${working_dir}/${command_id}_stderr.log" \
        1> "${working_dir}/${command_id}_stdout.log"
    handle_execution_error "${working_dir}/${command_id}_stderr.log"
}

function update_apt_packages() {
    echo -e "\n    \e[4m\e[93mUpdate apt package index\e[m "
    command_id="apt_update"
    sudo apt-get update \
        2> "${working_dir}/${command_id}_stderr.log" \
        1> "${working_dir}/${command_id}_stdout.log"
    handle_execution_error "${working_dir}/${command_id}_stderr.log"
}

function upgrade_apt_packages_internal() {
    echo -e "\n    \e[4m\e[93mUpgrade apt packages\e[m "
    command_id="apt_upgrade"
    sudo apt-get upgrade --yes \
        2> "${working_dir}/${command_id}_stderr.log" \
        1> "${working_dir}/${command_id}_stdout.log"
    handle_execution_error "${working_dir}/${command_id}_stderr.log"
}

function dist_upgrade_apt_packages() {
    echo -e "\n    \e[4m\e[93mDist-upgrade apt packages\e[m "
    command_id="apt_dist_upgrade"
    sudo apt-get dist-upgrade --yes \
        2> "${working_dir}/${command_id}_stderr.log" \
        1> "${working_dir}/${command_id}_stdout.log"
    handle_execution_error "${working_dir}/${command_id}_stderr.log"
}

function upgrade_apt_packages() {
    update_apt_packages
    upgrade_apt_packages_internal
    dist_upgrade_apt_packages
}

function search_for_apt_package() {
    result=$(apt-cache policy "^${package}$" | grep --color=never "${package}\|Candidate")
    if [[ -n $result ]]; then
        echo -e "\n \e[4m\e[93mFound apt package with version:\e[m "
        echo -e "${result}"
    fi
}

function is_apt_package_exist() {
    apt-cache search "^${package}$"
}