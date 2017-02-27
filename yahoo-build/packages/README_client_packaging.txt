NAME 
 zookeeper_client -- This package contains the Apache ZooKeeper Client

OPTIONS
  The following yinst configuration parameters are supported:

  zookeeper_client.zookeeper_server
    Specifies the server for which the CLI client will be running against. 
    the zkCli.sh will use the zookeeper_server as host to communicate with.

SYNOPSIS
 To install:
  yinst install zookeeper_client

 To start the Cli client:
  yinst start zookeeper_client

 To check for new packages:
  yinst install zookeeper_client -refresh -dryrun

 To update packages:
  yinst install zookeeper_client -refresh

DESCRIPTION

See the zookeeper_c_client and zookeeper_c_client_dev
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

