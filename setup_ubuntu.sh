#!/bin/bash -x

sudo apt update
sudo apt upgrade -y

sudo apt install --no-install-recommends --yes \
    apt-transport-https \
    ca-certificates \
    curl \
    jq \
    mc \
    openssh-server \
    openssh-client \
    software-properties-common \
    tree \
    vim-tiny \
    wget

PACKAGE_INSTALLS="/home/micek/micek_work/package_installs"
GIT_PROJECTS="/home/micek/git_projects"
mkdir -p ${PACKAGE_INSTALLS}
mkdir -p ${GIT_PROJECTS}

### VSCODE
mkdir -p ${PACKAGE_INSTALLS}/code_install
cd ${PACKAGE_INSTALLS}/code_install
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install --yes code

### I3WM
mkdir -p ${PACKAGE_INSTALLS}/i3_install
cd ${PACKAGE_INSTALLS}/i3_install
/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2019.02.01_all.deb keyring.deb SHA256:176af52de1a976f103f9809920d80d02411ac5e763f695327de9fa6aff23f416
sudo dpkg -i ./keyring.deb
echo "deb https://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
sudo apt update
sudo apt install --yes i3

### GIT
sudo add-apt-repository --yes ppa:git-core/ppa
sudo apt update
sudo apt install --yes git

### DOCKER
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository --yes "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
sudo apt install --yes docker-ce
sudo usermod -aG docker ${USER}

### PYTHON3.8
sudo add-apt-repository --yes ppa:deadsnakes/ppa
sudo apt-get update
sudo apt install --yes python3.8-distutils python3.8
sudo python3.8 -m pip install --user -U
    flake8 \
    pip \
    pre-commit \
    pyflakes \
    pytest \
    pytest-xdist \
    tox

### GitHub - syslog-ng
mkdir -p ${GIT_PROJECTS}/github_mitzkia
cd ${GIT_PROJECTS}/github_mitzkia
git clone https://github.com/mitzkia/syslog-ng.git 
