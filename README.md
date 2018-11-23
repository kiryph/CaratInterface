[![Build Status](https://travis-ci.org/gap-packages/carat.svg?branch=master)](https://travis-ci.org/gap-packages/carat)
[![Code Coverage](https://codecov.io/github/gap-packages/carat/coverage.svg?branch=master&token=)](https://codecov.io/gh/gap-packages/carat)

The GAP 4 package "Interface to CARAT", briefly called just Carat, 
provides GAP interface routines to some of the stand-alone programs 
in the package CARAT, developed by J. Opgenorth, W. Plesken, and 
T. Schulz at Lehrstuhl B für Mathematik, RWTH Aachen. CARAT is a 
package for the computation with crystallographic groups. It is 
implemented in C, and thus needs to be compiled. It runs on Unix 
systems only.

CARAT is to a large extent complementary to the GAP 4 package
Cryst. In particular, it provides routines for the computation 
of normalizers and conjugators of finite unimodular groups in GL(n,Z),
and routines for the computation of Bravais groups, which are all 
missing in Cryst.  Furthermore, it provides also a catalogue of 
Bravais groups up to dimension 6. Cryst automatically loads Carat
when it is available, and makes use of its functions where necessary. 
The Carat package thereby extends the functionality of the package 
Cryst considerably.

Please note that the Carat package consists of the GAP interface
routines to CARAT, even though a copy of CARAT itself is included in
the distribution. All rights and responsibilities regarding CARAT
remain with its authors. The most recent version of CARAT can be
obtained at the CARAT Home Page

http://134.130.169.213/carat/index.html

Questions and bug reports regarding CARAT itself should be addressed 
to the CARAT authors at

    carat@momo.math.rwth-aachen.de.

The GAP interface routines to CARAT have been written by

    Franz Gähler
    Fakultät für Mathematik 
    Universität Bielefeld 
    Postfach 10 01 31 
    D-33501 Bielefeld

    gaehler@math.uni-bielefeld.de

For bug reports, suggestions and other comments please use the issue
tracker on the GitHub page of the package:

https://github.com/gap-packages/carat/issues
