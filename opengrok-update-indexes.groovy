node('master') {
    paralle(
        "starfish-drd4tv-m16pbno": {
            build job: 'starfish-patchall', parameters: [
                string(name: 'OPENGROK_INSTANCE_HOME', value: '/vol/users/gatekeeper.tvsw/program/opengrok-opengrok-starfish-drd4tv'), 
                string(name: 'SCRIPT_DIRECTORY', value: '/vol/users/gatekeeper.tvsw/program/opengrok-main'), 
                string(name: 'PROJECT_NAME', value: 'starfish-drd4tv-m16pbno')
            ]
        }
    )

}
