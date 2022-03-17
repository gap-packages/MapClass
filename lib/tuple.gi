# This Module is part of the GAP package MAPCLAss
# It contains functions for suggesting, saving and manipulating the collection
# of random tuples in use.
#
# A. James, K. Magaard, S. Shpectorov 2011
#


#
# function inserting a human-suggested tuple
#
InstallGlobalFunction(SuggestTuple,function(tu, PrincipalFiniteGroup, PrincipalTuple, OurG, OurR)

  local i, NumberOfGenerators;
  NumberOfGenerators:= 2*OurG + OurR;

  for i in [1..OurR] do
    if not IsConjugate(PrincipalFiniteGroup,tu[2*OurG+i],
                     PrincipalTuple[i]) then
    Print("\n\nTuple cannot be accepted. Element ", i, " is not conjugate\n\n");
    return false;
  fi;
  od;
if Product([1..OurG],x->Comm(tu[2*x-1],tu[2*x]))*
    Product(tu{[2*OurG+1..NumberOfGenerators]})<>
    One(PrincipalFiniteGroup) then
    Print("\n\nTuple cannot be accepted!!\n\n");
    return false;
 fi;
 
 return rec(tuple:=ShallowCopy(tu),subgroupNumber:=1);
end);

#
# Select a random tuple in a random subgroup
#
InstallGlobalFunction(RandomSubgroupTuple,function(OurG,OurR,SubgroupRecord)
 local r,i,s,T,p,c,x, TotalWeight, SmallSubgroups;

 SmallSubgroups:=SubgroupRecord.SmallSubgroups;
 
 r:=RandomList([1..SubgroupRecord.TotalWeight]);
 for i in [1..Length(SmallSubgroups)] do
  s:=SmallSubgroups[i];
  if s.weight<r then
   r:=r-s.weight;
  else   
   while true do 
    T:=List([1..2*OurG],x->Random(s.subgroup));
    p:=Product([1..OurG],x->Comm(T[x],T[OurG+x]),One(s.subgroup));
    if OurR=0 then
     if p=One(s.subgroup) then
      return rec(tuple:=T,subgroupNumber:=i);
     fi;
    else
     if OurR>1 then
      for c in s.classes{[1..OurR-1]} do
       Append(T,[RandomList(c)^Random(s.subgroup)]);
      od;
      p:=p*Product(T{[2*OurG+1..Length(T)]});
     fi;
     p:=p^-1;
     c:=s.classes[OurR];
     for x in c do 
      if IsConjugate(s.subgroup,p,x) then
       Append(T,[p]);
       return rec(tuple:=T,subgroupNumber:=i);
      fi;
     od;
    fi;
   od;
  fi;
 od;
 
end);

#
# RandomGeneratingTuple
#
InstallGlobalFunction(RandomGeneratingTuple,function(group, tuple, OurG, OurR)
  local i, k, t, product, c;
  while true do
    t:=List([1..2*OurG], x-> Random(group));
    product:=Product([1..OurG], x->Comm(t[x], t[OurG+x]),One(group));
    if OurR=0 then
      if product=One(group) then
        return rec(tuple:=t, subgroupNumber:=1);
      fi;
    else
      if OurR>1 then
        for c in tuple{[1..OurR-1]} do
          Append(t, [c^Random(group)]);
        od;
        product:=product*Product(t{[2*OurG+1..Length(t)]});
      fi;
      if IsConjugate(group, product^-1, tuple[OurR]) then
        Append(t,[product^-1]);
        if Size(Subgroup(group,t))= Size(group) then
          return rec(tuple:=t, subgroupNumber:=1);
        fi;
      fi;
    fi;
  od;
end);

#
# Function collecting random tuples
#
InstallGlobalFunction(CollectRandomTuples,function( NumberOfRandomTuples, OurG,
  OurR, SubgroupRecord)
  local tuples, IsSilent;
  tuples:=[];
  MaybePrint( [],
    ["\c\r Collecting Random tuples\c\r"],
    ["\n\nCollecting ",NumberOfRandomTuples," random tuples...\c\r"]);

  while Length(tuples)<NumberOfRandomTuples do
    Append(tuples,[RandomSubgroupTuple(OurG, OurR,
    SubgroupRecord)]);
  od;

  MaybePrint([], [], " done\n");
  return tuples;
end);

#
# Function collecting only generating tuples
#
InstallGlobalFunction(CollectRandomGeneratingTuples,function(NumberOfRandomTuples,
  OurG, OurR, SubgroupRecord, group, tuple)
  local tuples, IsSilent;
  tuples:=[];

  MaybePrint([],[],
  ["\n\nCollecting ", NumberOfRandomTuples, " generating tuples ..\c"]);
  
  while Length(tuples)<NumberOfRandomTuples do
    Append(tuples,[RandomGeneratingTuple(group, tuple, OurG, OurR)]);
  od;
  
  MaybePrint([],[], [" done\n"]);
  return tuples;
end);


      
  
#
# Two routines cleaning the list of random tuples
#
InstallGlobalFunction(CleanCurrent,function(RandomTuples, Orb, SubgroupRecord)
  local i,l,s,k, IsSilent;

  MaybePrint([],
  ["\c\rCleaning a list of ", Length(RandomTuples), " tuples\c\r"],
  ["\rCleaning a list of ", Length(RandomTuples), " tuples\n"]);
  # Clear the line
  ClearLine();

  for i in [1..Length(RandomTuples)] do
    l:=Length(Orb.TupleTable);
    if IsAbelian(Orb.PrincipalFiniteGroup) then
      s:=RandomTuples[i].tuple;
    else

      # Dont't need to minimize if using Fingerprinting
      # TODO: If using quick minimization then do here.
      if Orb.FingerPrinting = true then
        s:=RandomTuples[i].tuple;
      else
        s:=MinimizeTuple(RandomTuples[i].tuple, Orb.MinimizationTree,
            Orb.MinimumSet, Orb.NumberOfGenerators);
      fi;
    fi;
    # Method selection 
    if Orb.FingerPrinting = true then
      k:=LookUpTupleFP(s,Orb.fprecord, Orb, Orb.TupleTable);
    else
      k:=LookUpTuple(s, Orb.PrimeCode, Orb.HashLength, Orb.TupleTable,
          Orb.Hash, Orb.OurN);
    fi;

    if not k =fail then
      s:=SubgroupRecord.SmallSubgroups[RandomTuples[i].subgroupNumber];
      SubgroupRecord.TotalWeight:=SubgroupRecord.TotalWeight-s.weight;
      s.weight:=MaximumList([SubgroupRecord.MinimumWeight,
          s.weight-SubgroupRecord.KnockDown]); 
      SubgroupRecord.TotalWeight:= SubgroupRecord.TotalWeight+s.weight;
      Unbind(RandomTuples[i]);
    fi;
  od;
  RandomTuples:=Filtered(RandomTuples,x->IsBound(x));

  MaybePrint([], [], ["Random Tuples Remaining: ", Length(RandomTuples), "\n"]);
  return RandomTuples;
end);

# Call with FingerPrinting and fprecord = false if don't wish to use
# fingerprinting
InstallGlobalFunction(CleanAll,function(RandomTuples, orbits, SubgroupRecord) 
  local i,Orb, IsSilent;

  for i in [1..Length(orbits)] do
    MaybePrint([],
      [] ,
      ["\rCleaning orbit ",i,"\c\r"]);
    Orb:=orbits[i];
    RandomTuples:=CleanCurrent(RandomTuples, Orb, SubgroupRecord);
  od;
  MaybePrint([],
    [],
    ["\rCleaning done; ",Length(RandomTuples)," random tuples remaining\n"]);
  return RandomTuples;
end);
