NAME 
 zookeeper_server -- This package contains the Apache ZooKeeper Server

SYNOPSIS
 To install:
  yinst install zookeeper_server

 To check for new packages:
  yinst install zookeeper_server -refresh -dryrun

 To update packages:
  yinst install zookeeper_server -refresh

NETWORK PORTS

By default the ZooKeeper server uses the following ports:

The client port is   2181
The quorum port is   2182
The election port is 2183

The client port can be changed by modifying the installed zookeeper.cfg file.

The quorum and election ports can currently only be changed by turning off
"autostart" and creating your own package that depends on this package, where
your package implements it's own zookeeper_server.sh start/stop script. Note:
all servers in the ensemble must know about every other server's quorum/election
ports before they are started.


OPTIONS
  The following yinst configuration parameters are supported:

  zookeeper_server.quorum

    a comma-delimited list of ZooKeeper nodes participating in the
    quorum (space-delimited also supported, comma preferred
    however). The order of the nodes in this list is important, and it
    must be the same across all the nodes in the quorum. The names
    used must match the `hostname` result on each particular
    system. Note: if this variable is not set, the ZooKeeper server
    will run in the standalone mode, which is typically NOT how you
    want to run in production!

      ex zookeeper_server.quorum=x.yahoo.com,y.yahoo.com
    or
      ex zookeeper_server.quorum="x.yahoo.com y.yahoo.com"

    you may also optionally specify the quorum & election ports explicitly
    which overrides any setting in zookeeper_server.quorumPort and
    zookeeper_server.electionPort (see below)

      ex zookeeper_server.quorum=x.yahoo.com:4182:4183,y.yahoo.com:3181:3183

    notice that this form is only necessary if different ports are used on
    different hosts. this is usually not necessary/advisable. typically you
    should just use the first form of this setting and rely on the (default)
    quorumPort and electionPort settings.

  zookeeper_server.JAVA_HOME 
    Specifies the JAVA_HOME the yjava_jdk was used as a default. 

  zookeeper_server.kerberos 
    if set to true, kerberos settings will be included in the zookeeper.cfg, otherwise it will not be included. it is defaulted to false
  
  zookeeper_server.jvm_mem
    this variable is passed to the jvm as the max heap size (-Xmx)
    if not set the jvm default max heap size is used (ie we don't specify
       -Xmx when on the java command line)

  zookeeper_server.jvm_args
    allows misc args to be passed to the jvm

  zookeeper_server.cron_mailto
    specifies where the cron should should send mail. A cron job is
    run to periodically cleanup the ZooKeeper snapshots, transactional
    logs, and error logs.

    default: $(YINST_INSTALLER)@yahoo-inc.com

  zookeeper_server.log_retention
    specifies the number of days to keep the log4j log files

    default: 5

  zookeeper_server.snapshot_retention
    specifies the number of ZooKeeper snapshot files to retain. snapshot
    files are the on-disk persistent store of the znode information
    (the information being stored in ZooKeeper) Typically the most recent
    snapshot file is used when recovering from a server failure, retaining
    a few snapshot files ensures that a corrupt snapshot file will not
    cause recovery to fail (we would use an earlier snapshot file in that
    case). You should be backing up the ZooKeeper database as part of
    your general backup strategy (in case user error causes the ZK database
    to be lost)

    default: 20

  zookeeper_server.dataDir
    location of the data directory. default is /home/y/var/zookeeper

  zookeeper_server.tickTime
  zookeeper_server.initLimit
  zookeeper_server.syncLimit
  zookeeper_server.snapCount
  zookeeper_server.dataLogDir
  zookeeper_server.clientPort
  zookeeper_server.quourmPort
  zookeeper_server.electionPort
  zookeeper_server.maxClientCnxns
  zookeeper_server.electionAlg
    See the ZooKeeper configuration documents for more
    details. Sensible defaults are provided for the yinst pkg (try
    'yinst set zookeeper_server' for the list), you only need to set
    if you wish to explicitly override the defaults (in general you
    should not need to do this).
    http://hadoop.apache.org/zookeeper/docs/current/zookeeperAdmin.html#sc_configuration

  zookeeper_server.appids
    A comma-separated list of YCA application IDs recongnized by the YMB server.
    This is only useful if you are also using the yca_auth_provider package
    from dist (YCA authentication in ZooKeeper)

  zookeeper_server.mgmt_config_file
    Specify the JMX configuration. See:
    http://java.sun.com/j2se/1.5.0/docs/guide/management/agent.html#properties


ZOOKEEPER CLIENT

Once the package in installed a ZooKeeper client shell can be started by
running the following command on the host:

  java -cp /home/y/lib/jars/zookeeper.jar:/home/y/lib/jars/log4j.jar org.apache.zookeeper.ZooKeeperMain -server localhost:2181


UPGRADING

See the details on changes for the release below, both at the yinst package
level and at the Apache level. See the following link for details on upgrading
a serving cluster: http://wiki.apache.org/hadoop/ZooKeeper/FAQ#A6


DESCRIPTION

The included zookeeper.jar also supports java client development and
  runtime. See the zookeeper_c_client and zookeeper_c_client_dev
  packages if you'd like to interface a C client to the ZooKeeper
  Server.

ZooKeeper Yinst package version tracks the Apache version number.  We
  use <apacheversion>_<yahoosuffix> e.g. 3.0.0_0 for the first yahoo
  build of Apache ZooKeeper 3.0.0, 3.0.0_1 for the second, and so on.

  Apache ZooKeeper uses versioning of major.minor.patch, where:
    incrementing the major number typically denotes a non-backward compatible 
      change (some migration will usually be necessary when upgrading)
    minor numbers are incremented for new functionality
    patch numbers are incremented for bug fixes

SEE ALSO
  ZooKeeper Team (zookeeper-devel@yahoo-inc.com)
    http://yforge.corp.yahoo.com/ui/view?node_id=1908

