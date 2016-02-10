#!/bin/bash
set -ex

source charms.reactive.sh


# Do the actual IBM IM install
install_installation_manager() {
  #######################
  # TODO: install the Installation Manager
  #######################
}


# Remove IBM IM
remove_unaccepted_software() {
  juju-log "Removing IBM IM (if installed), as the license agreement is not accepted."

  if [[ -x "/var/ibm/InstallationManager/uninstall/uninstall" ]]; then
    /var/ibm/InstallationManager/uninstall/uninstall --launcher.ini silent-uninstall.ini
    juju-log "IM removal complete"
  else
    juju-log "IM uninstaller was not found (or is not executable)"
  fi
}


@when_not 'im.installed'
function install_im() {
  IM_LICENSE_ACCEPTED=`config-get accept_ibm_im_license`

  if [ $IM_LICENSE_ACCEPTED != "True" ]; then
    juju-log "IBM Installation Manager license must be accepted " \
             "Installation will not continue until you set " \
             "accept_ibm_im_license to True."
    status-set blocked "missing accept_ibm_im_license"
    return
  fi

  install_installation_manager

  set_state 'im.installed'
  status-set active "IBM IM installed"
}

@when 'im.installed'
function check_im_config() {
  IM_LICENSE_ACCEPTED=`config-get accept_ibm_im_license`

  # If we were installed and our license is no longer accepted, uninstall IM.
  if [ ! ${IM_LICENSE_ACCEPTED} ]; then
    remove_unaccepted_software
    remove_state 'im.installed'
    return
  fi
}


reactive_handler_main
