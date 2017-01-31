#
# Files based on the Example package init.g file by Werner and Gamble.
#
#

#
#  Starting from GAP 4.4 and having  a  PackageInfo.g  file  available,  the
#  commands  `DeclarePackage'  and   `DeclarePackageAutoDocumentation'   are
#  ignored. They are substituted by the entries:
#   .PackageName, .Version, .PackageDoc, .Dependencies and .AvailabilityTest
#  specified in the PackageInfo.g file.
#
#  Since GAP 4.4, commands with `Pkg' in their name have `Package'  instead,
#  e.g. `ReadPkg' became `ReadPackage'.
#


#
#  Read the declaration files.
#
ReadPackage( "MapClass", "lib/declarations.gd" );

#  init.g . . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here

