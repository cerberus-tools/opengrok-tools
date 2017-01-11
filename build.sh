#!/bin/bash

job_name=(${BUILD_NAME//-/ })
BUILD_BRANCH=${job_name[1]}
BUILD_MACHINE=${job_name[2]}
BUILD_IMAGES="starfish-atsc-flash"

# Set BUILD_IMAGES
case ${BUILD_MACHINE} in
    m16p|m16)
        BUILD_IMAGES="starfish-atsc-flash starfish-arib-flash starfish-dvb-flash"        
        ;;
    m16pbno)
        BUILD_IMAGES="starfish-dvb-flash"
        ;;
    m16plite|m16pstb)
        BUILD_IMAGES="starfish-atsc-flash"
        ;;
    m2r)
        BUILD_IMAGES="starfish-atsc-flash starfish-dvb-flash"
        ;;
    k3lp)
        BUILD_IMAGES="starfish-arib-flash starfish-dvb-flash"
        ;;
    *)
        BUILD_IMAGES="starfish-atsc-flash"
        ;;
esac
set -x
SRC_ROOT="${OPENGROK_INSTANCE_HOME}/src"
DATA_ROOT="${OPENGROK_INSTANCE_HOME}/data"
PROJECT_DIRECTORY="${SRC_ROOT}/${BUILD_NAME}"
#BUILD_COMMAND=". ./oe-init-build-env & bitbake -c patchall ${BUILD_IMAGES}"
BUILD_COMMAND="bitbake -c patchall ${BUILD_IMAGES}"
MCF_COMMAND=""

if [ -f "${PROJECT_DIRECTORY}/mcf.status" ]; then
    echo "INFO: Exist = ${PROJECT_DIRECTORY}/mcf.status"
    MCF_COMMAND="./mcf --command update"
else
    echo "INFO: New Build Triggered"
    MCF_COMMAND="./mcf -b 44 -p 44 ${BUILD_MACHINE} --premirror=file:///starfish/starfish/dreadlocks/downloads"
    rm -rf ${PROJECT_DIRECTORY}
    git clone -b "@${BUILD_BRANCH}" ssh://wall.lge.com/starfish/build-starfish ${PROJECT_DIRECTORY}  
fi
pushd ${PROJECT_DIRECTORY}
${MCF_COMMAND}
. ./oe-init-build-env
${BUILD_COMMAND}

set +x
