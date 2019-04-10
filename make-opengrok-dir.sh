#!/bin/bash
set -x
OPENGROK_INSTANCE_BASE=${1}
OPENGROK_DIST_BASE=${2}
OPENGRON_CONTEXT=${3}

[ "${OPENGRON_CONTEXT}" = "" ] && OPENGRON_CONTEXT="source"
[ "${TOMCAT_HOST}" = "" ] && TOMCAT_HOST="localhost"
[ "${TOMCAT_PORT}" = "" ] && TOMCAT_PORT="8080"
[ "${TOMCAT_USER}" = "" ] && TOMCAT_USER="tomcat"
[ "${TOMCAT_PASS}" = "" ] && TOMCAT_PASS="lge123"
TOMCAT_HOME=$(dirname `which catalina.sh`)/..

# Check if OpenGrok tools exist or not 
# If not, install it from tar ball file.
if which opengrok-indexer ; 
then
    echo  "INFO: OpenGrok tools exist"
else
    echo  "ERROR: OpenGrok tools don't exist."
    if which python3 ; 
    then
        echo  "INFO: python3 exists"
        python3 -m pip install --user ${OPENGROK_DIST_BASE}/tools/opengrok-tools.tar.gz
    else
        echo  "ERROR: Install python3 before installing opengrok tools"
        exit 1
    fi
fi
# Create a data directory for an instance
rm -rf ${OPENGROK_INSTANCE_BASE}/
mkdir -p ${OPENGROK_INSTANCE_BASE}/data/
mkdir -p ${OPENGROK_INSTANCE_BASE}/src/
mkdir -p ${OPENGROK_INSTANCE_BASE}/etc/

# Get codes from a remote server to a local source directory
pushd ${OPENGROK_INSTANCE_BASE}/src
git clone https://github.com/jenkinsci/gerrit-trigger-plugin.git
popd

#java -Djava.util.logging.config.file=${OPENGROK_INSTANCE_BASE}/logging.properties \
#    -jar ${OPENGROK_DIST_BASE}/lib/opengrok.jar \
#    -c $(whch ctags) \
#    -s ${OPENGROK_INSTANCE_BASE}/src -d ${OPENGROK_INSTANCE_BASE}/data -H -P -S -G \
#    -W ${OPENGROK_INSTANCE_BASE}/etc/configuration.xml

# -H -S

# Index all projects
opengrok-indexer -J=-Djava.util.logging.config.file=${OPENGROK_INSTANCE_BASE}/logging.properties \
    -a ${OPENGROK_DIST_BASE}/lib/opengrok.jar -- \
    -c $(which ctags) \
    -s ${OPENGROK_INSTANCE_BASE}/src -d ${OPENGROK_INSTANCE_BASE}/data -P -G \
    -H -S \
    -W ${OPENGROK_INSTANCE_BASE}/etc/configuration.xml

curl --user ${TOMCAT_USER}:${TOMCAT_PASS} http://${TOMCAT_HOST}:${TOMCAT_PORT}/manager/text/undeploy?path=/${OPENGRON_CONTEXT}
rm -rf ${TOMCAT_HOME}/webapps/${OPENGRON_CONTEXT}*
sleep 3
opengrok-deploy -c ${OPENGROK_INSTANCE_BASE}/etc/configuration.xml ${OPENGROK_DIST_BASE}/lib/source.war ${TOMCAT_HOME}/webapps/${OPENGRON_CONTEXT}.war
set +x
