# This module is part of a GAP package MAPCLASS. 
# It contains functions maintaining a hash table 
# containing a braid orbit.
#
# A. James,  K. Magaard, S. Shpectorov 2011


# Function initializing tables 

#
# InitializeTable
# Takes hashlength, numberofgenerators and number of points acted on
# Returns a record with three places, (table, hash, primecode)
#
InstallGlobalFunction(InitializeTable,function(HashLength,NumberOfGenerators,OurN)
  local table,hash,primecode;

  table:=[];
  hash:=List([1..HashLength],x->0);
  primecode:=List([1..NumberOfGenerators*OurN],x->RandomList(Primes));

  return rec(table:=table, hash:=hash, primecode:= primecode);
end);

#
# HashKey
# Function computing the hash key of a tuple
#
InstallGlobalFunction(HashKey,function(T,PrimeCode,HashLength,OurN)
  local t;
  t:=Concatenation(List(T,x->OnTuples([1..OurN],x)));
  return 1+(Sum(List([1..Length(t)],x->t[x]*PrimeCode[x])) mod HashLength);
end);

#
# LookUpTuple
# Function looking up a tuple returns index if found else returns fail
#
InstallGlobalFunction(LookUpTuple,function(T, PrimeCode, HashLength, TupleTable,
  Hash, OurN)
  local h,a;
  h:=HashKey(T,PrimeCode,HashLength, OurN);
  a:=Hash[h];
  while a<>0 do
    if TupleTable[a].tuple=T then
      return a;
    else
      a:=TupleTable[a].next;
    fi;
  od;
  return fail;
end);

#
# AddTuple
# Adds a tuple to the end of a tuple table adjusts the HashKey and returns a
# the length of the last element of the tuple and the adjusted Hashkey
#
InstallGlobalFunction(AddTuple,function(T,PrimeCode, HashLength, TupleTable, Hash, OurN)
  local i,j,k,h;
  h:=HashKey(T,PrimeCode,HashLength,OurN);
  Append(TupleTable,[rec(tuple:=T,next:=Hash[h])]);
  Hash[h]:=Length(TupleTable);
  return(Length(TupleTable));
 end);

## FingerPrinting
# Fingerprinting means the addition of a new FingerPrinting Table
# The fingerprinting process is as follows:
# take a random selection of words from our free group
# compute the order of this words using mappedword
# return a key which we use to generate the hashkey from

## Returns a random free word of length
# InstallGlobalFunction(RanFreeWord, function(fgp, absgens, length)
#   local i,p,w;
#   w:=Identity(fgp);
#   p:=RandomList([0,1]);
#   w:=Product(List([1..length], x ->RandomList(absgens)^RandomList([-1,1])));
#   if w <> One(fgp) then 
#     return w;
#   else
#     return RanFreeWord(fgp, absgens, length);
#   fi;
# end);

# InstallGlobalFunction(PrepareFingerPrinting,
#     function(numtestwords,primecode,ourR, absgens, fgp)
#   local testword, fingerfun;
#   testword:= List([1..numtestwords], i -> RanFreeWord(fgp, absgens, ourR));
#   fingerfun:=function(tuple)
#     return List(testword, x -> Order(MappedWord(x, absgens, tuple)));
#   end;
#   return fingerfun;
# end);

# # HashFinger
# # Computes the hash key based of a fingerprint
# InstallGlobalFunction(HashFinger, function(fprint, numwords, primecode, hashlength)
#   local hash, ptr;
#   return 1 + Sum(List([1..numwords], x-> fprint[x]*primecode[x])) mod hashlength;
# end);

# # Creates a closure around numwords and primecode
# # returns a function f which takes a finger pring and returns a hashkey
# InstallGlobalFunction(GenFHashFunction, function(numwords, primecode, hashlength)
#   local fun, fprint;
#   fun:=function(fprint)
#     return HashFinger(fprint, numwords, primecode, hashlength);
#   end;
# end);

# ## Given a tuple and testword return a fingerprint
# InstallGlobalFunction(Getfprint, function(tuple, testword, absgens)
#   return List(testword, x -> Order(MappedWord(x, absgens, tuple)));
# end);

# ## Given a fprint returns a ptr such that ftable[ptr].fprint = fprint
# ## and ftable.
# ## hashfn is a function which given a fingerprint returns a ptr to htable such
# ## that ftable[ptr].fprint = fprint
# InstallGlobalFunction(LookUpHashFrmPrint, function(fprint, hashfn, ftable, htable)
#   local hash, ptr, a;
#   a:=hashfn(fprint);
#   ptr:=ftable[a];
#   while ptr <> 0 do 
#     if ftable[ptr].fprint = fprint then
#       return ptr;
#     else
#       ptr:= ftable[ptr].next;
#     fi;
#   od;
#   Append(ftable,[rec(fprint:=fprint, next:=htable[ptr])]);
#   htable[ptr]:=Length(ftable);
#   return htable[ptr];
# end);

# ## given a tuple returns fail or the index of the tuple
# ## uses fingerprinting
# InstallGlobalFunction(LookUpTupleF, function(tuple, testword, absgens,
#     hashlength, htable, ftable, tupletable, hashfn)
#   local hash, fprint, ptr;
#   fprint:=Getfprint(tuple, testword, absgens, hashlength);
#   hash:=LookUpHashFrmPrint(fprint, hashfn, ftable, htable);
#   ptr:=htable[hash];
#   while ptr<>0 do
#     if RepresentativeAction(tupletable[ptr].tuple,tuple) <> fail then
#       return ptr;
#     else
#       ptr:=tupletable[ptr].next;
#     fi;
#   od;
#   return fail;
# end);

# ## add tuple to tupletable with given hash
# InstallGlobalFunction(AddTupleF, function(tuple, hash, tupletable, htable)
#   local i;
#   Append(tupletable, [rec(tuple:=tuple, next:=hash)]);
#   htable[hash]:=Length(tupletable);
#   return Length(tupletable);
# end);
# Ende
