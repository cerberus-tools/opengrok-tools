node('master'){
    //PROJECT_NAME = "starfish-drd4tv-m16p"
    BUILD_IMAGES = [
        "m16p": "starfish-atsc-flash starfish-arib-flash starfish-dvb-flash",
        "m16pbno": "starfish-dvb-flash",
        "m16plite": "starfish-atsc-flash",
        "m16pstb": "starfish-atsc-flash",
        "m16": "starfish-atsc-flash starfish-arib-flash starfish-dvb-flash",
        "m2r": "starfish-atsc-flash starfish-dvb-flash",
        "k3lp": "starfish-arib-flash starfish-dvb-flash"
    ]

    stage 'get codes'
    SRC_ROOT = OPENGROK_INSTANCE_HOME + "/src"
    DATA_ROOT = OPENGROK_INSTANCE_HOME + "/data"
    //PROJECT_NAME = JOB_NAME.split('/')[1]
    //PROJECT_NAME = "starfish-drd4tv-m16p"
    PROJECT_DIRECTORY =  SRC_ROOT + "/" + PROJECT_NAME
    BUILD_BRANCH = PROJECT_NAME.split("-")[1]
    BUILD_MACHINE = PROJECT_NAME.split("-")[2]
    echo "INFO: Project directory = " + PROJECT_DIRECTORY
    BUILD_COMMAND = " . ./oe-init-build-env && bitbake -c patchall " + BUILD_IMAGES[BUILD_MACHINE]
    echo "INFO: Build command = " + BUILD_COMMAND

    stage 'Run mcf'
    def mcf_command = ""
    if ( fileExists(PROJECT_DIRECTORY + "/mcf.status" ) ) {
        echo "INFO: Exist = " + PROJECT_DIRECTORY
        mcf_command = "./mcf --command update"
    } else {
        sh "rm -rf " + PROJECT_DIRECTORY        
        sh "git clone -b @drd4tv ssh://wall.lge.com/starfish/build-starfish " + PROJECT_DIRECTORY
        mcf_command = "./mcf -b 0 -p 0 " +  BUILD_MACHINE + " --premirror=file:///starfish/starfish/dreadlocks/downloads"
    }

    stage 'Run build'
    sh " cd " + PROJECT_DIRECTORY + " && " +  mcf_command + " && " + BUILD_COMMAND

    echo "END"
}
