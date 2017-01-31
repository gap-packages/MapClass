# This module is part of a GAP package MAPCLASS.
# It contains the main function computing all
# mapping class orbits of a given type. 
#
# A. James, K. Magaard, S. Shpectorov 2011


#
# MCGOrbitsCore
# This is the main function of the packages. It computes the Mapping class group
# orbit for a given tuple and conjugacy class size. The parameters are as
# follows:
#
#  group       = the finite group in question
#  genus       = genus of base surface
#  tuple       = the principle tuple
#  partition   = partition of the branch points (if this is known)
#  structconst = structure constant determining how many tuple need checking
# 
# The function also takes the following options which are placed in the options
# stack.
#
# * BumpUp
# * CutOffValue
# * HashLength
# * InitialNumberOfRandomTuples
# * InitialSizeCutoff
# * InitialWeight
# * IsGenerating
# * KnockDown
# * MaximumWeight
# * MinimumWeight
#
InstallGlobalFunction(MappingClassOrbits,function(group, genus, tuple, partition,
  structureconst )

  local i,t,g,c,r,  NumberOfOrbits, GeneratingOrbits, SmallSubgroups, Orb,
  SubgroupRecord, defaults, name, CutOffValue, NumberOfRandomTuples,
  RandomTuples, SuggestedTuples, record, HashLength, OurN, OurAlpha, OurBeta,
  MinimumSet, OurGamma, OurR, OurAction, OurFreeGroup , AbsGens,
  NumberOfGenerators, MinimizationTree, IsGenerating, orbits, SaveOrbit,
  SaveOrbitString, firstrun, IsSilent, output, ccdata, mindata, QuickMinimize,
  QuickMinimizeData, FixElem, x0, rep, FingerPrinting ;
  
# Setup defaults parameters
  Orb:=rec();
  SubgroupRecord:=rec();
  defaults:=rec(InitialSizeCutOff:=128, MaximumWeight:=40, MinimumWeight:=20,
             InitialWeight:=20, BumpUp:=7, KnockDown:=7);

# Copy the optional parameters and for those unassigned assign defualt values
  for name in RecNames(defaults) do
    if ValueOption(name) = fail then
      SubgroupRecord.(name):= defaults.(name);
    else
      SubgroupRecord.(name) := ValueOption(name);
    fi;
  od;

# Those optional parameters not in SubgroupRecord
  if not ValueOption("InitialNumberOfRandomTuples") = fail then
    NumberOfRandomTuples:=ValueOption("InitialNumberOfRandomTuples");
  else
    NumberOfRandomTuples:=20;
  fi;

  if not ValueOption("InitialCutOffValue") = fail then
    CutOffValue:=ValueOption("InitialCutOffValue");
  else
    CutOffValue:=0;
  fi;
  if not ValueOption("HashLength") = fail then
    HashLength:=ValueOption("HashLength");
  else
    HashLength:=5000;
  fi;
  if not ValueOption("IsGenerating") = fail then
    IsGenerating:=ValueOption("IsGenerating");
  else
    IsGenerating:=fail;
  fi;
  if not ValueOption("SaveOrbit") = fail then
    SaveOrbitString:=ValueOption("SaveOrbit");
    SaveOrbit:=true;
  else
    SaveOrbit:=fail;
  fi;

# Verbosity model:
# We have three modes of output - silent, single-line, full
  output := ValueOption("Output");
  if not output in ["silent", "single-line", "full"] then
    output := "full";
  fi;

  if not ValueOption("FixElem") = fail then 
    FixElem:=true;
    x0:=ValueOption("FixElem");
  else
    FixElem:=false;
  fi;

  ## Method Selection
  if not ValueOption("FingerPrinting") = fail then 
    FingerPrinting:=true;
  else
    FingerPrinting:=false;
  fi;

  
#
# Initialize 
#


# group...
  OurN:=NrMovedPoints(group);
  OurR:=Length(tuple);


# abstract generators...
  NumberOfGenerators:=2*genus + Length(tuple);
  OurFreeGroup:=FreeGroup(NumberOfGenerators);
  AbsGens:=GeneratorsOfGroup(OurFreeGroup);
  OurAlpha:=AbsGens{[1..genus]};
  OurBeta:=AbsGens{[genus+1..2*genus]};
  OurGamma:=AbsGens{[2*genus+1..2*genus+OurR]};

# mapping class group generators...
  if FixElem = true then
    OurAction:= MappingClassGroupGeneratorsL(genus, OurR,
       AbsGens, OurAlpha, OurBeta, OurGamma,
       partition );
  else
    OurAction:= MappingClassGroupGenerators(genus, OurR,
       AbsGens, OurAlpha, OurBeta, OurGamma,
       partition );
  fi;

# number of orbits...
  NumberOfOrbits:=0;
  GeneratingOrbits:=[];
 
# initialize SmallSubgroups, TotalWeight and SizeCutoff...
  SubgroupRecord.SmallSubgroups:=[];
  record:=rec(subgroup:=group,
              classes:= List(tuple{[1..OurR]},x->[x]),
              weight:= SubgroupRecord.InitialWeight);
  Append(SubgroupRecord.SmallSubgroups,[record]);
  SubgroupRecord.TotalWeight:=SubgroupRecord.InitialWeight;
  SubgroupRecord.SizeCutoff:=Size(group)-1;
 
# list of random tuples...
  RandomTuples:=[];
  SuggestedTuples:=[];

# number of tuples remaining...
  t:=structureconst;


# initialize minimization tree
  if FingerPrinting = true then
    # Don't bother with preparing a minimization tree.
    MinimizationTree:=[];
    MinimumSet:=[];
  else
    record:= PrepareMinTree(tuple, group,
        OurR, genus);
    MinimizationTree:=record.MinimizationTree;
    MinimumSet:=record.MinimumSet;
  fi;

# Prepare quick minimization if applicable
  if not ValueOption("QuickMinimize") = fail then
    QuickMinimize:=true;
  else
    QuickMinimize:= false;
    QuickMinimizeData:= false;
  fi;
  if QuickMinimize then
    Print("Preparing Minimization...\n");
    ccdata:=rec();
    ccdata.base:= BaseOfGroup(group);
    ccdata.cc:=PrepareConjugacyClasses(tuple, group);
    ccdata.RR:=PrepareIds(ccdata.cc, ccdata.base);
    mindata:=GenerateMinData2(ccdata, MinimizationTree, MinimumSet,
              group );
    QuickMinimizeData:=rec();
    QuickMinimizeData.ccdata:=ccdata;
    QuickMinimizeData.mindata:=mindata;
  fi;

# number of orbits before last collection
  r:=0;
  firstrun:=true; # Keeps track of whether or not we are on first orbit

#
# main loop
#
  orbits:=[];
  while t>CutOffValue do
#   Fill up RandomTuples
    if Length(RandomTuples)=0 then
      if Length(SuggestedTuples)=0 then
        if NumberOfOrbits=r and r<>0 then
          NumberOfRandomTuples:=NumberOfRandomTuples*2;
        fi;
        r:=NumberOfOrbits;

#       Collect Random Tuples
#       Use different routines based on whether looking for generating tuples,
#       this is controlled by the value of IsGenerating
        if IsGenerating = true then
          RandomTuples:=CollectRandomGeneratingTuples(NumberOfRandomTuples,
                         genus, OurR, SubgroupRecord, group, tuple);
        else
          RandomTuples:=CollectRandomTuples( NumberOfRandomTuples, genus,
          OurR, SubgroupRecord);
        fi;

      else
        RandomTuples:=ShallowCopy(SuggestedTuples);
      fi;
      RandomTuples:=CleanAll(RandomTuples, orbits, SubgroupRecord);
    else
      if FixElem = true then
        rep:=RepresentativeAction(group, RandomTuples[1].tuple[1], x0);
        RandomTuples[1].tuple := List(RandomTuples[1].tuple, z ->z^rep);
      fi;

      MaybePrint([], [], ["\n\nOrbit", NumberOfOrbits+1, ":\n"]);
#      if not IsSilent then
#        Print("\n\nOrbit ",NumberOfOrbits+1,":\n");
#      fi;

#     Compute the maping class orbit and save to Orb
      Orb:=MappingClassOrbitCore(RandomTuples[1].tuple, group,
              genus, tuple, AbsGens, OurN, OurFreeGroup, OurAction, OurAlpha,
              OurBeta, OurGamma, HashLength, MinimizationTree ,MinimumSet:
              CurrentTotal:=(structureconst - t), 
              ExTotal:=structureconst,
              NOrbits:=NumberOfOrbits,
              QuickMinimizeData:=QuickMinimizeData  );

      MaybePrint([], [], ["Length=",Length(Orb.TupleTable),"\n"]);


#     Adjust the subgroup weighting
      g:=RandomTuples[1].subgroupNumber;
      AdjustSubgroupWeighting(g, SubgroupRecord);

#     Calculate the generated subgroup
      g:=Subgroup(group,RandomTuples[1].tuple);
      MaybePrint([], [], ["Generating Tuple  =", RandomTuples[1].tuple, "\n"]);
      
#     Check if the tuple is generating
      if Size(g)=Size(group) then
        Append(GeneratingOrbits,[[NumberOfOrbits, Length(Orb.TupleTable)]]);
      fi;

#     Identify the subgroup and save some information about them
      IdentifySubgroup(g, SubgroupRecord, group, tuple, OurR);
      c:=Centralizer(group,g);
      Orb.Centralizer:=c;
      Orb.CentralizerSize:=Size(c);
      Add(orbits, Orb);
      
#     Save the orbit if needs be
      if SaveOrbit = true then
        if firstrun then
          Exec(Concatenation("rm -rf _",SaveOrbitString));
          Exec(Concatenation("mkdir _",SaveOrbitString));
          firstrun:=false;
        fi;
        MaybePrint([], [] , ["Saving orbit to file _", SaveOrbitString, "/",
        NumberOfOrbits, "\n" ]);
        SaveOrbitToFile(Orb, NumberOfOrbits, SaveOrbitString);
      fi;

      MaybePrint([], [] , ["Centralizer size=",Size(c),"\n"]);
      NumberOfOrbits:=NumberOfOrbits+1;
      t:=t-Length(Orb.TupleTable)*Index(Orb.PrincipalFiniteGroup,c);
      MaybePrint([], [] , [t," tuples remaining\n"]);
      MaybePrint([], ["\c\rCurrent orbit: ", t , "tuples remaining \c\r"], 
      [ "Cleaning current orbit...\c"]);
      RandomTuples:=CleanCurrent(RandomTuples, Orb, SubgroupRecord);
      MaybePrint([], [], ["Cleaning done; ",Length(RandomTuples)," random",  
      " tuples remaining\n"]);
      
    fi;
  od;

  MaybePrint([], 
    ["\c Computation complete : ", NumberOfOrbits, " orbits found.\n"],
    ["Computation complete : ", NumberOfOrbits, " orbits found.\n"]);
  
  if not ValueOption("OutputStyle") in ["silent", "single-line"]  then
    Exec("date");
  fi;
  return orbits;;
end);
# End
