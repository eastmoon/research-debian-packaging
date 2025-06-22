#!/bin/bash
set -e

## Declare variable
ROOT_DIR=${PWD}
PACKAGE_NAME=${1}
VERSION_CODE=${2}

## Declare function

## Execute script
echo "[`date`] Execute post-package script."

### Copy wrapper script into publish
echo "- Copy script from wrapper folder"
DIST_DIR=${ROOT_DIR}/conf/package
PUB_DIR=${ROOT_DIR}/cache/package
cp -r ${DIST_DIR}/* ${PUB_DIR}
[ -e ${PUB_DIR}/main.sh ] && rm ${PUB_DIR}/main.sh
