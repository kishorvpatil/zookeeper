ROOT=/home/y
MVN=/home/y/bin/mvn

SRCTOP = .
YAHOO_CFG=/home/y/share/yahoo_cfg
include $(YAHOO_CFG)/Make.defs

PACKAGE_CONFIG_FILES = yahoo-build/zookeeper_core.yicf
PACKAGE_TARGET_DIR = yahoo-build/

# Rules should be included after vars are set else 
# SD thinks you didn't set PACKAGE_CONFIG or whatever, and makes it *.yicf.
include $(YAHOO_CFG)/Make.rules

screwdriver: build native_c_client 

cleanplatforms::

# invoked by build step
platforms:: build native_c_client

BASE_VERSION: RELEASE.txt
	grep '^Release' RELEASE.txt | head -1 | awk '{ print $$2 }' > BASE_VERSION

VERSION: BASE_VERSION
	/home/y/bin/auto_increment_version.pl zookeeper_core `cat BASE_VERSION`".y" > VERSION	
	/home/y/bin/auto_increment_version.pl zookeeper_c_client `cat BASE_VERSION`".y" > C_CLIENT_VERSION
	echo "core."`cat VERSION`"-c.client."`cat C_CLIENT_VERSION` > GIT_TAG

copy_test_files:
	mkdir -p test_results/
	cp build/test/logs/* test_results/

build: VERSION
	@echo "Building..."
	ant -Djavac.args=\"-Xlint -Xmaxwarns 1000\" -Dcppunit.m4=/home/y/share/aclocal -Dcppunit.lib=/home/y/lib64 -Dtest.junit.output.format=xml -Dversion=`cat BASE_VERSION` clean test tar ; if [ $$? -eq 0 ] ; then $(MAKE) copy_test_files ; else $(MAKE) copy_test_files; false ; fi

clean::
	rm -rf test_results
	rm -rf build
	rm -f BASE_VERSION
	rm -f VERSION
	rm -f C_CLIENT_VERSION
	rm -f GIT_TAG

# push only zookeeper_core package to rhel6 and rhel7
dist_force_push:
	for packages in yahoo-build/zookeeper_core-*.tgz; do \
		/home/y/bin/dist_install -branch test -headless -identity=/home/screwdrv/.ssh/id_dsa -group=hadoopqa -batch -nomail -os rhel-6.x $$packages; \
		/home/y/bin/dist_install -branch test -headless -identity=/home/screwdrv/.ssh/id_dsa -group=hadoopqa -batch -nomail -os rhel-7.x $$packages; \
	done

git_tag: VERSION
	git tag -f -a `cat ${SRC_DIR}/GIT_TAG` -m "Adding tag for `cat ${SRC_DIR}/GIT_TAG`"
	git push origin `cat ${SRC_DIR}/GIT_TAG`
	@echo "Build Description: `cat ${SRC_DIR}/GIT_TAG`"

native_c_client:
#   Build libs and binaries
	export PATH=${PATH}:/usr/share/automake-1.11/ ; autoreconf -if src/c/configure.ac ; cd src/c ; ./configure
	make -C src/c clean all

#   Copy libs and binaries
	mkdir -p yahoo-build/c-client/x86_64-linux-gcc
	cp src/c/.libs/libzookeeper_st.so*.*.* yahoo-build/c-client/x86_64-linux-gcc/
	cp src/c/.libs/libzookeeper_mt.so*.*.* yahoo-build/c-client/x86_64-linux-gcc/
	cp src/c/.libs/cli_mt yahoo-build/c-client/x86_64-linux-gcc/
	cp src/c/.libs/cli_st yahoo-build/c-client/x86_64-linux-gcc/

#	Copy headers
	mkdir -p yahoo-build/c-client/include/hashtable
	cp src/c/src/*.h yahoo-build/c-client/include
	cp src/c/include/*.h yahoo-build/c-client/include
	cp src/c/src/hashtable/*.h yahoo-build/c-client/include/hashtable
	cp src/c/generated/*.h yahoo-build/c-client/include
	cp src/c/config.h yahoo-build/c-client/include

#	Build packages
	make -C yahoo-build/c-client/
	cp yahoo-build/c-client/packages/*.tgz ${AUTO_PUBLISH_DIR}
