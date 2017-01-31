# This file is part of a GAP package MAPCLASS
# It contains declarations for the global functions
# This file is called by init.g 
#
# 2011 Adam James

### main.gi ####################################################################

## MappingClassOrbits
DeclareGlobalFunction("MappingClassOrbits");

### interface.gi ############################################################### 

## AllMCOrbits
DeclareGlobalFunction("AllMCOrbits");

## AllMCOrbitsCore
DeclareGlobalFunction("AllMCOrbitsCore");

## GeneratingMCOrbitsCore
DeclareGlobalFunction("GeneratingMCOrbitsCore");

## GeneratingMCOrbits
DeclareGlobalFunction("GeneratingMCOrbits");

### orbit.gi ###################################################################

## MappingClassOrbit
DeclareGlobalFunction("MappingClassOrbit");

## MappingClassOrbitCore
DeclareGlobalFunction("MappingClassOrbitCore");

### orbitwo.gi #################################################################

## MappingClassOrbit
DeclareGlobalFunction("MappingClassOrbitNoConj");

## MappingClassOrbitCore
DeclareGlobalFunction("MappingClassOrbitCoreNoConj");

### orbitinspection.gi ########################################################

## IsInOrbit
DeclareGlobalFunction("IsInOrbit");

## FindTupleInOrbit
DeclareGlobalFunction("FindTupleInOrbit");

## SelectTuple
DeclareGlobalFunction("SelectTuple");

## LengthOfOrbit
DeclareGlobalFunction("LengthOfOrbit");

## IsEqualOrbit
DeclareGlobalFunction("IsEqualOrbit");

### util.gi ###################################################################

## NumberOfCommutatorProducts
DeclareGlobalFunction("NumberOfCommutatorProducts");

## TotalNumberOfTuples
DeclareGlobalFunction("TotalNumberOfTuples");

## TotalNumberTuples
DeclareGlobalFunction("TotalNumberTuples");

## MaybePrint
DeclareGlobalFunction("MaybePrint");

## Clear Line
DeclareGlobalFunction("ClearLine");

### action.gi ##################################################################

## MappingClassGroupGenerators
DeclareGlobalFunction("MappingClassGroupGenerators");

## MappingClassGroupGeneratorsL
DeclareGlobalFunction("MappingClassGroupGeneratorsL");

### pg.qi ######################################################################

## BraidGroupGenerators
DeclareGlobalFunction("BraidGroupGenerators");

### newgeneratingtuples.gi #####################################################

## NumberGeneratingTuples 
DeclareGlobalFunction("NumberGeneratingTuples");


### generatingtuples.gi ########################################################

## SubgroupsConatiningCC
DeclareGlobalFunction("SubgroupsContainingCC");

## SubgroupsGenByNielsenTuples
DeclareGlobalFunction("SubgroupsGenByNielsenTuples");

## LastOf
DeclareGlobalFunction("LastOf");

## NumberOfNielsenTuples
DeclareGlobalFunction("NumberOfNielsenTuples");

## NumberOfGeneratingTuples
DeclareGlobalFunction("NumberOfGeneratingTuples");

## NumberOfCommProducts
DeclareGlobalFunction("NumberOfCommProducts");

## TotalNumberOfNielsenTuples
DeclareGlobalFunction("TotalNumberOfNielsenTuples");

##  CalculateTuplePartition
DeclareGlobalFunction("CalculateTuplePartition");

### groups.gi ##################################################################

## CheckInSubgroup
DeclareGlobalFunction("CheckInSubgroup");

## IdentifySubgroup
DeclareGlobalFunction("IdentifySubgroup");

## RandomSubgroupTuple
DeclareGlobalFunction("RandomSubgroupTuple");

## AdjustSubgroupWeighting
DeclareGlobalFunction("AdjustSubgroupWeighting");

### mpc.gi #####################################################################

## PrepareId
DeclareGlobalFunction("PrepareId");

## PrepareIds
DeclareGlobalFunction("PrepareIds");

## GenerateRandomTuples
DeclareGlobalFunction("GenerateRandomTuples");

## GenConjTuple
DeclareGlobalFunction("GenConjTuple");

## PrepareConjugacyClasses
DeclareGlobalFunction("PrepareConjugacyClasses");

## IdElement
DeclareGlobalFunction("IdElement");

## PrepareMinimization
DeclareGlobalFunction("PrepareMinimization");

## MinimizeTuple
DeclareGlobalFunction("MinimizeTuple");

## MinimizeTupleQuick
DeclareGlobalFunction("MinimizeTupleQuick");

## PrepareMinTree
DeclareGlobalFunction("PrepareMinTree");

## GenerateMinData2
DeclareGlobalFunction("GenerateMinData2");

## SanityCheck
DeclareGlobalFunction("SanityCheck");

## EasyMinimizeTuple
DeclareGlobalFunction("EasyMinimizeTuple");

## QuickMinimizeTuple
DeclareGlobalFunction("QuickMinimizeTuple");

### perm.gi ####################################################################

## ExtractPermutations
DeclareGlobalFunction("ExtractPermutations");

### save.gi ####################################################################

## SaveOrbitToFile
DeclareGlobalFunction("SaveOrbitToFile");

## SaveOrbitWithFilename
DeclareGlobalFunction("SaveOrbitWithFilename");

## LoadOrbitFromFileName
DeclareGlobalFunction("LoadOrbitFromFileName");

## RestoreOrbitFromFile
DeclareGlobalFunction("RestoreOrbitFromFile");

### table.gi ###################################################################

## InitializeTable
DeclareGlobalFunction("InitializeTable");

## HashKey
DeclareGlobalFunction("HashKey");

## LookUpTuple
DeclareGlobalFunction("LookUpTuple");

## AddTuple
DeclareGlobalFunction("AddTuple");

## AddTupleF
DeclareGlobalFunction("AddTupleF");

## LookUpTupleF
DeclareGlobalFunction("LookUpTupleF");


## PrepareFingerPrinting
DeclareGlobalFunction("PrepareFingerPrinting");

## Getfprint
DeclareGlobalFunction("Getfprint");

## HashFinger
DeclareGlobalFunction("HashFinger");

## LookUpHashFrmPrint
DeclareGlobalFunction("LookUpHashFrmPrint");

## RanFreeWord
DeclareGlobalFunction("RanFreeWord");

## GenFHashFunction
DeclareGlobalFunction("GenFHashFunction");

### tuples.gi ##################################################################

## SuggestTuple
DeclareGlobalFunction("SuggestTuple");

## RandomGeneratingTuple
DeclareGlobalFunction("RandomGeneratingTuple");

## CollectRandomTuples
DeclareGlobalFunction("CollectRandomTuples");

## CollectRandomGeneratingTuples
DeclareGlobalFunction("CollectRandomGeneratingTuples");

## CleanCurrent
DeclareGlobalFunction("CleanCurrent");

## CleanAll
DeclareGlobalFunction("CleanAll");

### fingerprinting.gi ########################################################

## InitializeFingerprintTable
DeclareGlobalFunction("InitializeFingerprintTable");

## FingerprintTuple
DeclareGlobalFunction("FingerprintTuple");

## HashKeyOfPrint
DeclareGlobalFunction("HashKeyOfPrint");

## LookUpFingerprint
DeclareGlobalFunction("LookUpFingerprint");

## LookUpTupleFP
DeclareGlobalFunction("LookUpTupleFP");

## NonConjLookUpTupleFP
DeclareGlobalFunction("NonConjLookUpTupleFP");

## AddTupleFP
DeclareGlobalFunction("AddTupleFP");

## AddTupleFP
DeclareGlobalFunction("FPRandomWord");

### THE END ##################################################################
