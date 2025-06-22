#!/bin/bash
set -e

# Import script
source ./utils.sh

## Declare variable
ROOT_DIR=${PWD}
PACKAGE_NAME=${1}

## Declare function

## Execute script
echo "[`date`] Execute package script."

function wrap-compression-package() {
    # Declare variable
    CACHE_PUBLISH=${1}
    CACHE_PACKAGE=${2}
    # Execute script
    ### Calculate checksum number with VERSION.log and combine necessary string
    cd ${CACHE_PUBLISH}
    find /publish -type f | xargs stat -c "%n %s" -- > ${CACHE_PUBLISH}/VERSION.log
    PACKAGE_CHECKSUM=$(python /sha3sum.py ${CACHE_PUBLISH}/VERSION.log 5 | awk '{print $1}')
    PACKAGE_VERSION=${PACKAGE_NAME}-${PACKAGE_CHECKSUM}
    PACKAGE_FILE_NAME=package-${PACKAGE_VERSION}.tgz
    ### Compression
    echo "Compression package : ${PACKAGE_FILE_NAME}"
    cd ${CACHE_PUBLISH}
    echo ${PACKAGE_VERSION} > PACKAGE_VERSION.log
    TARGET_ZIP_DIR=${PWD##*/}
    cd ..
    tar --directory=${TARGET_ZIP_DIR} -zcvf ${CACHE_PACKAGE}/${PACKAGE_FILE_NAME} . > ${CACHE_PACKAGE}/compression-${PACKAGE_FILE_NAME}.log
    cd ${CLI_ROOT_DIR}
}

### Wrapper publish content
if [ -d /publish ]; then
    echo "- Wrap publish"
    wrap-compression-package /publish /package
else
    echo "- No publish need to wrap."
fi
