# This module is part of a GAP package MAPCLASS.
# It contains the function constructing 
# the generators of the mapping class group.
#
# A. James, K. Magaard, S.Shpectorov 2011

#
# MappingClassGroupGenerators
# Function producing the generators of the mapping class group
#
InstallGlobalFunction(MappingClassGroupGenerators,function(OurG, OurR, AbsGens,
  OurAlpha, OurBeta, OurGamma, p)
 local i,j,y,s,z, OurAction;

 OurAction:=[];

 if OurR>1 then

# transforming the tuple partition...
  y:=[p[1]];
  for i in [2..Length(p)] do
   y[i]:=y[i-1]+p[i];
  od;

# getting the generators of the braid group 
  z:=BraidGroupGenerators(OurR,OurGamma);

# selecting the braid generators preserving the partition
  for i in [1..OurR-1] do
   for j in [i..OurR] do
    if (i=j and not (i in y)) or
       (i<j and (i in y) and (j-1 in y))
    then 
     Append(OurAction,[Concatenation(AbsGens{[1..2*OurG]},z[i][j])]);
    fi;
   od;
  od;

 fi;
#
# getting the Dehn twists

# a's
 z:=[];
 y:=[];
 if OurG>0 then
  z[1]:=OurAlpha[1]^-1*OurBeta[1]^-1*OurAlpha[1];
  y[1]:=z[1];
  for i in [OurR,OurR-1..1] do
   y[1]:=y[1]^(OurGamma[i]^-1);
  od;
  for i in [1..OurR] do
   y[i+1]:=y[i]*OurGamma[i];
   z[i+1]:=y[i+1];
   for j in [i+1..OurR] do
    z[i+1]:=z[i+1]^OurGamma[j];
   od;
  od;

  for i in [1..OurR+1] do
   s:=ShallowCopy(AbsGens);
   s[1]:=OurAlpha[1]*z[i];
   for j in [1..i-1] do
    s[2*OurG+j]:=OurGamma[j]^y[i];
   od;
   Append(OurAction,[s]);
  od;
 fi;

# b's
 if OurG>0 then
  for i in [1..OurG] do
   s:=ShallowCopy(AbsGens);
   s[OurG+i]:=OurAlpha[i]^-1*OurBeta[i];
   Append(OurAction,[s]);
  od;
 fi;

# c
 if OurG>1 then
  s:=ShallowCopy(AbsGens);
  s[2]:=OurBeta[2]^-1*OurAlpha[2];
  Append(OurAction,[s]);
 fi;

# d's
 if OurG>1 then
  for i in [1..OurG-1] do
   s:=ShallowCopy(AbsGens);
   s[i]:=OurBeta[i]*OurAlpha[i+1]^-1*OurBeta[i+1]^-1*
         OurAlpha[i+1]*OurAlpha[i];
   s[i+1]:=OurBeta[i+1]*OurAlpha[i+1]*OurBeta[i]^-1;
   s[OurG+i]:=OurBeta[i]^(OurAlpha[i+1]^-1*OurBeta[i+1]*
                          OurAlpha[i+1]*OurBeta[i]^-1);
   Append(OurAction,[s]);
  od;
 fi;
  return OurAction;

end);

InstallGlobalFunction(MappingClassGroupGeneratorsL,function(OurG, OurR, AbsGens,
  OurAlpha, OurBeta, OurGamma, p)
 local i,j,y,s,z, OurAction;

 OurAction:=[];

 if OurR>1 then

# transforming the tuple partition...
  y:=[p[1]];
  for i in [2..Length(p)] do
   y[i]:=y[i-1]+p[i];
  od;

# getting the generators of the braid group 
  z:=BraidGroupGenerators(OurR,OurGamma);

# selecting the braid generators preserving the partition
# KEY here is that i starts at 2 so the first element is not altered at all
  for i in [1..OurR-1] do
   for j in [i..OurR] do
    if (i=j and not (i in y)) or
       (i<j and (i in y) and (j-1 in y))
    then 
      if OurG = 0 then
        if z[i][j][1] = AbsGens[1] then
         Append(OurAction,[Concatenation(AbsGens{[1..2*OurG]},z[i][j])]);
       fi;
     fi;
    fi;
   od;
  od;

 fi;
#
# getting the Dehn twists

# a's
 z:=[];
 y:=[];
 if OurG>0 then
  z[1]:=OurAlpha[1]^-1*OurBeta[1]^-1*OurAlpha[1];
  y[1]:=z[1];
  for i in [OurR,OurR-1..1] do
   y[1]:=y[1]^(OurGamma[i]^-1);
  od;
  for i in [1..OurR] do
   y[i+1]:=y[i]*OurGamma[i];
   z[i+1]:=y[i+1];
   for j in [i+1..OurR] do
    z[i+1]:=z[i+1]^OurGamma[j];
   od;
  od;

  for i in [1..OurR+1] do
   s:=ShallowCopy(AbsGens);
   s[1]:=OurAlpha[1]*z[i];
   for j in [1..i-1] do
    s[2*OurG+j]:=OurGamma[j]^y[i];
   od;
   Append(OurAction,[s]);
  od;
 fi;

# b's
 if OurG>0 then
  for i in [1..OurG] do
   s:=ShallowCopy(AbsGens);
   s[OurG+i]:=OurAlpha[i]^-1*OurBeta[i];
   Append(OurAction,[s]);
  od;
 fi;

# c
 if OurG>1 then
  s:=ShallowCopy(AbsGens);
  s[2]:=OurBeta[2]^-1*OurAlpha[2];
  Append(OurAction,[s]);
 fi;

# d's
 if OurG>1 then
  for i in [1..OurG-1] do
   s:=ShallowCopy(AbsGens);
   s[i]:=OurBeta[i]*OurAlpha[i+1]^-1*OurBeta[i+1]^-1*
         OurAlpha[i+1]*OurAlpha[i];
   s[i+1]:=OurBeta[i+1]*OurAlpha[i+1]*OurBeta[i]^-1;
   s[OurG+i]:=OurBeta[i]^(OurAlpha[i+1]^-1*OurBeta[i+1]*
                          OurAlpha[i+1]*OurBeta[i]^-1);
   Append(OurAction,[s]);
  od;
 fi;
  return OurAction;

end);

# End
