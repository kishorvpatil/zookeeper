#!/usr/bin/python

import os


parent_build_id = os.environ["SD_PARENT_BUILD_ID"].split(" ")[0].split("[")[1]

curl_command = """curl -Lsvo  GIT_TAG -H "Authorization: Bearer {}" "https://api.screwdriver.ouroath.com/v4/builds/{}/artifacts/GIT_TAG" """.format(os.environ["SD_TOKEN"], parent_build_id)
os.system(curl_command)
