#!/bin/bash

job_name=(${BUILD_NAME//-/ })
BUILD_BRANCH=${job_name[1]}
BUILD_MACHINE=${job_name[2]}
BUILD_IMAGES="starfish-atsc-flash"
BUILD_REPO_URL="ssh://gpro.lgsvl.com/starfish/build-starfish"
BUILD_PLATFORM="master"

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
    qemux86)
        BUILD_IMAGES="starfish-image"
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

# Check Build Platform
case ${BUILD_BRANCH} in 
    master)
        BUILD_PLATFORM="master"
        ;;
    drd4tv|*dixie*)    
        BUILD_PLATFORM="dreadlocks"
        ;;
esac


# Check Build Branch and Build Repository Url
if [ ! "${BUILD_BRANCH}" = "master" ]; then
    BUILD_BRANCH="@${BUILD_BRANCH}"
    BUILD_REPO_URL="ssh://wall.lge.com/starfish/build-starfish"
fi

MCF_COMMAND=""
echo ${BUILD_BRANCH}
echo ${BUILD_REPO_URL}

if [ -f "${PROJECT_DIRECTORY}/mcf.status" ]; then
    echo "INFO: Exist = ${PROJECT_DIRECTORY}/mcf.status"
    MCF_COMMAND="./mcf --command update"
else
    echo "INFO: New Build Triggered"
    MCF_COMMAND="./mcf -b 44 -p 44 ${BUILD_MACHINE} --premirror=file:///starfish/starfish/${BUILD_PLATFORM}/downloads"
    rm -rf ${PROJECT_DIRECTORY}
    git clone -b "${BUILD_BRANCH}" ${BUILD_REPO_URL} ${PROJECT_DIRECTORY}
fi
pushd ${PROJECT_DIRECTORY}
${MCF_COMMAND}
. ./oe-init-build-env
LC_ALL="en_US.UTF-8" ${BUILD_COMMAND}

set +x
