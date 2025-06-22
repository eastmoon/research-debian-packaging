#!/bin/bash
set -e

# Import script
source ./utils.sh

# Declare variable
CONTENT_DIR=/content
PUBLISH_DIR=/publish
PUBLISH_SHELL_DIR=/inst/product

# Execute script

# Clear legacy package
rm -rf ${PUBLISH_DIR}/*

# Copy package script source code
echo "[`date`] Copy package script"
copy ${PUBLISH_SHELL_DIR} ${PUBLISH_DIR}
copy ${PUBLISH_CLI_DIR} ${PUBLISH_DIR}/cli/src

# Copy web services publish binary code
echo "[`date`] Copy web service published from ${CONTENT_DIR} to ${PUBLISH_DIR}"
PUBLISH_MODULE_NAME=app
copy ${CONTENT_DIR} ${PUBLISH_DIR}/${PUBLISH_MODULE_NAME}/content
