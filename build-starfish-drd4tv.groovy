node('master'){
    stage 'get codes'
    SRC_ROOT = OPENGROK_INSTANCE_HOME + "/src"
    DATA_ROOT = OPENGROK_INSTANCE_HOME + "/data"
    PROJECT_NAME = JOB_NAME.split('/')[1]
    PROJECT_DIRECTORY =  SRC_ROOT + "/" + PROJECT_NAME
    echo "INFO: Project directory = " + PROJECT_DIRECTORY
    //sh 'cd ~/temp && git clone -b @drd4tv ssh://wall.lge.com/starfish/build-starfish'
    stage 'Run mcf'
    
    def mcf_command = ""
    if ( fileExists(PROJECT_DIRECTORY + "/mcf.status" ) ) {
        echo "INFO: Exist = " + PROJECT_DIRECTORY
        mcf_command = "./mcf --command update"
    } else {
        sh "rm -rf " + PROJECT_DIRECTORY        
        sh "git clone -b @drd4tv ssh://wall.lge.com/starfish/build-starfish " + PROJECT_DIRECTORY
        mcf_command = "./mcf -b 0 -p 0 m16p --premirror=file:///starfish/starfish/dreadlocks/downloads"
    }
    sh "cd " + PROJECT_DIRECTORY + " && " + mcf_command
    stage 'Run build'
    echo JOB_NAME.split('/')[1]
    echo "END"
}
