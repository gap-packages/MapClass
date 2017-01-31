# This module is part of a GAP package MAPCLASS.
# It contains a program extracting permutations
# corresponding to the mapping class group
# generators.
#
# (C) 2004 by K. Magaard, S. Shpectorov 


# Function recovering the action of the braid generators
# on the orbit

#
# ExtractPermutations
#
InstallGlobalFunction(ExtractPermutations,function(ActionOnOrbit)

 return (ActionOnOrbit,x->PermList(x));

end); 

# End
