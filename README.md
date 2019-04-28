# About the project

## The main goals of this project

* To give a general interface for using various package managers of Ubuntu
* To give a detailed description about the changes on the system after a certain package manager commands

### Supported package managers

* apt
* pip
* snap
* dpkg

## Saving Debian based OS level states

* List of installed packages
* List of installed commands
* List of installed environment variables

## High level functions

### 1. install_packages

Description:

* With this function we can install package or packages with the supported package managers.

How to use:

* Execution format:

  * install_packages [name of the package manager] [list of the installed packages]

```shell
$ install_packages apt mc vim
 Starting process - install apt package:  mc

    Install apt package:  mc

    Found difference in list_apt_packages_before_after_diff.log:
> ii  mc                                         3:4.8.19-1                                   amd64        Midnight Commander - a powerful file manager
> ii  mc-data                                    3:4.8.19-1                                   all          Midnight Commander - a powerful file manager -- data files

    Found difference in list_commands_before_after_diff.log:
> mc
> mcdiff
> mcedit
> mcview
> view

 Starting process - install apt package:  vim

    Install apt package:  vim

    Found difference in list_apt_packages_before_after_diff.log:
< rc  vim-common                                 2:8.0.1453-1ubuntu1                          all          Vi IMproved - Common files
< rc  vim-runtime                                2:8.0.1453-1ubuntu1                          all          Vi IMproved - Runtime files
> ii  vim                                        2:8.0.1453-1ubuntu1                          amd64        Vi IMproved - enhanced vi editor
> ii  vim-common                                 2:8.0.1453-1ubuntu1                          all          Vi IMproved - Common files
> ii  vim-runtime                                2:8.0.1453-1ubuntu1                          all          Vi IMproved - Runtime files

    Found difference in list_commands_before_after_diff.log:
> ex
> helpztags
> rview
> rvim
> vi
> vim
> vim.basic
> vimdiff
> vimtutor
```

Understanding the result:

### 2. remove_packages
