# This file is part of the GAP package MAPCLASS
# These functions provide the interface to the user for the purposes of orbit
# inspection.
#
# A. James, K. Magaard, S. Shpectorov 2011

#
# IsInOrbit
# Calculates whether a given tuple is in the Orbit
#
InstallGlobalFunction(IsInOrbit, function(Orb,tuple)
  local i,j,k, tupleTable;
  tupleTable:=Orb.TupleTable;
  k:=LookUpTuple(tuple, Orb.PrimeCode, Orb.HashLength, Orb.TupleTable, Orb.Hash,
  Orb.OurN);
  if k = fail then
    Print("The tuple is not in the table");
    return fail;
  else
    Print("Tuple Found!");
    return true;
  fi;
end);

#
# FindInTuple
# Returns the index of the tuple if found else return fail
#
InstallGlobalFunction(FindTupleInOrbit,function(Orb,tuple)
  local i,j,k, tupleTable;
  tupleTable:=Orb.TupleTable;
  k:=LookUpTuple(tuple, Orb.PrimeCode, Orb.HashLength, Orb.TupleTable, Orb.Hash,
  Orb.OurN);
  if k = fail then
    Print("The tuple is not in the table");
  else
    Print("Tuple Found!\n");
    return k;
  fi;
end);

#
# SelectTuple
# Return the tuple in the orbits tuple table at index i
#
InstallGlobalFunction(SelectTuple,function(Orb,index)
  local i,j,k,tupleTable;
  tupleTable:=Orb.TupleTable;
  return tupleTable[index].tuple;
end);

InstallGlobalFunction(LengthOfOrbit,function(Orbit)
#   Consider adding length to the orbit
  local i,j,k;
  return Length(Orbit.TupleTable);
end);

#
# IsEqualOrbit
# Calcuates whether two orbits are equal
#
InstallGlobalFunction(IsEqualOrbit,function(Orb1, Orb2)
  local i,j,k, x;
# do a cursory check that sizes are ok
  if not LengthOfOrbit(Orb1) = LengthOfOrbit(Orb2) then
    return fail;
  fi;

# select random element from orb1 and check if it lies in orb2
  x:=SelectTuple(Orb1,1);
  return IsInOrbit(Orb2,x);
end);

