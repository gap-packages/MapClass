# This module is part of a GAP package MAPCLASS.
# It contains the function constructing the generators 
# of the braid group and pure braid group.
#
# A. James,  K. Magaard, S. Shpectorov  2011


# Function producing the generators of the pure braid group

#
# BraidGroupGenerators
#
InstallGlobalFunction(BraidGroupGenerators,function(OurR, OurGamma)
 local i,j,k,s,Q,Qinv,PQ,PQcopy;

# getting the generators of the braid group 
 Q:=[];
 for i in [1..OurR-1] do
  Q[i]:=[];
  for j in [1..i-1] do
   Q[i][j]:=OurGamma[j];
  od;
  Q[i][i]:=OurGamma[i]*OurGamma[i+1]*OurGamma[i]^-1;
  Q[i][i+1]:=OurGamma[i];
  for j in [i+2..OurR] do
   Q[i][j]:=OurGamma[j];
  od;
 od;

# and their inverses
 Qinv:=[];
 for i in [1..OurR-1] do
  Qinv[i]:=[];
  for j in [1..i-1] do
   Qinv[i][j]:=OurGamma[j];
  od;
  Qinv[i][i]:=OurGamma[i+1];
  Qinv[i][i+1]:=OurGamma[i+1]^-1*OurGamma[i]*OurGamma[i+1];
  for j in [i+2..OurR] do
   Qinv[i][j]:=StructuralCopy(OurGamma[j]);
  od;
 od;

# finally, the pure braid group generators
 PQ:=[];
 for i in [1..OurR-1] do
  PQ[i]:=[];
  PQ[i][i]:=ShallowCopy(Q[i]);
  for j in [i+1..OurR] do
   PQ[i][j]:=List(OurGamma);
   for k in [i..j-2] do
    PQcopy:=ShallowCopy(PQ[i][j]);
    for s in [1..OurR] do
     PQ[i][j][s]:=MappedWord(Q[k][s],OurGamma,PQcopy);
    od;
   od;
   PQcopy:=ShallowCopy(PQ[i][j]);
   for s in [1..OurR] do
    PQ[i][j][s]:=MappedWord(Qinv[j-1][s],OurGamma,PQcopy);
   od;
   PQcopy:=ShallowCopy(PQ[i][j]);
   for s in [1..OurR] do
    PQ[i][j][s]:=MappedWord(Qinv[j-1][s],OurGamma,PQcopy);
   od;
   for k in [i..j-2] do
    PQcopy:=ShallowCopy(PQ[i][j]);
    for s in [1..OurR] do
     PQ[i][j][s]:=MappedWord(Qinv[j-2+i-k][s],OurGamma,PQcopy);
    od;
   od;
  od;
 od;

# we normalize the off-diagonal generators so that they don't change 
# the first entry
# for i in [2..OurR] do
#  for j in [1..OurR] do
#   PQ[1][i][j]:=OurGamma[i]*PQ[1][i][j]*OurGamma[i]^-1;
#  od;
# od;

 return PQ;

end);


# End
