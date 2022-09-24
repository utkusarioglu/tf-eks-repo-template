#!/bin/bash

source .env 2> /dev/null
source .scripts.config

check_env () {

  if [ -z "$ENVIRONMENT" ];
  then
    echo "Warn: \`.env.ENVIRONMENT\` hasn't been set. Using '$DEFAULT_ENVIRONMENT_NAME' for this script."
    ENVIRONMENT=$DEFAULT_ENVIRONMENT_NAME
  fi
}

check_scripts_config() {
  if [ ! -f ".scripts.config" ];
  then
    echo "Error \`.scripts.config\` file is required to configure the scripts' behavior"
    exit 20
  fi

  source .scripts.config

  if [ -z "$TF_VARS_MAIN_FILE_NAME" ];
  then
    echo "Error: \`.scripts.config.TF_VARS_MAIN_FILE_NAME\` needs to be set for this script to work"
    exit 21
  fi

  if [ ! -f "vars/$TF_VARS_MAIN_FILE_NAME.$ENVIRONMENT.tfvars" ];
  then
    echo "Error: The main tfvars file 'vars/$TF_VARS_MAIN_FILE_NAME.$ENVIRONMENT.tfvars' has to exist for this script to work"
    exit 22
  fi
}

check_ingress_file_config() {
  source .scripts.config

  if [ -z "$TF_VARS_INGRESS_FILE_NAME" ];
  then
    echo "Error: `.scripts.config.TF_VARS_INGRESS_FILE_NAME` needs to be set for this script to work"
    exit 30
  fi

}

check_env
check_scripts_config

MAIN_VAR_FILE="vars/$TF_VARS_MAIN_FILE_NAME.$ENVIRONMENT.tfvars"