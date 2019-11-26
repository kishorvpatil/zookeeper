#!/usr/bin/python

import os
import subprocess

parent_build_id = os.environ["SD_PARENT_BUILD_ID"].split(" ")[0].split("[")[1]

curl_command = """curl -Lsvo  GIT_TAG -H "Authorization: Bearer {0}" "https://api.screwdriver.ouroath.com/v4/builds/{1}/artifacts/GIT_TAG" """.format(os.environ["SD_TOKEN"], parent_build_id)
os.system(curl_command)

build_oses = ["rhel-7.x"]

for build_os in build_oses:
    if not os.path.exists(build_os):
        os.makedirs(build_os)

    build_id = subprocess.check_output(["meta" , "get", "{0}.build_id".format(build_os)])
    build_artifacts = subprocess.check_output(["meta" , "get", "{0}.files".format(build_os)]).split(",")

    for build_artifact in build_artifacts:
        curl_command = """curl -Lsvo  {0}/{1} -H "Authorization: Bearer {2}" "https://api.screwdriver.ouroath.com/v4/builds/{3}/artifacts/{4}" """.format(build_os, build_artifact, os.environ["SD_TOKEN"], build_id, build_artifact)
        print(curl_command)
        os.system(curl_command)

        dist_push_command = """/home/y/bin/dist_install -branch test -headless -identity=/home/screwdrv/.ssh/id_dsa -group=zookeeper -batch -nomail -os {0} {1}/{2};""".format(build_os, build_os, build_artifact)
        print(dist_push_command)
        print(os.listdir(build_os))
        os.system(dist_push_command)
