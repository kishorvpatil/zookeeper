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

BASE_VERSION: CHANGES.txt
	grep '^Release' CHANGES.txt | head -1 | awk '{ print $$2 }' > BASE_VERSION

VERSION: BASE_VERSION
	/home/y/bin/auto_increment_version.pl zookeeper_client `cat BASE_VERSION`".y" > VERSION	

build: VERSION
	@echo "Building..."
	ant -Djavac.args=\"-Xlint -Xmaxwarns 1000\" -Dcppunit.m4=/home/y/share/aclocal -Dcppunit.lib=/home/y/lib64 -Dtest.junit.output.format=xml -Dversion=`cat BASE_VERSION` clean test tar
	mkdir test_results/
	cp build/test/logs/* test_results/

clean::
	rm -rf test_results
	rm -rf build
	rm -f BASE_VERSION
	rm -f VERSION
