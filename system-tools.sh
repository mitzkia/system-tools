#!/bin/bash

source apt-functions.sh
source pip-functions.sh
source snap-functions.sh
source dpkg-functions.sh


function install_packages() {
    # has effect on system: yes
    # needs to save state before-after: yes
    # needs to save output: yes
    echo -e "\n> install packages"
    package_manager=$1
    packages=${@:2}
    for package in ${packages}; do
        echo -e "\n \e[4m\e[92mStarting process - install ${package_manager} package:\e[m " "${package}"
        is_package_installable

        if [[ "${result}" == "OK_TO_GO" ]]; then
            create_working_dir "install"
            save_system_state "before"

            if [[ ${package_manager} == "apt" ]]; then
                install_apt_package
            elif [[ ${package_manager} == "pip" ]]; then
                install_pip_package
            elif [[ ${package_manager} == "snap" ]]; then
                install_snap_package
            elif [[ ${package_manager} == "dpkg" ]]; then
                install_dpkg_package
            fi

            save_system_state "after"
            compare_states_before_after
        fi


    done
}

function remove_packages() {
    # has effect on system: yes
    # needs to save state before-after: yes
    # needs to save output: yes
    echo -e "\n> remove packages"
    package_manager=$1
    packages=${@:2}
    for package in ${packages}; do
        echo -e "\n \e[4m\e[92mStarting process - remove ${package_manager} package:\e[m " "${package}"

        create_working_dir "remove"
        save_system_state "before"

        if [[ ${package_manager} == "apt" ]]; then
            remove_apt_package
        elif [[ ${package_manager} == "pip" ]]; then
            remove_pip_package
        elif [[ ${package_manager} == "snap" ]]; then
            remove_snap_package
        fi

        save_system_state "after"
        compare_states_before_after
    done
}

function update_packages() {
    # has effect on system: yes
    # needs to save state before-after: yes
    # needs to save output: yes
    echo -e "\n> update packages"
    create_working_dir "update"
    save_system_state "before"

    upgrade_apt_packages
    upgrade_pip_packages
    upgrade_snap_packages

    save_system_state "after"
    compare_states_before_after
}

function search_packages() {
    # has effect on system: no
    # needs to save state before-after: no
    # needs to save output: no
    packages=${@}
    for package in ${packages}; do
        echo -e "\n \e[4m\e[92mSearch available versions for package:\e[m " "${package}"

        search_for_apt_package
        search_for_pip_package
        search_for_snap_package

    done
}

function save_system_state() {
    # has effect on system: no
    # needs to save state before-after: no
    # needs to save output: yes
    when=$1
    if [[ -z ${when} ]] ; then
        echo -e "\n \e[4m\e[92mStarting process - save system state:\e[m "
        create_working_dir "system_state"
    else
        echo ">>> saving system state ${when}"
    fi

    list_apt_packages
    list_pip_packages
    list_snap_packages
    list_commands
    list_environment_variables
    list_systemd_services
    list_root_etc
    list_home_local
    list_home_config
    list_home_hiddens
    list_apt_cache_policy
    list_apt_key_list
    list_uname
    list_lsb_release
    list_mount
    list_ulimit

    #lsof, netstat, iptables, ps axu, free, sysctl

}

## Helpers
function create_working_dir() {
    action=$1

    root_dir="${HOME}/micek_system_state3"
    now=$(date "+%Y-%m-%d-%H-%M-%S-%s" | cut -b1-24)

    if [[ ${action} == "system_state" ]] || [[ ${action} == "update" ]]; then
        working_dir="${root_dir}/${now}_${action}"
    else
        working_dir="${root_dir}/${now}_${action}_${package}"
    fi

    mkdir -p ${working_dir}
}

function compare_states_before_after() {
    cd "${working_dir}"
    for stdout_file_before in $(ls *before_stdout*); do
        stdout_file_after=$(echo "${stdout_file_before}" | sed 's/before/after/g')
        stdout_file_before_after_diff=$(echo "${stdout_file_before}" | sed 's/before_stdout/before_after_diff/g')

        diff --ignore-all-space "${stdout_file_before}" "${stdout_file_after}" | grep -v "\-\-\-" | sort | grep "^> \|^< " 1> "${stdout_file_before_after_diff}"
        if [[ -s ${stdout_file_before_after_diff} ]]; then
            echo -e "\n    \e[33mFound difference in ${stdout_file_before_after_diff}:\e[m"
            cat "${stdout_file_before_after_diff}"
        fi
    done
}

function handle_execution_error() {
    return_value=$1
    stderr_file=$2
    if [[ ${return_value} -ne 0 ]]; then
        echo "Error occured during execution!!!"
        cat "${stderr_file}"
    fi
}

function is_package_installable() {
    result="OK_TO_GO"
    if [[ ${package_manager} == "apt" ]]; then
        if [[ -n $(is_apt_package_already_installed) ]] || \
           [[ -z $(is_apt_package_exist) ]]; then
            echo -e "\n \e[4m\e[91mThis package is already installed, or does not found in apt repos:\e[m ${package}"
            result="NOT_TO_GO"
        fi
    elif [[ ${package_manager} == "pip" ]]; then
        if [[ -n $(is_pip_package_already_installed) ]] || \
           [[ -z $(is_pip_package_exist) ]]; then
            echo -e "\n \e[4m\e[91mThis package is already installed, or does not found in Pypi:\e[m ${package}"
            result="NOT_TO_GO"
        fi
    elif [[ ${package_manager} == "snap" ]]; then
        if [[ -n $(is_snap_package_already_installed) ]] || \
           [[ -z $(is_snap_package_exist) ]]; then
            echo -e "\n \e[4m\e[91mThis package is already installed, or does not found in Snap:\e[m ${package}"
            result="NOT_TO_GO"
        fi
    fi
}

function list_commands() {
    command_id="list_commands"
    compgen -c | sort | uniq \
        2> "${working_dir}/${command_id}_${when}_stderr.log" \
        1> "${working_dir}/${command_id}_${when}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_${when}_stderr.log"
}

function list_environment_variables() {
    command_id="list_environment_variables"
    printenv | grep -v PWD | sort | uniq \
        2> "${working_dir}/${command_id}_${when}_stderr.log" \
        1> "${working_dir}/${command_id}_${when}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_${when}_stderr.log"
}

function list_systemd_services() {
    command_id="list_systemd_services"
    systemctl -a \
        2> "${working_dir}/${command_id}_${when}_stderr.log" \
        1> "${working_dir}/${command_id}_${when}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_${when}_stderr.log"
}

function list_root_etc() {
    command_id="list_root_etc"
    sudo find /etc/ \
        2> "${working_dir}/${command_id}_${when}_stderr.log" \
        1> "${working_dir}/${command_id}_${when}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_${when}_stderr.log"

}

function list_home_local() {
    command_id="list_home_local"
    find ~/.local/ \
        2> "${working_dir}/${command_id}_${when}_stderr.log" \
        1> "${working_dir}/${command_id}_${when}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_${when}_stderr.log"
}

function list_home_config() {
    command_id="list_home_config"
    find ~/.config/ \
        2> "${working_dir}/${command_id}_${when}_stderr.log" \
        1> "${working_dir}/${command_id}_${when}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_${when}_stderr.log"
}

function list_home_hiddens() {
    command_id="list_home_hiddens"
    cd ${HOME} ; find -mindepth 1 -prune -name '.*' \
        2> "${working_dir}/${command_id}_${when}_stderr.log" \
        1> "${working_dir}/${command_id}_${when}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_${when}_stderr.log"
}

function list_apt_cache_policy() {
    command_id="list_apt_cache_policy"
    apt-cache policy \
        2> "${working_dir}/${command_id}_${when}_stderr.log" \
        1> "${working_dir}/${command_id}_${when}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_${when}_stderr.log"
}

function list_apt_key_list() {
    command_id="list_apt_key_list"
    apt-key list \
        2> "${working_dir}/${command_id}_${when}_stderr.log" \
        1> "${working_dir}/${command_id}_${when}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_${when}_stderr.log"
}

function list_uname() {
    command_id="list_uname"
    uname -a \
        2> "${working_dir}/${command_id}_${when}_stderr.log" \
        1> "${working_dir}/${command_id}_${when}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_${when}_stderr.log"
}

function list_lsb_release() {
    command_id="list_lsb_release"
    lsb_release -a \
        2> "${working_dir}/${command_id}_${when}_stderr.log" \
        1> "${working_dir}/${command_id}_${when}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_${when}_stderr.log"
}

function list_mount() {
    command_id="list_mount"
    mount \
        2> "${working_dir}/${command_id}_${when}_stderr.log" \
        1> "${working_dir}/${command_id}_${when}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_${when}_stderr.log"
}

function list_ulimit() {
    command_id="list_ulimit"
    ulimit -a \
        2> "${working_dir}/${command_id}_${when}_stderr.log" \
        1> "${working_dir}/${command_id}_${when}_stdout.log"
    handle_execution_error $? "${working_dir}/${command_id}_${when}_stderr.log"
}
