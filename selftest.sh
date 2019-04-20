#!/bin/bash

# rm -rf ${HOME}/micek_system_state3/*

source system-tools.sh

remove_packages apt tree mc
search_packages tree mc
install_packages apt tree mc

save_system_state
# update_packages

tree ${HOME}/micek_system_state3