ROOT=/home/y
MVN=/home/y/bin/mvn

SRCTOP = .
YAHOO_CFG=/home/y/share/yahoo_cfg
include $(YAHOO_CFG)/Make.defs

PACKAGE_CONFIG_FILES = yahoo-build/packages/zookeeper_client.yicf yahoo-build/packages/zookeeper_server.yicf
PACKAGE_TARGET_DIR = $(AUTO_PUBLISH_DIR)

# Rules should be included after vars are set else 
# SD thinks you didn't set PACKAGE_CONFIG or whatever, and makes it *.yicf.
include $(YAHOO_CFG)/Make.rules

screwdriver: build

cleanplatforms::

platforms:: build

build:
	@echo "Building..."
	ant -Djavac.args=\"-Xlint -Xmaxwarns 1000\" -Dcppunit.m4=/home/y/share/aclocal -Dcppunit.lib=/home/y/lib64 -Dtest.junit.output.format=xml -Dversion=3.4.6 clean test tar
