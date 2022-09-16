#############################################################################
##  
##  PackageInfo.g for the package `MapClass'                     
##  2011 - A. James S.Shpectorov K.Magaard
##                                                              
##  This file contains meta-information on the package. It is used by
##  the package loading mechanism and the upgrade mechanism for the
##  redistribution of the package via the GAP website.

SetPackageInfo( rec(

##  This is case sensitive, use your preferred spelling.
##
PackageName := "MapClass",

##  This may be used by a default banner or on a Web page, should fit on
##  one line.
Subtitle := "A Package For Mapping Class Orbit Computation",

##  See '?Extending: Version Numbers' in GAP help for an explanation
##  of valid version numbers. For an automatic package distribution update
##  you must provide a new version number even after small changes.
Version := "1.4.6",

##  Release date of the current version in dd/mm/yyyy format.
##
Date := "17/09/2022", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

SourceRepository := rec(
    Type := "git",
    URL := Concatenation( "https://github.com/gap-packages/", ~.PackageName ),
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
PackageWWWHome  := Concatenation( "https://gap-packages.github.io/", ~.PackageName ),
README_URL      := Concatenation( ~.PackageWWWHome, "/README.md" ),
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "/PackageInfo.g" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/", ~.PackageName, "-", ~.Version ),
                                 
ArchiveFormats := ".tar.gz",

Persons := [
  rec( 
    LastName      := "James",
    FirstNames    := "Adam",
    IsAuthor      := true,
    IsMaintainer  := false,
  ),
  rec( 
    LastName      := "Magaard",
    FirstNames    := "Kay",
    IsAuthor      := true,
    IsMaintainer  := false
  ),
  rec( 
    LastName      := "Shpectorov",
    FirstNames    := "Sergey",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "S.Shpectorov@bham.ac.uk",
    WWWHome       := "https://web.mat.bham.ac.uk/S.Shpectorov/index.html",
    PostalAddress := Concatenation( [
                       "School of Mathematics\n",
                       "University of Birmingham\n",
                       "Edgbaston\n",
                       "Birmingham, B15 2TT\n",
                       "United Kingdom"] ),
    Place         := "Birmingham",
    Institution   := "University of Birmingham"
  ),
  rec( 
    LastName      := "Volklein",
    FirstNames    := "Helmut",
    IsAuthor      := true,
    IsMaintainer  := false,
  )
],

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "deposited"     for packages for which the GAP developers agreed 
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages 
##    "other"         for all other packages
##
# Status := "accepted",
Status := "accepted",

##  You must provide the next two entries if and only if the status is 
##  "accepted" because is was successfully refereed:
# format: 'name (place)'
# CommunicatedBy := "Mike Atkinson (St. Andrews)",
CommunicatedBy := "Leonard Soicher (QMUL)",
# format: mm/yyyy
# AcceptDate := "08/1999",
AcceptDate := "11/2011",

##  Here you  must provide a short abstract explaining the package content 
##  in HTML format (used on the package overview Web page) and an URL 
##  for a Webpage with more detailed information about the package
##  (not more than a few lines, less is ok):
##  Please, use '<span class="pkgname">GAP</span>' and
##  '<span class="pkgname">MyPKG</span>' for specifing package names.
##  
# AbstractHTML := "This package provides  a collection of functions for \
# computing the Smith normal form of integer matrices and some related \
# utilities.",
AbstractHTML := 
  "The <span class=\"pkgname\">MapClass</span> package calculates the \
   mapping class group orbits for a given finite group.",
              
##  Here is the information on the help books of the package, used for
##  loading into GAP's online help and maybe for an online copy of the 
##  documentation on the GAP website.
##  
##  For the online help the following is needed:
##       - the name of the book (.BookName)
##       - a long title, shown by ?books (.LongTitle, optional)
##       - the path to the manual.six file for this book (.SixFile)
##  
##  For an online version on a Web page further entries are needed, 
##  if possible, provide an HTML- and a PDF-version:
##      - if there is an HTML-version the path to the start file,
##        relative to the package home directory (.HTMLStart)
##      - if there is a PDF-version the path to the .pdf-file,
##        relative to the package home directory (.PDFFile)
##      - give the paths to the files inside your package directory
##        which are needed for the online manual (either as URL .Archive
##        if you pack them into a separate archive, or as list 
##        .ArchiveURLSubset of directory and file names which should be 
##        copied from your package archive, given in .ArchiveURL above
##  
##  For links to other GAP or package manuals you can assume a relative 
##  position of the files as in a standard GAP installation.
##  
# in case of several help books give a list of such records here:
PackageDoc := rec(
  # use same as in GAP            
  BookName  := "MapClass",
  LongTitle := "A Package For Mapping Class Orbit Computation",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0_mj.html",
  PDFFile   := "doc/manual.pdf",
  # the path to the .six file used by GAP's help system
  SixFile   := "doc/manual.six",
  # a longer title of the book, this together with the book name should
  # fit on a single text line (appears with the '?books' command in GAP)
),


##  Are there restrictions on the operating system for this package? Or does
##  the package need other packages to be available?
Dependencies := rec(
  # GAP version, use version strings for specifying exact versions,
  # prepend a '>=' for specifying a least version.
  GAP := ">=4.9",
  # list of pairs [package name, (least) version],  package name is case
  # insensitive, least version denoted with '>=' prepended to version string.
  # without these, the package will not load
  # NeededOtherPackages := [["GAPDoc", ">= 0.99"]],
  NeededOtherPackages := [],
  # without these the package will issue a warning while loading
  # SuggestedOtherPackages := [],
  SuggestedOtherPackages := [],
  # needed external conditions (programs, operating system, ...)  provide 
  # just strings as text or
  # pairs [text, URL] where URL  provides further information
  # about that point.
  # (no automatic test will be done for this, do this in your 
  # 'AvailabilityTest' function below)
  # ExternalConditions := []
  ExternalConditions := []
                      
),

##  Provide a test function for the availability of this package.
##  For packages which will not fully work, use 'Info(InfoWarning, 1,
##  ".....")' statements. For packages containing nothing but GAP code,
##  just say 'ReturnTrue' here.
##  With the new package loading mechanism (GAP >=4.4)  the availability
##  tests of other packages, as given under .Dependencies above, will be 
##  done automatically and need not be included in this function.
AvailabilityTest := ReturnTrue,
##  AvailabilityTest := function()
##    local path, file;
##      # test for existence of the compiled binary
##      path := DirectoriesPackagePrograms("example");
##      file := Filename(path,"hello");
##      if file=fail then
##        Info(InfoWarning,1,
##          "Package ``Example'': The program `hello' is not compiled");
##        Info(InfoWarning,1,
##          "`HelloWorld()' is thus unavailable");
##        Info(InfoWarning,1,
##          "See the installation instructions; ",
##          "type: ?Installing the Example package");
##      fi;
##      # if the hello binary was vital to the package we would return
##      # the following ...
##      #return file<>fail;
##      # since the hello binary is not vital we return ...
##      return true;
##    end,

##  *Optional*, but recommended: path relative to package root to a file which 
##  contains as many tests of the package functionality as sensible.
##  The file can either consist of 'ReadTest' calls or it is itself read via
##  'ReadTest'; it is assumed that the latter case occurs if and only if
##  the file contains the string 'gap> START_TEST('.
##  For submitted packages, these tests are run regularly, as a part of the
##  standard GAP test suite.
TestFile := "tst/testall.g",

##  *Optional*: Here you can list some keyword related to the topic 
##  of the package.
# Keywords := ["Smith normal form", "p-adic", "rational matrix inversion"]
Keywords := ["braid orbit", "mapping class orbit", "Hurwitz loci"]

));


