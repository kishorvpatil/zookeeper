PLATFORMS = `cat PLATFORMS`

all : package

package: 
	export PLATFORMS=$(PLATFORMS); cd packages; yinst_create --buildtype=release --debug zookeeper_c_client_dev.yicf
	export PLATFORMS=$(PLATFORMS); cd packages; yinst_create --buildtype=release --debug zookeeper_c_client.yicf
