CFLAGS = -g -O2 -Wall -Werror
INCLUDE = -I./include -I/home/y/include
INCLUDE64 = -I/home/y/include64 $(INCLUDE)

LIBPATH64 = -L/home/y/lib64 -L./x86_64-linux-gcc
LFLAGS64 = -Wl,-rpath,/home/y/lib64 -lm -lzookeeper_st

TARGET_DIR64 = x86_64-linux-gcc

PLATFORMS = `cat PLATFORMS`

all : bin64 package

prep :
	mkdir -p include
	cp ../../src/c/generated/*.h include/
	cp ../../src/c/include/*.h include/
	cp ../../src/c/src/hashtable/*.h include/

bin64 : prep cli_mt.c cli_st.c
	mkdir -p $(TARGET_DIR64)
	ls -l $(TARGET_DIR64)
	cc $(CFLAGS) $(INCLUDE64) -c cli_mt.c -o cli_mt_64.o
	cc $(CFLAGS) $(INCLUDE64) $(LIBPATH64) $(LFLAGS64) cli_mt_64.o -o $(TARGET_DIR64)/cli_mt
	cc $(CFLAGS) $(INCLUDE64) -c cli_st.c -o cli_st_64.o
	cc $(CFLAGS) $(INCLUDE64) $(LIBPATH64) $(LFLAGS64) cli_st_64.o -o $(TARGET_DIR64)/cli_st

package: 
	export PLATFORMS=$(PLATFORMS); cd packages; yinst_create --buildtype=release --debug zookeeper_c_client_dev.yicf
	export PLATFORMS=$(PLATFORMS); cd packages; yinst_create --buildtype=release --debug zookeeper_c_client.yicf
