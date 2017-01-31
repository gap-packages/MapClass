# This module is part of a GAP package MAPCLASS. 
# It deals with maintaining a list of small subgroups 
# and generating random tuples in them.
# 
# A. James, K. Magaard, S. Shpectorov 2011
 
#
# CheckInSubgroup(s)
# Putting a new subgroup on the list
#
InstallGlobalFunction(CheckInSubgroup,function(s,SubgroupRecord,
  PrincipalFiniteGroup, PrincipalTuple, OurR)
  local r,l,i;
 
  r:=List(ConjugacyClasses(s),x->Representative(x)); 

  l:=[]; 
  for i in [1..OurR] do 
    Append(l,[Filtered(r,x->
        IsConjugate(PrincipalFiniteGroup, x,
        PrincipalTuple[i]))]); 
  od;

  Append(SubgroupRecord.SmallSubgroups, [rec( subgroup:=s, classes:=l,
      weight:=SubgroupRecord.InitialWeight)]);
  SubgroupRecord.TotalWeight:=SubgroupRecord.TotalWeight +
      SubgroupRecord.InitialWeight;
end); 


#
# IdentifySubgroup
# Check whether or not a subgroup is on the list
# 
#
InstallGlobalFunction(IdentifySubgroup,
function(s,SubgroupRecord,PrincipalFiniteGroup, PrincipalTuple, OurR)
  local r;

# if the group is our full group then increase its weight
  if Size(s)>SubgroupRecord.SizeCutoff then
    SubgroupRecord.TotalWeight:=SubgroupRecord.TotalWeight-
    SubgroupRecord.SmallSubgroups[1].weight;
    SubgroupRecord.SmallSubgroups[1].weight:=
      MinimumList([SubgroupRecord.SmallSubgroups[1].weight +
      SubgroupRecord.BumpUp, SubgroupRecord.MaximumWeight]); 
    SubgroupRecord.TotalWeight:=SubgroupRecord.TotalWeight +
      SubgroupRecord.SmallSubgroups[1].weight; return;
  fi;
  for r in SubgroupRecord.SmallSubgroups{[2..Length(SubgroupRecord.SmallSubgroups)]} do
    if Size(r.subgroup)=Size(s) then
      if RepresentativeAction(Centralizer( PrincipalFiniteGroup,
        s.1), r.subgroup,s)<>fail then
        SubgroupRecord.TotalWeight:=SubgroupRecord.TotalWeight-r.weight;
        r.weight:=MinimumList([r.weight+SubgroupRecord.BumpUp,
            SubgroupRecord.MaximumWeight]);
        SubgroupRecord.TotalWeight:=SubgroupRecord.TotalWeight+r.weight;
      return;
      fi;
    fi;
  od;
  CheckInSubgroup(s,SubgroupRecord, PrincipalFiniteGroup, PrincipalTuple, OurR);
end);
 

#
# AdjustSubgroupWeighting
#
InstallGlobalFunction(AdjustSubgroupWeighting,function(subgroupNumber,
  SubgroupRecord)
  local g;
  g:=subgroupNumber;

  SubgroupRecord.TotalWeight:=SubgroupRecord.TotalWeight -
      SubgroupRecord.SmallSubgroups[g].weight;
  SubgroupRecord.SmallSubgroups[g].weight:=
      MinimumList([SubgroupRecord.MaximumWeight,
      SubgroupRecord.SmallSubgroups[g].weight+SubgroupRecord.BumpUp]);
  SubgroupRecord.TotalWeight:=SubgroupRecord.TotalWeight +
      SubgroupRecord.SmallSubgroups[g].weight;
end);
# End 
