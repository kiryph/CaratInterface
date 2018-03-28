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
ALL: carat carat/tables/qcatalog programs arch

# fetch carat.tgz if necessary, and unpack it
carat: 
	if [ ! -f carat.tgz ]; then "$(GET)" "https://wwwb.math.rwth-aachen.de/carat/carat.tgz"; fi
	tar pzxf carat.tgz

# unpack the qcatalog, by default without dimension 6
carat/tables/qcatalog: carat
	cd carat/tables; tar pzxf qcatalog.tar.gz --exclude=qcatalog/dim6

# unpack also qcatalog for dimension 6
carat/tables/qcatalog/dim6: carat/tables/qcatalog
	cd carat/tables; tar pzxf qcatalog.tar.gz qcatalog/dim6

qcat6: carat/tables/qcatalog/dim6

# compile and link the CARAT binaries
programs: Makefile_CARAT config.carat
	sed -i 's/#include <malloc.h>/\/* inclusion of malloc.h removed *\//g' carat/include/typedef.h
	cd carat; make -f ../Makefile_CARAT TOPDIR="$(TOPDIR)" CC="$(CC)" CFLAGS="$(FLAGS) $(CFLAGS)"
	chmod -R a+rX .

# make a suitable link, so that GAP can find the CARAT binaries
arch: carat config.carat
	mkdir -p bin; chmod a+rx bin
	rm -f "bin/$(ARCHDIR)"
	ln -s "../carat/bin/`carat/bin/config.guess`-`basename $(CC)`" "bin/$(ARCHDIR)"

# clean up everything
clean: config.carat
	if [ -d "bin/$(ARCHDIR)/" ]; then rm -f "bin/$(ARCHDIR)"/*; fi
	if [ -h "bin/$(ARCHDIR)"  ]; then rm "bin/$(ARCHDIR)"; fi
