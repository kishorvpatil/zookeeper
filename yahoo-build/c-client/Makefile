#include /home/y/share/yahoo_cfg/Make.defs
#
#SUBDIRS     = st mt
#ZOO_ROOT    = ../apache_release/src/c
#
#include /home/y/share/yahoo_cfg/Make.rules
#
#copy:
#	- mkdir -p include/hashtable
#	cp $(ZOO_ROOT)/generated/*.h include
#	cp $(ZOO_ROOT)/src/*.h include
#	cp -r $(ZOO_ROOT)/src/hashtable/*.h include/hashtable
#	cp $(ZOO_ROOT)/include/*.h include
#	cp $(ZOO_ROOT)/config.h include
#	$(MAKE) $(MAKEFILEARG) -C st $@
#	$(MAKE) $(MAKEFILEARG) -C mt $@

CFLAGS = -g -O2 -Wall -Werror
INCLUDE = -I./include -I/home/y/include
INCLUDE64 = -I/home/y/include64 $(INCLUDE)

LIBPATH64 = -L/home/y/lib64 -L./lib64
LIBPATH32 = -L/home/y/lib
LFLAGS64 = -Wl,-rpath,/home/y/lib64 -lm -lzookeeper_st
LFLAGS32 = -Wl,-rpath,/home/y/lib -lm -lzookeeper_st

TARGET_DIR64 = x86_64-linux-gcc

all : all64

prep :
	mkdir -p include
	cp ../../src/c/generated/*.h include/
	cp ../../src/c/include/*.h include/
	cp ../../src/c/src/hashtable/*.h include/

all64 : prep cli_mt.c cli_st.c
	mkdir -p $(TARGET_DIR64)
	cc $(CFLAGS) $(INCLUDE64) -c cli_mt.c -o cli_mt_64.o
	cc $(CFLAGS) $(INCLUDE64) $(LIBPATH64) $(LFLAGS64) cli_mt_64.o -o $(TARGET_DIR64)/cli_mt
	cc $(CFLAGS) $(INCLUDE64) -c cli_st.c -o cli_st_64.o
	cc $(CFLAGS) $(INCLUDE64) $(LIBPATH64) $(LFLAGS32) cli_st_64.o -o $(TARGET_DIR64)/cli_st


all32 : prep cli_mt.c cli_st.c
	mkdir -p bin32
	cc $(CFLAGS) $(INCLUDE) -m32 -c cli_mt.c -o cli_mt_32.o
	cc $(CFLAGS) $(INCLUDE) $(LIBPATH32) $(LFLAGS64) -m32 cli_mt_32.o -o bin32/cli_mt
	cc $(CFLAGS) $(INCLUDE) -m32 -c cli_st.c -o cli_st_32.o
	cc $(CFLAGS) $(INCLUDE) $(LIBPATH32) $(LFLAGS32) -m32 cli_st_32.o -o bin32/cli_st
