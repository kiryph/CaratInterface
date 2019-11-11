###########################################################################
#
#  This is a wrapper makefile to build and set up CARAT for use with GAP.
#  It depends on certain variables defined in the file config.carat, which
#  in turn is produced by the companion configure script.
#
#  Usage:  ./configure <path to GAP root>
#          make
#
#  This tries to build CARAT with the same GMP library as GAP.
#
#  By default, the QCatalog of CARAT is unpacked only up to dimension 5.
#  If you need also dimension 6 (another 180 Mb), unpack also the rest with
#
#          make qcat6
#
#  The compiled binaries and libraries can be removed with 
#
#          make clean
#
#  This requires the config.carat file that has been used to build CARAT.
#
###########################################################################


# include the variables determined by the configure script
include config.carat

# build everything
ALL: carat qcatalog programs arch

# fetch CARAT if necessary, or unpack it
carat/configure:
	if [ ! -d carat ]; then \
	  if [ -f carat.tgz ]; then tar pzxf carat.tgz; \
	  else git clone https://github.com/lbfm-rwth/carat.git; fi; \
	fi
	if [ ! -f carat/configure ]; then (cd carat && ./autogen.sh); fi
	touch $@
carat: carat/configure

# unpack the qcatalog, by default without dimension 6
carat/tables/qcatalog/TGROUPS.GAP: carat/configure
	cd carat/tables; tar pzxf qcatalog.tar.gz --exclude=qcatalog/dim6
	touch $@
qcatalog: carat/tables/qcatalog/TGROUPS.GAP

# unpack also qcatalog for dimension 6
carat/tables/qcatalog/dim6/BASIS: carat/tables/qcatalog/TGROUPS.GAP
	cd carat/tables; tar pzxf qcatalog.tar.gz qcatalog/dim6
	touch $@
qcat6: carat/tables/qcatalog/dim6/BASIS

# compile and link the CARAT binaries
programs: config.carat carat/configure
	(cd carat && ./configure "$(WITHGMP)" CC="$(CC)" CFLAGS="$(FLAGS)" && make)
	chmod -R a+rX .

# make suitable links, so that GAP can find the CARAT binaries
arch: config.carat carat/configure
	mkdir -p "bin/$(ARCHDIR)"; chmod -R a+rx bin
	cd "bin/$(ARCHDIR)/"; ln -s ../../carat/bin/* . 

# dynamic module for setting CARAT_DIR environment variable
dynmod: src/setcaratdir.c
	$(GAPROOT)/gac -d -o bin/$(ARCHDIR)/setcaratdir.so $<

# clean up everything
clean: config.carat
	if [ -d "carat/" ]; then cd carat; make clean; fi
	if [ -d "bin/$(ARCHDIR)/" ]; then rm -rf "bin/$(ARCHDIR)"/*; fi
	if [ -h "bin/$(ARCHDIR)"  ]; then rm "bin/$(ARCHDIR)"; fi

.PHONY: all clean arch carat qcatalog qcat6
