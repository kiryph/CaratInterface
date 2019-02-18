#############################################################################
##
##  PackageInfo.g for Carat
##

SetPackageInfo( rec(

PackageName := "Carat",

Subtitle := "Interface to CARAT, a crystallographic groups package",

Version := "2.2.3",

Date := "04/11/2018", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

ArchiveURL := Concatenation( 
  "https://www.math.uni-bielefeld.de/~gaehler/gap/Carat/carat-", ~.Version ),

ArchiveFormats := ".tar.gz",

BinaryFiles := [ "doc/manual.pdf", "doc/manual.dvi", "carat.tgz" ],

Persons := [
  rec(
    LastName := "Gähler",
    FirstNames := "Franz",
    IsAuthor := true,
    IsMaintainer := true,
    Email := "gaehler@math.uni-bielefeld.de",
    WWWHome := "https://www.math.uni-bielefeld.de/~gaehler/",
    #PostalAddress := "",           
    Place := "Bielefeld",
    Institution := "Mathematik, Universität Bielefeld"
  )
],

Status := "accepted",

CommunicatedBy := "Herbert Pahlings (Aachen)",

AcceptDate := "02/2000",

README_URL := 
  "https://www.math.uni-bielefeld.de/~gaehler/gap/Carat/README.carat",
PackageInfoURL := 
  "https://www.math.uni-bielefeld.de/~gaehler/gap/Carat/PackageInfo.g",

AbstractHTML := 
"This package provides <span class=\"pkgname\">GAP</span> interface \
routines to some of the stand-alone programs of <a \
href=\"https://wwwb.math.rwth-aachen.de/carat\">CARAT</a>, a package \
for the computation with crystallographic groups. CARAT is to a large \
extent complementary to the <span class=\"pkgname\">GAP</span> package \
<span class=\"pkgname\">Cryst</span>. In particular, it provides \
routines for the computation of normalizers and conjugators of \
finite unimodular groups in GL(n,Z), and routines for the computation \
of Bravais groups, which are all missing in <span class=\"pkgname\">Cryst\
</span>. A catalog of Bravais groups up to dimension 6 is also provided.",

PackageWWWHome := 
  "https://www.math.uni-bielefeld.de/~gaehler/gap/packages.php",

SourceRepository := rec(
  Type := "git",
  URL := Concatenation( "https://github.com/gap-packages/",
                        LowercaseString( ~.PackageName ) ) ),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
SupportEmail := "gaehler@math.uni-bielefeld.de",

PackageDoc  := rec(
  BookName  := "Carat",
  ArchiveURLSubset := ["doc", "htm"],
  HTMLStart := "htm/chapters.htm",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Interface to CARAT, a crystallographic groups package"
),

Dependencies := rec(
  GAP := ">=4.9",
  NeededOtherPackages := [],
  SuggestedOtherPackages := [ [ "Cryst", ">=4.1.17" ] ],
  ExternalConditions := []
),

AvailabilityTest := function()
  local path;
  # Carat is available only on UNIX (maybe no longer true)
  #if not ARCH_IS_UNIX() then
  #   LogPackageLoadingMessage(PACKAGE_INFO, "Carat is restricted to UNIX" );
  #   return false;
  #fi;  
  # test the existence of a compiled binary; since there are
  # so many, we do not test for all of them, hoping for the best
  path := DirectoriesPackagePrograms( "carat" );
  if Filename( path, "Z_equiv" ) = fail then
     LogPackageLoadingMessage(PACKAGE_WARNING, "Carat binaries must be compiled" );
     return false;
  fi;
  return true;
end,

TestFile := "tst/testall.g",

Keywords := [ "crystallographic groups", "finite unimodular groups", "GLnZ" ]

));

