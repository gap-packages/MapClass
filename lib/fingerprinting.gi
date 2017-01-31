
# This module is part of a GAP package BRAID. 
# It contains functions maintaining a hash table 
# containing a braid orbit.
#
# (C) K. Magaard, S. Shpectorov, 2001

# LookUpTuple1 modified by Gehao Wang 2011
# Rewritten by Adam James 2012

# Function initializing tables 

InstallGlobalFunction(InitializeFingerprintTable, function(oo)
  local fp;
  fp:=rec();
  fp.FingerprintTable:=[];
  fp.NumberOfTestWords:=20;
  fp.len:=7;
  fp.TestWord:=List([1..fp.NumberOfTestWords],x->FPRandomWord(oo, fp.len));
  return fp;
end);

InstallGlobalFunction(FPRandomWord, function(oo, len)
  local i,p,w;
  w:=Identity(oo.OurFreeGroup);
  p:=RandomList([0,1]);
  for i in [1..len+p] do
    w:=w*RandomList(oo.AbsGens)^RandomList([-1,1]);
  od;
  if w<>One(oo.OurFreeGroup) then
    return w;
  else
    return FPRandomWord(oo, len);
  fi;
end);

# Function finding the fingerprint of a tuple
InstallGlobalFunction(FingerprintTuple, function(tuple, fprecord, oo)
 return List(fprecord.TestWord,x->Order(MappedWord(x,oo.AbsGens,tuple)));
end);


# Function computing the hash key of a fingerprint
InstallGlobalFunction(HashKeyOfPrint, function(fprint, fprecord, oo)
 return 
  1+(Sum(List([1..fprecord.NumberOfTestWords],x->fprint[x]*oo.PrimeCode[x])) mod oo.HashLength);
end);


# Function looking up a fingerprint in the table (and adding it if not found)
InstallGlobalFunction(LookUpFingerprint, function(fprint, fprecord, oo)
 local h,a;
 h:=HashKeyOfPrint(fprint,fprecord, oo);
 a:=oo.Hash[h];
 while a<>0 do
  if fprecord.FingerprintTable[a].fingerprint = fprint then
   return a;
  else
   a:=fprecord.FingerprintTable[a].next;
  fi;
 od;
 Append(fprecord.FingerprintTable,
   [rec(fingerprint:=fprint,next:=oo.Hash[h],firstTuple:=0)]);
 oo.Hash[h]:=Length(fprecord.FingerprintTable);
 return oo.Hash[h];
end);


# Function looking up a tuple (and adding it to the table if not found)
InstallGlobalFunction(LookUpTupleFP, function(tuple, fprecord, oo, TupleTable)
 local f,a;
 f:=LookUpFingerprint(FingerprintTuple(tuple, fprecord, oo), fprecord, oo);
 a:=fprecord.FingerprintTable[f].firstTuple;
 while a<>0 do
  if RepresentativeAction(oo.PrincipalFiniteGroup,
                          TupleTable[a].tuple,tuple,OnTuples)<>fail then
   return a;
  else 
   a:=TupleTable[a].next;
  fi;
 od;
 return fail;
end);

InstallGlobalFunction(NonConjLookUpTupleFP, function(tuple, fprecord, oo, TupleTable)
 local f,a;
 f:=LookUpFingerprint(FingerprintTuple(tuple, fprecord, oo), fprecord, oo);
 a:=fprecord.FingerprintTable[f].firstTuple;
 while a<>0 do
  if TupleTable[a].tuple = tuple  then
   return a;
  else 
   a:=TupleTable[a].next;
  fi;
 od;
 return fail;
end);

InstallGlobalFunction(AddTupleFP, function(tuple, fprecord, oo, TupleTable)
  local a, fp;
  fp:=LookUpFingerprint(FingerprintTuple(tuple, fprecord, oo), fprecord, oo);
  Append(TupleTable,[rec(tuple:=tuple,
    next:=fprecord.FingerprintTable[fp].firstTuple)]);
  a:=Length(TupleTable);
  fprecord.FingerprintTable[fp].firstTuple:=a;
  return a;
end);
