#!/usr/bin/python

import os

artifacts_dir = os.environ["SD_ARTIFACTS_DIR"]

build_artifacts = [f for f in os.listdir(artifacts_dir) if f.endswith(".tgz")]
print(build_artifacts)
print("meta set \"" + os.environ["ZOOKEEPER_DIST_OS"] + "\".build_id {0}".format(os.environ["SD_BUILD_ID"]))
os.system("meta set \"" + os.environ["ZOOKEEPER_DIST_OS"] + "\".build_id {0}".format(os.environ["SD_BUILD_ID"]))
print("meta set \"" + os.environ["ZOOKEEPER_DIST_OS"] + "\".files {0}".format(",".join(build_artifacts)))
os.system("meta set \"" + os.environ["ZOOKEEPER_DIST_OS"] + "\".files {0}".format(",".join(build_artifacts)))