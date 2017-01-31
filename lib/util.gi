# This is a module for the GAP package MAPCLASS
# computing the orbit of the mapping class group. 
# This module contains various utility functions. 
# 
# A. James, K. Magaard, S. Shpectorov 2011


#
# NumberOfCommutatorProducts
# function for computing the number of ways to write a given 
# group element as a product of n commutators. 
# Reference: R. Guralnick's thesis
# t=table, c= index of some conjugacy class wrt t, n= number of commutators
InstallGlobalFunction(NumberOfCommutatorProducts,function(t,c,n) 
 
 return SizesCentralizers(t)[1]^(2*n-1)*
        Sum(List(Irr(t),x->x[c]/(x[1]^(2*n-1))));

end);

#
# PrintlnIf
# function takes a string as its first argument which is printed 
# if a sequence of bools are all true
#
#InstallGlobalFunction(PrintlnIF, function(arg)
#  local pstring, args, istrue;
#  pstring:=arg[1];
#  args:=arg{[2..Length(arg)]};
#  istrue:=true;
#  for i in [1..Length(args)] do
#    istrue:= istrue and arg[1];
#    if not istrue then
#      break;
#    fi;
#  od;
#  Print(pstring, "\n");
#end);

  

#
# TotalNumberOfTuples
# function computing the structure constant
# t = character table
# g = genus
# cc = the principal tuple in terms of it character table cc
#
InstallGlobalFunction(TotalNumberOfTuples,function(t,g,cc)
 local i,s;

 if Length(cc)=0 then
  return NumberOfCommutatorProducts(t,1,g);
 fi;

 s:=0;
 for i in [1..Length(SizesCentralizers(t))] do
  s:=s+NumberOfCommutatorProducts(t,i,g)*
       ClassStructureCharTable(t,Concatenation([InverseClasses(t)[i]],cc));
 od;
 return s;

end);

#
# TotalNumberTuples
# Computes the structure constant using group data
InstallGlobalFunction(TotalNumberTuples, function(group, tuple, genus)
  local tups, tbl, cc;

  tbl:=CharacterTable(group);
  cc:=ConjugacyClasses(tbl);
  tups:=List(tuple, i -> Filtered([1..Length(cc)], x -> i in cc[x])[1]);
  return TotalNumberOfTuples(tbl, genus, tups);
end);

#
# MaybePrint
# Wraps print by takes three lists as arguments and passing them to print based
# on output.
InstallGlobalFunction(MaybePrint, function(listn, listsl, listf)
  local output;

  output:= ValueOption("OutputStyle");
  # check that the value exists and is valid.
  if not output in ["silent", "single-line", "full"] then
    output := "full";
  fi;
  
  if output = "silent" then
    CallFuncList(Print, listn);
  elif output = "single-line" then
    CallFuncList(Print, listsl);
  elif output = "full" then
    CallFuncList(Print, listf);
  fi;
end);

InstallGlobalFunction(ClearLine, function()
  local width, height, i, blank;
  blank := " ";
  for i in [1..SizeScreen()[1]-10] do
    blank := Concatenation(blank, " ");
  od;
  Print("\c\r",blank,"\r");
end);

  











  

# End
