node('master'){
    stage 'get codes'
    SRC_ROOT = OPENGROK_INSTANCE_HOME + "/src"
    DATA_ROOT = OPENGROK_INSTANCE_HOME + "/data"
    PROJECT_NAME = JOB_NAME.split('/')[1]
    PROJECT_DIRECTORY =  SRC_ROOT + "/" + PROJECT_NAME
    echo PROJECT_DIRECTORY
    //sh 'cd ~/temp && git clone -b @drd4tv ssh://wall.lge.com/starfish/build-starfish'
    stage 'Run mcf'
    echo JOB_NAME.split('/')[1]
    //sh 'cd ~/temp/build-starfish && ./mcf -b 0 -p 0 m16p --premirror=file:///starfish/starfish/dreadlocks/downloads/'
    stage 'Run build'
    echo JOB_NAME.split('/')[1]
    //sh 'cd ~/temp/build-starfish && . ./oe-init-build-env && bitbake -c patchall starfish-atsc-flash '
}