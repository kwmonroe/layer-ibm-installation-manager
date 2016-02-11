#!/bin/bash
set -ex

source charms.reactive.sh

# Installation Manager install path
IM_INSTALL_PATH="/opt/IBM/InstallationManager"


# Do the actual IBM IM install
install_installation_manager() {
  #######################
  # TODO: install the Installation Manager from $CHARM_DIR/files/archives/*.zip
  # Multiple architectures can be supported by this charm, so you should
  # include an IM installer for each arch that you want this charm to support (intel, ppc64le, etc).
  #######################
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
  if [ $IM_LICENSE_ACCEPTED != "True" ]; then
    juju-log "Removing IBM IM, as the license agreement is not accepted."

    if [[ -x "${IM_INSTALL_PATH}/uninstall/uninstall" ]]; then
      ${IM_INSTALL_PATH}/uninstall/uninstall --launcher.ini silent-uninstall.ini
      juju-log "IM removal complete"
    else
      juju-log "IM uninstaller was not found (or is not executable)"
    fi

    remove_state 'im.installed'
    return
  fi
}


reactive_handler_main
