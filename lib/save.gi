# This module is part of a GAP package MAPCLASS.
# It contains functions saving orbit data in 
# files and restoring it back from files
#
# A. James, K. Magaard, S. Shpectorov 2011



#
# SaveOrbit
# Function saving a new orbit in a file
#
InstallGlobalFunction(SaveOrbitToFile,function(Orb, NumberOfOrbits, name )
  local n,i;
  n:=Concatenation("_",name,"/",String(NumberOfOrbits));
  AppendTo(n,"local Orb");
  for i in [1..Length(GeneratorsOfGroup(Orb.OurFreeGroup))] do
    AppendTo(n, ", f", String(i));
  od;
  AppendTo(n, ";\n");
  AppendTo(n, "Orb:=rec();\n");
  AppendTo(n,"Orb.PrincipalFiniteGroup:=Group(",
            GeneratorsOfGroup(Orb.PrincipalFiniteGroup),");\n");
  AppendTo(n,"Orb.OurG:=",Orb.OurG,";\n");
  AppendTo(n,"Orb.OurR:=",Orb.OurR,";\n");
  AppendTo(n,"Orb.OurN:=",Orb.OurN,";\n");
  AppendTo(n,"Orb.NumberOfGenerators:=", Orb.NumberOfGenerators,";\n");
  AppendTo(n,"Orb.OurFreeGroup:=FreeGroup(Orb.NumberOfGenerators);\n");
  AppendTo(n,"Orb.AbsGens:=[];\n");
  for i in [1..Length(GeneratorsOfGroup(Orb.OurFreeGroup))] do
    AppendTo(n,"f",String(i),":=Orb.OurFreeGroup.",String(i),";\n");
    AppendTo(n,"Orb.AbsGens[",String(i),"]:=f",String(i),";\n");
  od;
  AppendTo(n,"Orb.OurAlpha:=Orb.AbsGens{[1..Orb.OurG]};\n");
  AppendTo(n,"Orb.OurBeta:=Orb.AbsGens{[Orb.OurG+1..2*Orb.OurG]};\n");
  AppendTo(n,"Orb.OurGamma:=");
  AppendTo(n,"Orb.AbsGens{[2*Orb.OurG+1..2*Orb.OurG+Orb.OurR]};\n");
  AppendTo(n,"Orb.TupleTable:=",Orb.TupleTable,";\n");
  AppendTo(n,"Orb.HashLength:=",Orb.HashLength,";\n");
  AppendTo(n,"Orb.Hash:=",Orb.Hash,";\n");
  AppendTo(n,"Orb.PrimeCode:=",Orb.PrimeCode,";\n");
  AppendTo(n,"Orb.OurAction:=",Orb.OurAction,";\n");
  AppendTo(n,"Orb.ActionOnOrbit:=",Orb.ActionOnOrbit,";\n");
  AppendTo(n,"Orb.MinimizationTree:=",Orb.MinimizationTree,";\n");
  AppendTo(n,"Orb.MinimumSet:=",Orb.MinimumSet,";\n");
  AppendTo(n,"return Orb",";\n");
# TODO: Add New attributes
end);

InstallGlobalFunction(SaveOrbitWithFilename,function(Orb, filename )
  local n,i;
  n:=filename;
  AppendTo(n,"local Orb");
  for i in [1..Length(GeneratorsOfGroup(Orb.OurFreeGroup))] do
    AppendTo(n, ", f", String(i));
  od;
  AppendTo(n, ";\n");
  AppendTo(n, "Orb:=rec();\n");
  AppendTo(n,"Orb.PrincipalFiniteGroup:=Group(",
            GeneratorsOfGroup(Orb.PrincipalFiniteGroup),");\n");
  AppendTo(n,"Orb.OurG:=",Orb.OurG,";\n");
  AppendTo(n,"Orb.OurR:=",Orb.OurR,";\n");
  AppendTo(n,"Orb.OurN:=",Orb.OurN,";\n");
  AppendTo(n,"Orb.NumberOfGenerators:=", Orb.NumberOfGenerators,";\n");
  AppendTo(n,"Orb.OurFreeGroup:=FreeGroup(Orb.NumberOfGenerators);\n");
  AppendTo(n,"Orb.AbsGens:=[];\n");
  for i in [1..Length(GeneratorsOfGroup(Orb.OurFreeGroup))] do
    AppendTo(n,"f",String(i),":=Orb.OurFreeGroup.",String(i),";\n");
    AppendTo(n,"Orb.AbsGens[",String(i),"]:=f",String(i),";\n");
  od;
  AppendTo(n,"Orb.OurAlpha:=Orb.AbsGens{[1..Orb.OurG]};\n");
  AppendTo(n,"Orb.OurBeta:=Orb.AbsGens{[Orb.OurG+1..2*Orb.OurG]};\n");
  AppendTo(n,"Orb.OurGamma:=");
  AppendTo(n,"Orb.AbsGens{[2*Orb.OurG+1..2*Orb.OurG+Orb.OurR]};\n");
  AppendTo(n,"Orb.TupleTable:=",Orb.TupleTable,";\n");
  AppendTo(n,"Orb.HashLength:=",Orb.HashLength,";\n");
  AppendTo(n,"Orb.Hash:=",Orb.Hash,";\n");
  AppendTo(n,"Orb.PrimeCode:=",Orb.PrimeCode,";\n");
  AppendTo(n,"Orb.OurAction:=",Orb.OurAction,";\n");
  AppendTo(n,"Orb.ActionOnOrbit:=",Orb.ActionOnOrbit,";\n");
  AppendTo(n,"Orb.MinimizationTree:=",Orb.MinimizationTree,";\n");
  AppendTo(n,"Orb.MinimumSet:=",Orb.MinimumSet,";\n");
  AppendTo(n,"Orb.fprecord:=",Orb.fprecord,";\n");
  AppendTo(n,"return Orb",";\n");
# TODO: Add New attributes
end);

InstallGlobalFunction(LoadOrbitFromFileName, function(filename)
  local fun, Orb;
  fun:=ReadAsFunction(filename);
  Orb:=fun();
  return Orb;
end);



#
# RestoreOrbit
# Function restoring an orbit from a file
#
InstallGlobalFunction(RestoreOrbitFromFile,function(arg)
  local n, Orb, k, ProjectName, path, fun;
  k:=arg[1];
  ProjectName:=arg[2];
  n:=Concatenation("_",ProjectName,"/",String(k));
  if Length(arg)=3 then
    path:=arg[3];
    n:=Filename(path,n);
  fi;
  fun:=ReadAsFunction(n);
  Orb:=fun();
  return Orb;
end);


# End
