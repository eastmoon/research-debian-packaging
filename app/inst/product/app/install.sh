#!/bin/bash
set -e

# declare variable
root=${PWD}

# execute script

## Initial application cli
log-i "Initial application folder"
### Create directory
[ ! -d ${APP_G_DIR} ] && mkdir -p ${APP_G_DIR} || echo-w ${APP_G_DIR} was exist.
[ ! -d ${APP_D_DIR} ] && mkdir -p ${APP_D_DIR} || echo-w ${APP_D_DIR} was exist.

### Install content
log-i "Initial content"
if [ -d ${root}/content ]; then
    copy ${root}/content ${APP_G_DIR}/content
else
    echo-w ${root}/content is not exist.
fi

# Go back to root directroy
cd ${root}
