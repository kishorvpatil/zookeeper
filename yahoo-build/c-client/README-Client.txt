This package contains the Apache ZooKeeper C client interface

ZooKeeper Yinst package version tracks the Apache version number.  We
  use <apacheversion>_<yahoosuffix> e.g. 3.0.0_0 for the first yahoo
  build of Apache ZooKeeper 3.0.0, 3.0.0_1 for the second, and so on.

  Apache ZooKeeper uses versioning of major.minor.patch, where:
    incrementing the major number typically denotes a non-backward compatible 
      change (some migration will usually be necessary when upgrading)
    minor numbers are incremented for new functionality
    patch numbers are incremented for bug fixes

--------------------------------------------------------------------------
Yahoo Specific changes (Apache changelog follows)

Release 3.2.2_0
  Apache ZooKeeper release 3.2.2, detailed release notes here:
    http://hadoop.apache.org/zookeeper/docs/r3.2.2/releasenotes.html

Release 3.1.2_0
  Apache ZooKeeper release 3.1.2, detailed release notes here:
    http://hadoop.apache.org/zookeeper/docs/r3.1.2/releasenotes.html

Release 3.2.1_1
  Apache ZooKeeper Release 3.2.1 with the following fixes applied

  "zookeeper_server should set 'bug-product' and 'bug-component' in yicf."
     http://bug.corp.yahoo.com/show_bug.cgi?id=3164594

Release 3.2.1_0
  Apache ZooKeeper release 3.2.1, detailed release notes here:
    http://hadoop.apache.org/zookeeper/docs/r3.2.1/releasenotes.html

Release 3.2.0_0
  Apache ZooKeeper release 3.2.0, detailed release notes here:
    http://hadoop.apache.org/zookeeper/docs/r3.2.0/releasenotes.html

Release 3.1.1_0
  Apache ZooKeeper release 3.1.1, detailed release notes here:
    http://hadoop.apache.org/zookeeper/docs/r3.1.1/releasenotes.html

  zookeeper_cli_st and zookeeper_cli_mt, executable client shells (st
  is the single threaded while mt is the multithreaded version of the
  shell), is now included in the dev package.

Release 3.1.0_0
  Apache ZooKeeper release 3.1.0, detailed release notes here:
    http://hadoop.apache.org/zookeeper/docs/r3.1.0/releasenotes.html

Release 3.0.1_0
  Apache ZooKeeper Release 3.0.1

Release 3.0.0_1

  Fixed multi-threaded library build (zk_hashtable.c contains MT code)

Release 3.0.0_0

  !!! If you are upgrading to this version (new users can skip) from 2.x
  !!!   or 1.x version of ZooKeeper be sure to read the release notes at:
  !!!     http://hadoop.apache.org/zookeeper/docs/r3.0.0/releasenotes.html
  !!!   Upgrading requires migration of code, data, and potentially config.

  Yinst package versions now track the Apache version number. We use
  a _# suffix on the yinst pkg version. e.g. 3.0.0_0 for the first
  yahoo version of 3.0.0 Apache ZooKeeper

  Updated yicf to support Apache ZooKeeper release structure


--------------------------------------------------------------------------
Apache Changes:

