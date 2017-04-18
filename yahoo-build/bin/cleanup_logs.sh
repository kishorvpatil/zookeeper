#!/bin/sh -x

if [ "x${ROOT}" == "x" ]; then
    echo "ROOT not set, assuming /home/y"
    ROOT="/home/y"
fi

PACKAGE_NAME=$1
if [ x$1 = x ]; then
   PACKAGE_NAME=zookeeper_server
fi

DAYSTOKEEP=`yinst env ${PACKAGE_NAME}|grep ${PACKAGE_NAME}__log_retention|cut -f2 -d"="`

if [ x$DAYSTOKEEP = x ]; then
   DAYSTOKEEP=5
fi

DAYSUNTILCOMPRESS=`yinst env ${PACKAGE_NAME}|grep ${PACKAGE_NAME}__log_compress|cut -f2 -d"="`

if [ x$DAYSUNTILCOMPRESS = x ]; then
   DAYSUNTILCOMPRESS=2
fi


SNAPSTOKEEP=`yinst env ${PACKAGE_NAME}|grep ${PACKAGE_NAME}__snapshot_retention|cut -f2 -d"="`

if [ x$SNAPSTOKEEP = x ]; then
   SNAPSTOKEEP=20
fi

CMD="rm -f"
LOG_DIR=${ROOT}/logs/zookeeper
TXN_DIR=${ROOT}/var/zookeeper

echo "Removing log and trace files older than $DAYSTOKEEP days..."
find $LOG_DIR -daystart -type f -ctime +$DAYSTOKEEP -print -exec $CMD {} \;

echo "Compressing log and trace files older than $DAYSUNTILCOMPRESS days..."
find $LOG_DIR -daystart -type f -ctime +$DAYSUNTILCOMPRESS -not -name '*gz' -print -exec gzip {} \;

echo "Removing snapshots prior to $SNAPSTOKEEP most recent..."
if [ "x${JAVA_HOME}" == "x" ]; then
    JAVA_HOME=${ROOT}/share/yjava_jdk/java
fi
CLASSPATH=${ROOT}/lib/jars/zookeeper.jar:${ROOT}/lib/jars/log4j.jar:/home/y/share/jports/org_slf4j__slf4j_api.jar:${ROOT}/share/jports/org_slf4j__slf4j_log4j12.jar:${ROOT}/conf/zookeeper_cleanup
$JAVA_HOME/bin/java -cp $CLASSPATH org.apache.zookeeper.server.PurgeTxnLog $TXN_DIR -n $SNAPSTOKEEP

echo "Cleanup script complete"
