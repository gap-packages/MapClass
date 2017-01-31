# This module is part of a GAP package MAPCLASS. 
# It contains a function computing the mapping
# class orbit of a tuple and the action of 
# the mapping class group on the orbit
#
# ASSUMPTIONS: (1) The principal relation on this tuple must be 1.
#              (2) The length of the tuple is >1.
#
# A.James,  K. Magaard, S. Shpectorov 2011

## These routine do not do any conjugating!! This is there important
##  property

#
# MappingClassOrbitCore
# Main routine computing the orbit. Is wrapped by all other functions
#cv
InstallGlobalFunction(MappingClassOrbitCoreNoConj, function(tuple,
  PrincipalFiniteGroup, OurG, PrincipalTuple, AbsGens,  OurN, OurFreeGroup,
  OurAction, OurAlpha, OurBeta, OurGamma,HashLength, MinimizationTree,
  MinimumSet)

  local k, i, T, Orb, r, ActionOnOrbit, a, h, TupleTable, IsSilent, ExTotal, CTotal, NOrbits, precentage, percentage, n;
  if not ValueOption("CurrentTotal") = fail then
    CTotal:= ValueOption("CurrentTotal");
  else
    CTotal:= 0;
  fi;
  if not ValueOption("ExTotal") = fail then
    ExTotal:= ValueOption("ExTotal");
  else
    ExTotal:= 0;
  fi;
  if not ValueOption("NOrbits") = fail then
    NOrbits:= ValueOption("NOrbits");
  else
    NOrbits:= 0;
  fi;


  # Initialize orbit record
  Orb:=rec();
  Orb.AbsGens:=AbsGens;
  Orb.OurFreeGroup:=OurFreeGroup;
  Orb.HashLength:=HashLength;
  Orb.MinimizationTree:=MinimizationTree;
  Orb.MinimumSet:=MinimumSet;
  Orb.OurR:=Length(PrincipalTuple);
  Orb.OurG:=OurG;
  Orb.NumberOfGenerators:=2*OurG + Orb.OurR;
  Orb.OurAction:=OurAction;
  Orb.OurAction:=OurAction;
  Orb.OurAlpha:=OurAlpha;
  Orb.OurBeta:=OurBeta;
  Orb.OurN:=OurN;
  Orb.PrincipalFiniteGroup:=PrincipalFiniteGroup;

  # tables...
  r:=InitializeTable(Orb.HashLength,2*Orb.OurG+Orb.OurR,Orb.OurN);
  Orb.Hash:=r.hash;
  Orb.PrimeCode:=r.primecode;
  TupleTable:=r.table;

  # first tuple...
  # we want to split this so that we can use a choice of techniques.
    T:=ShallowCopy(tuple);

    a:=LookUpTuple(T, Orb.PrimeCode, Orb.HashLength, TupleTable, Orb.Hash,
        Orb.OurN);
    if a=fail then
      a:=AddTuple(T,Orb.PrimeCode,Orb.HashLength,TupleTable, Orb.Hash,
          Orb.OurN);
    fi;


# action on the orbit...
  ActionOnOrbit:=List(Orb.OurAction,x->[]);
  
  # 
  # Generating the orbit
  #
  
  k:=0;
  n:= Size(PrincipalFiniteGroup) / Size(Center(PrincipalFiniteGroup));
  while k<Length(TupleTable) do
    k:=k+1;
    for i in [1..Length(Orb.OurAction)] do
      T:=List(Orb.OurAction[i],x->MappedWord(x,Orb.AbsGens,TupleTable[k].tuple));
     
#     Check whether the tuple is in the table or not and if not then add it
#     Also have option to not use a generating lookup table
#
      ActionOnOrbit[i][k]:=LookUpTuple(T,Orb.PrimeCode, Orb.HashLength,
        TupleTable, Orb.Hash, Orb.OurN);

      if (ActionOnOrbit[i][k]= fail) then
        ActionOnOrbit[i][k]:=AddTuple(T,Orb.PrimeCode, Orb.HashLength,
          TupleTable, Orb.Hash, Orb.OurN);
      fi;
    od;
    percentage:= Int(100*((CTotal + n*Length(TupleTable))/Maximum(ExTotal,1)));
  MaybePrint([],
    ["\rOrbit ", NOrbits, "; Total % of tuples found: ", percentage, "%\c\r" ],
    ["\r",k," points checked, ",Length(TupleTable),
    " points total (difference ",Length(TupleTable)-k,")\c"]);
  od;
  MaybePrint([],
    [],
    ["\r",List([1..70],x->' '),"\c\r"]);
  Orb.TupleTable:=TupleTable;
  Orb.ActionOnOrbit:=ActionOnOrbit;
  return Orb;
end);

#
# MappingClassOrbit
# Given the usual parameters + an addition tuple number computes the tule table
# for said tuple. A wrapper for MappingClassOrbit
#
InstallGlobalFunction(MappingClassOrbitNoConj,function(group, genus, principaltuple, partition, tuple)

  local k, i, T, orb, r, ActionOnOrbit, a, h, TupleTable, OurN, OurR, AbsGens,
   OurFreeGroup, MinimumSet, MinimizationTree, record, OurAlpha,
  OurBeta, OurGamma, OurAction, NumberOfGenerators, Orb, IsSilent; 
  # Get OptionStack values
  if not ValueOption("Silent") = fail then 
    IsSilent:=ValueOption("Silent"); 
  else
    IsSilent:=false;
  fi;
  if not IsBool(IsSilent) then
    IsSilent:=false;
  fi;

  Orb:=rec();
  OurN:=NrMovedPoints(group);
  OurR:=Length(principaltuple);
  if Length(principaltuple)<>Length(tuple) then
    Print("Tuple Lengths do not match\n");
    return fail;
  fi;
  
  # construct abstract generators
  NumberOfGenerators:=2*genus + OurR;
  OurFreeGroup:=FreeGroup(NumberOfGenerators);
  AbsGens:=GeneratorsOfGroup(OurFreeGroup);
  OurAlpha:=AbsGens{[1..genus]};
  OurBeta:=AbsGens{[genus+1..2*genus]};
  OurGamma:=AbsGens{[2*genus+1..2*genus+OurR]};


# Mapping Class Action
  OurAction:= MappingClassGroupGenerators(genus, OurR, AbsGens, OurAlpha,
              OurBeta, OurGamma, partition);

# Prepare Minimization
  record:=PrepareMinTree(tuple, group, OurR, genus);
  MinimizationTree:=record.MinimizationTree;
  MinimumSet:=record.MinimumSet;

# Compute orbit
  Orb:=MappingClassOrbitCoreNoConj(tuple, group, genus, principaltuple,
        AbsGens, OurN, OurFreeGroup, OurAction, OurAlpha, OurBeta, OurGamma,
        5000, MinimizationTree, MinimumSet);

  return Orb;
end);
# End
