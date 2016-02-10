#!/bin/bash
set -ex

source charms.reactive.sh


# Remove IBM IM
remove_unaccepted_software() {
  juju-log "Removing IBM IM (if installed), as the license agreement is not accepted."

  /var/ibm/InstallationManager/uninstall/uninstall --launcher.ini silent-uninstall.ini
  juju-log "IM removal complete"
}

# Do the actual IBM IM install
install_installation_manager() {
  #######################
  # TODO: we have valid credentials, install the Installation Manager
  #######################
}

# Handle changes in charm configuration
im_config_changed() {
  #######################
  # TODO: perform any other actions needed to handle changed configuration
  #######################
}


@when_not 'im.installed'
function install_im() {
  # get configured credentials
  IBM_ID_NAME=`config-get ibm_id_name`
  IBM_ID_PASS=`config-get ibm_id_pass`
  IM_LICENSE_ACCEPTED=`config-get accept_ibm_im_license`
  IM_OFFERING=`config-get im_offering`
  IM_REPO=`config-get im_repo`

  if [ -z $IBM_ID_NAME ]; then
    juju-log "IBM ID username required. Install will " \
             "not continue until you set a value for ibm_id_name."
    status-set blocked "missing ibm_id_name"
    return
  fi
  if [ -z $IBM_ID_PASS ]; then
    juju-log "IBM ID password required. Install will " \
             "not continue until you set a value for ibm_id_pass."
    status-set blocked "missing ibm_id_password"
    return
  fi
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
  fi

  
}


reactive_handler_main
