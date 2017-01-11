#!/usr/bin/env python3
import os
import sys
import subprocess

opengrok_instance_home = "/vol/users/gatekeeper.tvsw/temp/opengrok-opengrok-starfish-drd4tv"
script_directory = "/vol/users/gatekeeper.tvsw/program/opengrok-main"

build_images = {
        "m16p": "starfish-atsc-flash starfish-arib-flash starfish-dvb-flash",
        "m16pbno": "starfish-dvb-flash",
        "m16plite": "starfish-atsc-flash",
        "m16pstb": "starfish-atsc-flash",
        "m16": "starfish-atsc-flash starfish-arib-flash starfish-dvb-flash",
        "m2r": "starfish-atsc-flash starfish-dvb-flash",
        "k3lp": "starfish-arib-flash starfish-dvb-flash"
}

if __name__ ==  "__main__":
    job_name = os.environ["BUILD_NAME"]
    build_branch = job_name.split("-")[1]
    build_machine = job_name.split("-")[-1]
    src_root = opengrok_instance_home + "/src"
    data_root = opengrok_instance_home + "/data"
    project_directory = src_root + "/" + job_name
    print("INFO: Project directory = %s" % project_directory)
    build_command = " . ./oe-init-build-env && bitbake -c patchall " + build_images[build_machine]
    print("INFO: Build command = %s" % build_command)
    
    print("INFO: Run mcf && build ")
    mcf_command = ""
    
    if os.path.isfile(project_directory + "/mcf.status"):
        print("INFO: Exist = %s" % project_directory + "/mcf.status")
        mcf_command = "./mcf --command update"
    else:
        print("INFO: New Build Triggered")
        mcf_command = "./mcf -b 0 -p 0 {} --premirror=file:///starfish/starfish/dreadlocks/downloads".format(build_machine)
        subprocess.check_call("rm -rf " + project_directory, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        # 29         sh "git clone -b @drd4tv ssh://wall.lge.com/starfish/build-starfish " + PROJECT_DIRECTORY
        subprocess.check_call("git clone -b @{} ssh://wall.lge.com/starfish/build-starfish {}".format(build_branch, project_directory), shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    # Run mcf command
    subprocess.check_call("cd {} && {}".format(project_directory, mcf_command), shell=True)
    subprocess.check_call("cd {} && {}".format(project_directory, build_command), shell=True)

