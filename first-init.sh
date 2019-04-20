#!/bin/bash

source system-tools.sh

save_system_state
update_apt_packages

# install python packages
install_packages apt python3-pip python3-setuptools
install_packages pip pip wheel

# install editors
install_packages apt vim joe

# install tools
install_packages apt mc tree meld jq

# install git packages
install_packages apt git gitk git-gui tig

# install networking packages
install_packages apt openssh-server openssh-client tcpdump

# install developement
install_packages apt gdb strace
install_packages pip pytest

update_packages