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

function wrap-compression-tgz-package() {
    # Declare variable
    CACHE_PUBLISH=${1}
    CACHE_PACKAGE=${2}
    # Execute script
    ### Calculate checksum number with VERSION.log and combine necessary string
    [ -e ${CACHE_PUBLISH}/VERSION.log ] && rm ${CACHE_PUBLISH}/VERSION.log
    find ${CACHE_PUBLISH} -type f | xargs stat -c "%n %s" -- > ${CACHE_PUBLISH}/VERSION.log
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

function wrap-compression-deb-package() {
    # Declare variable
    CACHE_PUBLISH=${1}
    CACHE_PACKAGE=${2}
    # Execute script
    ### Calculate checksum number with VERSION.log and combine necessary string
    [ -e ${CACHE_PUBLISH}/VERSION.log ] && rm ${CACHE_PUBLISH}/VERSION.log
    find ${CACHE_PUBLISH} -type f | xargs stat -c "%n %s" -- > ${CACHE_PUBLISH}/VERSION.log
    PACKAGE_CHECKSUM=$(python /sha3sum.py ${CACHE_PUBLISH}/VERSION.log 5 | awk '{print $1}')
    PACKAGE_VERSION=${PACKAGE_NAME}-${PACKAGE_CHECKSUM}
    ### Integrate publish content and debian packaging configuration into /tmp/${PACKAGE_NAME}.
    mkdir -p /tmp/${PACKAGE_NAME}/DEBIAN
    #### Configuration control file
    cat > /tmp/${PACKAGE_NAME}/DEBIAN/control <<EOF
Package: ${PACKAGE_NAME}
Version: ${PACKAGE_CHECKSUM}
Architecture: amd64
Description: The ${PACKAGE_NAME} software package.
Maintainer: developer <developer@example.org>
EOF
    #### Configuration postinst file
    cat > /tmp/${PACKAGE_NAME}/DEBIAN/postinst <<EOF
cd /tmp/${PACKAGE_VERSION}
bash run.sh install
EOF
    chmod 775 /tmp/${PACKAGE_NAME}/DEBIAN/postinst
    #### Copy publish to /tmp/${PACKAGE-VERSION}
    copy ${CACHE_PUBLISH} /tmp/${PACKAGE_NAME}/tmp/${PACKAGE_VERSION}
    ### Compression
    echo "Compression package : ${PACKAGE_VERSION} deb file."
    [ ! -d ${CACHE_PACKAGE} ] && mkdir -p ${CACHE_PACKAGE} || true
    dpkg -b /tmp/${PACKAGE_NAME} ${CACHE_PACKAGE}
}


### Wrapper publish content
if [ -d /publish ]; then
    echo "- Wrap publish"
    wrap-compression-tgz-package /publish /package
    wrap-compression-deb-package /publish /package
else
    echo "- No publish need to wrap."
fi
