ROOT=/home/y
MVN=/home/y/bin/mvn

SRCTOP = .

PACKAGE_CONFIG_FILES = yahoo-build/zookeeper_core.yicf
PACKAGE_TARGET_DIR = yahoo-build/

# Rules should be included after vars are set else 
# SD thinks you didn't set PACKAGE_CONFIG or whatever, and makes it *.yicf.

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
	cp GIT_TAG ${SD_ARTIFACTS_DIR}/

copy_test_files:
	mkdir -p ${SD_ARTIFACTS_DIR}/test_results/
	cp build/test/logs/* ${SD_ARTIFACTS_DIR}/test_results/

build: VERSION
	@echo "Building..."
	yinst i -yes -branch test yjava_ant
	sudo yum -y --nogpgcheck install automake cppunit-devel krb5-workstation krb5-libs krb5-auth-dialog
	ls -lrt /usr/share/aclocal/
	ant -Djavac.args=\"-Xlint\" -Dcppunit.m4=/usr/share/aclocal -Dcppunit.lib=/home/y/lib64 -Dtest.junit.output.format=xml -Dversion=`cat BASE_VERSION` clean test tar ; if [ $$? -eq 0 ] ; then $(MAKE) copy_test_files ; else $(MAKE) copy_test_files; false ; fi

package-release: ;yinst_create --buildtype test --platform ${ZOOKEEPER_DIST_OS} ${PACKAGE_CONFIG_FILES} --target yahoo-build

clean::
	rm -rf build
	rm -f BASE_VERSION
	rm -f VERSION
	rm -f C_CLIENT_VERSION
	rm -f GIT_TAG

# push zookeeper_core + zookeeper_c_client packages to rhel6 and rhel7
dist_force_push:
	 for packages in yahoo-build/zookeeper*.tgz; do \
	    /home/y/bin/dist_install -branch test -headless -identity=/home/screwdrv/.ssh/id_dsa -group=zookeeper -batch -nomail -os ${ZOOKEEPER_DIST_OS} $$packages; \
	 done

git_tag:
	./yahoo-build/fetch_git_tag.py
	git tag -f -a `cat GIT_TAG` -m "Adding tag for `cat GIT_TAG`"
	git push origin `cat GIT_TAG`
	@echo "Build Description: `cat GIT_TAG`"

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
	cp yahoo-build/c-client/packages/*.tgz yahoo-build/

