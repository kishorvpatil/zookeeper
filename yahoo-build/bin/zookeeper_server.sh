#!/bin/sh

APPNAME=zookeeper
PROCNAME=zookeeper

if [ "x${ROOT}" == "x" ]; then
    echo "ROOT not set, assuming /home/y"
    ROOT="/home/y"
fi

PIDFILE=${ROOT}/var/run/${APPNAME}/${PROCNAME}.pid
PID_STOPFILE=${ROOT}/var/run/${APPNAME}/${PROCNAME}.stop

CFG=${ROOT}/conf/zookeeper/zookeeper.cfg

# pick up all jars
JARPATH=${ROOT}/lib/jars

# the asterics trick below only works in jdk 1.6.x
# export CLASSPATH=$JARPATH/*

# old-fashioned way to build a classpath
for file in zookeeper.jar
do
  CLASSPATH=${JARPATH}/${file}:${CLASSPATH}
done

for file in org_slf4j__slf4j_api.jar log4j__log4j.jar org_slf4j__slf4j_log4j12.jar
do
  CLASSPATH=/home/y/share/jports/${file}:${CLASSPATH}
done

# add the config directory for log4j.properties
CLASSPATH=${ROOT}/conf/zookeeper:$CLASSPATH
export CLASSPATH=$CLASSPATH
#echo CLASSPATH=$CLASSPATH

# needed for the native libraries
export LD_LIBRARY_PATH=$zookeeper_server__libpath:$LD_LIBRARY_PATH

DEBUG_LEVEL="-Ddebug.level=DEBUG,CONSOLE"

if [ -n "$zookeeper_server__trace" ]; then
    DEBUG_LEVEL="-Ddebug.level=TRACE,CONSOLE,TRACEFILE -Dtrace.file=$zookeeper_server__trace"
fi

case "$2" in 
	"START") 
            # Don't start ${PROCNAME} if it's already running
        if [ -e ${PIDFILE} ]; then
            FILE_PID=`cat ${PIDFILE}`
            OS_PID=`ps -p $FILE_PID -o pid=`

            if [ "x$OS_PID" = "x" ]; then
                OS_PID=-1
            fi

            if [ $OS_PID = $FILE_PID ]; then
                echo "${PROCNAME} is already running"
                exit 1
            else
                echo "removing orphaned ${PROCNAME}.pid file"
                rm ${PIDFILE}
            fi
        fi

        rm -f ${PID_STOPFILE}

        if [ -n "$zookeeper_server__dataDir" ]; then
            #ensure the datadir and datalogdir exist
            DATADIR=$zookeeper_server__dataDir
            MYID=$DATADIR/myid

            echo "Overriding dataDir as ${DATADIR}"

            if [ ! -d $DATADIR ]; then
                mkdir $DATADIR
                chown yahoo:wheel $DATADIR
            fi

            if [ ! -e $MYID ]; then
                ln -s ${ROOT}/var/zookeeper/myid $MYID
                chown yahoo:wheel $MYID
            fi

        else
            DATADIR=${ROOT}/var/zookeeper
            MYID=$DATADIR/myid
        fi

        if [ -n "$zookeeper_server__dataLogDir" ]; then
            if [ ! -d "$zookeeper_server__dataLogDir" ]; then
                mkdir $zookeeper_server__dataLogDir
                chown yahoo:wheel $zookeeper_server__dataLogDir
            fi
        fi

        if [ -n "$zookeeper_server__quorum" ]; then
            echo "Starting quorum Zookeeper server"
            echo "Participants: $zookeeper_server__quorum"
            if [ ! -r $MYID ]; then
                echo "This host (" `hostname` ") is not in yinst set zookeeper_server.quorum variable ( $zookeeper_server__quorum ). Cannot start zookeeper."
                exit 1
            fi
        else
            echo "Starting stand-alone Zookeeper server"
        fi


        if [ -n "$zookeeper_server__appids" ]; then
            echo "Enabled YCA appIds: $zookeeper_server__appids"
            YCA="-Dzookeeper.authProvider.1=com.yahoo.zookeeper.server.auth.YCAAuthenticationProvider -Dzookeeper.yca.appIds=$zookeeper_server__appids"
        fi

        if [ -n "$zookeeper_server__mgmt_config_file" ]; then
            JVM_MONITOR="-Dcom.sun.management.config.file=$zookeeper_server__mgmt_config_file"
        fi

        if [ -n "$zookeeper_server__jvm_mem" ]; then
            JVM_MEM="-Xmx$zookeeper_server__jvm_mem"
        fi
        
        if [ -n "$zookeeper_server__jvm_args" ]; then
            JVM_ARGS="$zookeeper_server__jvm_args"
        fi
        
        ZK_CMD="${JAVA_HOME}/bin/java -server $JVM_MEM $JVM_ARGS $YCA $JVM_MONITOR $DEBUG_LEVEL org.apache.zookeeper.server.quorum.QuorumPeerMain $CFG"
		
        /bin/echo "nohup ${ROOT}/bin64/exmon -n zookeeper -d 1 -o ${ROOT}/logs/zookeeper/%s.%Y.%m.%d.out -e ${ROOT}/logs/zookeeper/%s.%Y.%m.%d.err -l ${ROOT}/var/run/zookeeper $ZK_CMD </dev/null >/dev/null 2>/dev/null &" | /bin/su -m yahoo

        sleep 3

        ;;

	"STOP")	
        # Touching this file tells exmon to not restart ${PROCNAME} even if it exits with a non-zero status
        touch ${PID_STOPFILE}

        # Stop ${PROCNAME} only if its running 

        if [ -e ${PIDFILE} ]; then
            FILE_PID=`cat ${PIDFILE}`
            OS_PID=`ps -p $FILE_PID -o pid=`

            if [ "x$OS_PID" = "x" ]; then
                OS_PID=-1
            fi

            if [ $OS_PID != $FILE_PID ]; then
                echo "${PROCNAME} is not running, removing orphaned ${PROCNAME}.pid file"
                rm ${PIDFILE}
                exit 0
            fi

            kill $FILE_PID
        else
            echo "${PROCNAME} is not running"
            exit 0
        fi

        # Wait for the ${PROCNAME} process to exit before returning.

        # TODO: send a kill -9 after waiting n seconds

        OS_PID=$FILE_PID

        until [ $OS_PID != $FILE_PID ]; do
            sleep 1
            OS_PID=`ps -p $FILE_PID -o pid=`

            if [ "x$OS_PID" = "x" ]; then
                OS_PID=-1
            fi
        done

        rm ${PIDFILE}

		exit 0
		;;
esac
