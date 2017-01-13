#!/bin/sh

APPNAME=zookeeper
PROCNAME=zookeeper

if [ "x${ROOT}" == "x" ]; then
    echo "ROOT not set, assuming /home/y"
    ROOT="/home/y"
fi


# pick up all jars
JARPATH=${ROOT}/lib/jars

# the asterics trick below only works in jdk 1.6.x
# export CLASSPATH=$JARPATH/*

# old-fashioned way to build a classpath
for file in `ls -1 $JARPATH/*.jar`
  do
  CLASSPATH=$file:$CLASSPATH
done

for file in `ls -1 ${ROOT}/share/jports/*.jar 2> /dev/null`
  do
  CLASSPATH=$file:$CLASSPATH
done

# add the config directory for log4j.properties
CLASSPATH=${ROOT}/conf/zookeeper:$CLASSPATH
export CLASSPATH=$CLASSPATH
#echo CLASSPATH=$CLASSPATH

# needed for the native libraries
export LD_LIBRARY_PATH=${ROOT}/lib:$LD_LIBRARY_PATH

if [ "x${ZOO_LOG_DIR}" = "x" ]
then
    ZOO_LOG_DIR="."
fi

if [ "x${ZOO_LOG4J_PROP}" = "x" ]
then
    ZOO_LOG4J_PROP="INFO,CONSOLE"
fi
if [ "x${zookeeper_server}" = "x" ]
then
    ZOO_PARAM="$@"
else
    ZOO_PARAM="-server $zookeeper_server $@"
fi
echo "Starting Zookeeper Cli"
/home/y/share/yjava_jdk/java/bin/java "-Dzookeeper.log.dir=${ZOO_LOG_DIR}" "-Dzookeeper.root.logger=${ZOO_LOG4J_PROP}" \
					-cp "$CLASSPATH" $CLIENT_JVMFLAGS $JVMFLAGS org.apache.zookeeper.ZooKeeperMain $ZOO_PARAM
