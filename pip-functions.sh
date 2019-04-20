#!/bin/bash

function install_pip_package() {
    command_id="pip_install"
    sudo -H python3 -m pip install --upgrade "${package}" \
        2> "${working_dir}/${command_id}_stderr.log" \
        1> "${working_dir}/${command_id}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_stderr.log"
}

function remove_pip_package() {
    command_id="pip_remove"
    sudo -H python3 -m pip uninstall --yes "${package}" \
        2> "${working_dir}/${command_id}_stderr.log" \
        1> "${working_dir}/${command_id}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_stderr.log"
}

function upgrade_pip_packages() {
    command_id="pip_upgrade"
    outdated_packages=$(python3 -m pip list --outdated | grep -v "Package\|---\|httplib2\|pexpect\|pycairo\|pycups\|pygobject\|pyxdg\|PyYAML\|simplejson" | awk -F" " '{print $1}')
    for package in ${outdated_packages}; do
        sudo -H python3 -m pip install --upgrade "${package}" \
            2> "${working_dir}/${command_id}_${package}_stderr.log" \
            1> "${working_dir}/${command_id}_${package}_stdout.log"
        handle_execution_error $? "${working_dir}/${command_id}_${package}_stderr.log"
    done;
}

function search_for_pip_package() {
    result=$(sudo -H python3 -m pip search "${package}" | grep --color=never -P "^${package} ")
    if [[ -n $result ]]; then
        echo -e "\n \e[92mFound pip package with version:\e[m "
        echo -e "${result}"
    fi
}

function list_pip_packages() {
    command_id="list_pip_packages"
    python3 -m pip list \
        2> "${working_dir}/${command_id}_${when}_stderr.log" \
        1> "${working_dir}/${command_id}_${when}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_${when}_stderr.log"
}

function is_pip_package_already_installed() {
    python3 -m pip list | grep --color=never -P "^${package} "
}

function is_pip_package_exist() {
    python3 -m pip search "${package}" | grep --color=never -P "^${package} "
}