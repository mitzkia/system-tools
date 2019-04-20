#!/bin/bash

function install_pip_package() {
    echo -e "\n    \e[33mStarting subtask - install pip package\e[m " "${package}"
    command_id="pip_install"
    sudo -H python3 -m pip install --upgrade "${package}" \
        2> "${working_dir}/${command_id}_stderr.log" \
        1> "${working_dir}/${command_id}_stdout.log"
    handle_execution_error "${working_dir}/${command_id}_stderr.log"
}

function remove_pip_package() {
    echo -e "\n    \e[33mStarting subtask - remove pip package\e[m " "${package}"
    command_id="pip_remove"
    sudo -H python3 -m pip uninstall --yes "${package}" \
        2> "${working_dir}/${command_id}_stderr.log" \
        1> "${working_dir}/${command_id}_stdout.log"
    handle_execution_error "${working_dir}/${command_id}_stderr.log"
}

function upgrade_pip_packages() {
    echo -e "\n    \e[4m\e[93mUpgrade pip packages\e[m "
    command_id="pip_upgrade"
    all_packages=$(python3 -m pip list | grep -v "Package\|---\|httplib2\|pexpect\|pycairo\|pycups\|pygobject\|pyxdg\|PyYAML\|simplejson" | awk -F" " '{print $1}')
    for package in ${all_packages}; do
        sudo -H python3 -m pip install --upgrade "${package}" \
            2> "${working_dir}/${command_id}_${package}_stderr.log" \
            1> "${working_dir}/${command_id}_${package}_stdout.log"
        handle_execution_error "${working_dir}/${command_id}_${package}_stderr.log"
    done;
}

function search_for_pip_package() {
    result=$(sudo -H python3 -m pip search "${package}" | grep --color=never -P "^${package} ")
    if [[ -n $result ]]; then
        echo -e "\n \e[4m\e[93mFound pip package with version:\e[m "
        echo -e "${result}"
    fi
}

function list_pip_packages() {
    command_id="list_pip_packages"
    python3 -m pip list \
        2> "${working_dir}/${command_id}_${when}_stderr.log" \
        1> "${working_dir}/${command_id}_${when}_stdout.log"
    handle_execution_error "${working_dir}/${command_id}_${when}_stderr.log"
}

function is_pip_package_already_installed() {
    python3 -m pip list | grep --color=never -P "^${package} "
}

function is_pip_package_exist() {
    python3 -m pip search "${package}" | grep --color=never -P "^${package} "
}