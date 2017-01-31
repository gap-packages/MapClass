# This file is pat of the GAP package MAPCLASS
# A collection of routines which wrap the main routine MappingClassOrbits
# We have the follwing functions:
#   GeneratingMCOrbits
#   GeneratingMCOrbitsCore
#   AllMCOrbits
#   AllMCOrbitsCore
#   CalculateTuplePartition
#
# A. James, K. Magaard, S. Shpectorov 2011

#
# GeneratingMCOrbits
# A function which computes (with sensible default values) the
# mapping class group orbits for a given group and tuple type.
#
InstallGlobalFunction(GeneratingMCOrbits,function(group, genus, tuple)
  local structureconst, partition, isGenerating, IsSilent;

  if not ValueOption("OutputStyle") in ["silent", "single-line"] then
    Exec("date");
    Print("\n");
  fi;
  partition:=CalculateTuplePartition(group, tuple);
  if partition = fail then
    return fail;
  fi;
  structureconst:=NumberGeneratingTuples(group, partition, tuple, genus);
  MaybePrint([],[], ["\nTotal Number of Tuples: ", structureconst, "\n\n"]);
  return MappingClassOrbits(group, genus, tuple, partition, structureconst:
    IsGenerating:=true);;
end);

#
# GeneratingMCOrbitsCore
# A base function computing the orbits for generatings tuples only
#
InstallGlobalFunction(GeneratingMCOrbitsCore,function(group, genus,
  principaltuple, partition, structureconst)
  local  name, IsSilent;

  if not ValueOption("OutputStyle") in ["single-line", "silent"] then
    Exec("date");
    Print("\n");
  fi;
  return MappingClassOrbits(group, genus, principaltuple, partition,
  structureconst: IsGenerating:=true);;

end);

#
# AllMCOrbits
# Calculates all mapping class orbits. Uses sensible defualts for simple use
#
InstallGlobalFunction(AllMCOrbits,function(group, genus,
  principaltuple)
  local structureconst, partition, chartable, orbs, IsSilent;

  if not ValueOption("OutputStyle") in  ["single-line", "silent"] then
    Exec("date");
    Print("\n");
  fi;

  partition:= CalculateTuplePartition(group, principaltuple);
  if partition = fail then
    return fail;
  fi;
  structureconst:=TotalNumberTuples(group, principaltuple, genus);
  MaybePrint( [],
    [], 
    ["Total Number of Tuples: ", structureconst, "\n"]);
  orbs:=MappingClassOrbits(group, genus, principaltuple, partition,
         structureconst);;
  return orbs;;
end);

#
# ALLMCOrbitsCore
# Calculates all mapping class orbits. Has access to whole OptionsStack so can
# be fed optional arguments
#
InstallGlobalFunction(AllMCOrbitsCore,function(group, genus,
  principaltuple, partition,
  structureconst)
  local chartable, orbs, IsSilent;

  if not ValueOption("OutputStyle") in ["single-line", "silent"] then
    Exec("date");
    Print("\n");
  fi;
  
  orbs:=MappingClassOrbits(group, genus, principaltuple, partition,
  structureconst);
  return orbs;;
end);

#
# CalculatePartition
# Given a tuple returns a partition of the conjugacy classes. Checks to make
# the tuple is ordered correctly.
InstallGlobalFunction(CalculateTuplePartition, function(group, tuple)
  local i,j,cc, reps, ind, indcopy, p, N, config, n;
  cc:=ConjugacyClasses(group);
  reps:=List(cc,Representative);

  # list such that n= value at index i is such that element at index i of tuple
  # in index 
  #  n of cc
  ind:=Flat(List( tuple, t -> Filtered([1..Length(cc)], x -> t in cc[x])));

# Now check to see of we have tuple of right configuration
  indcopy:=ShallowCopy(ind);
  N:=Length(indcopy);
  config:=[indcopy[1]];
  for i in [1..Length(indcopy)-1] do
    if not indcopy[i] = indcopy[i+1] then
      Add(config, indcopy[i+1]);
    fi;
  od;
  if  not Length(config) = Length(Set(config)) then
    Print("The tuple should be of a particular form. \n ");
    Print("For more information type '?CalculateTuplePartition'");
    return fail;
  fi;

# Calculate partition
  p:=List(List(config, c-> Filtered(ind, x -> x = c)), i -> Size(i));
  return p;
end);

  
