# This file is part of the GAP package MAPCLASS
# This files contains the routines necessary for tuple minimization. It also
# contains the routines necessary for create a precompiled minimization tree.
# 
# Before Using MinimizeTuple one must:
# 1. Precompute the conjugacy classes with PreConjClass(Tups);
# 2. Prepare the tree with PrepareMinimization();
#
# A. James, K. Magaard, S. Shpectorov 2011

#
# GenerateRandomTuples()
# Generates Random Tuple
#
InstallGlobalFunction(GenerateRandomTuples,function(CC)
    return List([1..Length(CC)], i -> Random(CC[i]));
end);

# Produce a Random tuple conjugate to argument
InstallGlobalFunction(GenConjTuple,function(tup, PrincipalFiniteGroup)
    local i,j,g;
    g:= Random(PrincipalFiniteGroup);
    return List(tup, i->i^g);
end);

#
# PreConjClass(tuple)
# Precompute the conjugacy classes of the principal tuple
#

InstallGlobalFunction(PrepareConjugacyClasses,function(tup,PrincipalFiniteGroup)
    local i,j,g,cc;
    cc:=[];
    for i in [1..Length(tup)] do
        cc[i]:=Orbit(PrincipalFiniteGroup,tup[i]);
    od;
    return cc;
end);

## WARNING : This will work only if we precompute the conjugacy classes and the
# elements in them have some fixed order. We must do this only once at the
# beginning of the routine.

#
# PrepareId(CC)
# function id-ing elements of CC
#

InstallGlobalFunction(PrepareId,function(cc,OurBase)
    local i,j,k,rr;
    rr:=[[]];

    for i in [1..Length(cc)] do
        j:=1;
        k:=1;
        while j<Length(OurBase) do
            if IsBound(rr[k][OurBase[j]^cc[i]]) then
                k:=rr[k][OurBase[j]^cc[i]];
            else
                Add(rr,[]);
                rr[k][OurBase[j]^cc[i]]:=Length(rr);
                k:=Length(rr);
            fi;
            j:=j+1;
        od;
        rr[k][OurBase[j]^cc[i]]:=i;
    od;
    return rr;
end);

## PrepareIds
InstallGlobalFunction(PrepareIds,function(CC,base)
    local i,j,k,RR;
    RR:=[];
    for i in [1..Length(CC)] do
        Print("Preparing ID Tree", i, "\n");
        RR[i]:=PrepareId(CC[i], base);
    od;
    return RR;
end); 
        

InstallGlobalFunction(IdElement,function(c,n,OurBase,RR)
  # returns index i such that cc[n][i] = c
    local j,k;
    j:=1;
    k:=1;
    while j<Length(OurBase) do
        k:=RR[n][k][OurBase[j]^c];
        j:=j+1;
    od;
    return RR[n][k][OurBase[j]^c];
end);

#
# PrepareMinimization()
# Prepares the MinimizationTree
#
InstallGlobalFunction(PrepareMinimization,function(PrincipalFiniteGroup, CC,
  OurR, OurG) 
  local i,m,g,k,oo,mi,re,d,j,c,t,r,n,pos,minforg,min,
  MinimizationTree, MinimumSet, OurNN, MinPointers;
    OurNN:=2*OurG + OurR;
    # Prepare first level
    MinimizationTree:=[[PrincipalFiniteGroup]];
    MinimumSet:=[[[Minimum(CC[OurR]),1,1]]];
    MinPointers:=[];
    i:=1;
    while (IsBound(MinimizationTree[i][1]) and i < OurNN)
        do
        m:=MinimizationTree[i];
        MinimizationTree[i+1]:=[];
        MinimumSet[i+1]:=[];
        for n in [1..Length(m)] do
            g:=m[n];
            #Print("Size of g = ", Size(g), "\n");
            if Size(g)<>1 then
                mi:=MinimumSet[i];
                for j in [1..Length(mi)] do
                    if mi[j][2]=n then
                        min:=mi[j][1];
                        d:=Centralizer(g,min);
                        if Size(d)<>1 then
                            #Print("Size of Centralizer = ", Size(d[1]), "\n");
                            #Print("Checking if element is in tree \n");
                            pos:=Position(MinimizationTree[i+1],d);
                            if pos=fail then
                                #Print("Adding element to tree\n");
                                Add(MinimizationTree[i+1],d);
                                pos:=Length(MinimizationTree[i+1]);
                            fi;
                            # Add a pointer to the next minimal centralizer.
                            #Print("Add a pointer with value", pos , "\n");
                            mi[j][3]:=pos;
                        fi;
                    fi;
                od;
                for n in [1..Length(MinimizationTree[i+1])] do
                    g:=MinimizationTree[i+1][n];
                    #Print("Computing orbits\n");
                    if i<OurR then
                        oo:=OrbitsDomain(g,CC[OurR-i]);
                    else
                        oo:=OrbitsDomain(g,PrincipalFiniteGroup);
                    fi;
                    #Print("Computing minimal elements for group ", n , "\n");
                    mi:=List(oo,Minimum);
                    mi:=List(mi, i->[i,n,0]);
                    #Print(" Minimal list = ", mi, "\n");
                    MinimumSet[i+1]:=Concatenation(MinimumSet[i+1],mi);
                od;
            fi;
        od;
        i:=i+1;
    od;
    return rec(MinimizationTree:=MinimizationTree, MinimumSet:=MinimumSet);
end);

#
# MinimimizeTuple(tuple)
# Minimizes the tuple using the precompiled MinimizationTree 
# TODO : Memoization of tuple on the fly might be quicker
#
InstallGlobalFunction(MinimizeTuple,function(tt, MinimizationTree, MinimumSet,
  NumberOfGenerators) 
  local t,k,i,n,g,j,r,next,rep,pnt,min,mi,y;

    t:=ShallowCopy(tt);
    t:=Reversed(t);
    next:=1;
    #Print(NumberOfGenerators, "\n");
    for i in [1..NumberOfGenerators] do
        # Print("Step ", i , "\n");

        # Find the minima for this level
        mi:=StructuralCopy(MinimumSet[i]);
        mi:=Filtered(mi, y-> y[2]=next);

        # if the tree becomes trivial then break
        if Length(mi)=0 then
            break;
        fi;
        g:= MinimizationTree[i][next];
        # Print(g, "\n");

        for r in [1..Length(mi)] do
            min:=mi[r][1];
        #    Print("minimal element here is ", min, "\n");
            next:=mi[r][3];
            if IsConjugate(g,min,t[i]) then

                rep:= RepresentativeAction(g,t[i],min);
                for j in [i..NumberOfGenerators] do
                    t[j]:=t[j]^rep;
                od;
       #         Print("tuple after step ", i, " = ", Reversed(t), "\n");
                break;
            fi;
        od;
        if next=0 then
            break;
        fi;
    od;
    t:=Reversed(t);
    #Print("Tuple Minimized\n");
    return t;
end);

## MinimizeTupleQuick uses a memoised version of the minimisation tree. Will be
## quicker I hope!
InstallGlobalFunction(MinimizeTupleQuick,function(tt, MinimizationTree, MinimumSet,
  NumberOfGenerators) 
  local t,k,i,n,g,j,r,next,rep,pnt,min,mi,y;

    t:=ShallowCopy(tt);
    t:=Reversed(t);
    next:=1;
    #Print(NumberOfGenerators, "\n");
    for i in [1..NumberOfGenerators] do
        # Print("Step ", i , "\n");

        # Find the minima for this level
        mi:=StructuralCopy(MinimumSet[i]);
        mi:=Filtered(mi, y-> y[2]=next);

        # if the tree becomes trivial then break
        if Length(mi)=0 then
            break;
        fi;
        g:= MinimizationTree[i][next];
        # Print(g, "\n");

        for r in [1..Length(mi)] do
            min:=mi[r][1];
        #    Print("minimal element here is ", min, "\n");
            next:=mi[r][3];
            if IsConjugate(g,min,t[i]) then

                rep:= RepresentativeAction(g,t[i],min);
                for j in [i..NumberOfGenerators] do
                    t[j]:=t[j]^rep;
                od;
       #         Print("tuple after step ", i, " = ", Reversed(t), "\n");
                break;
            fi;
        od;
        if next=0 then
            break;
        fi;
    od;
    t:=Reversed(t);
    #Print("Tuple Minimized\n");
    return t;
end);

#
# TstPrepare()
# Tests the construction of the minimization tuple
#
InstallGlobalFunction(PrepareMinTree,function(tuple, PrincipalFiniteGroup, OurR,
  OurG) 
  local cc,r;
    cc:=PrepareConjugacyClasses(tuple, PrincipalFiniteGroup);
    r:=PrepareMinimization(PrincipalFiniteGroup, cc, OurR, OurG);
    return r;
end);
    
#
# SanityCheck
# Check that the minimization structures are consistent
#
InstallGlobalFunction(SanityCheck,function(MinimizationTree,
  MinimumSet,NumberOfGenerators)
  local i,j,k,gg,g,p,q, pnt, mins, bool, next,
  mt, min, mi;
  
  mt:=StructuralCopy(MinimizationTree);
  for i in [1..NumberOfGenerators] do
      mins:=StructuralCopy(MinimumSet[i]);
      for j in [1..Length(mins)] do
          min:=mins[j];
          mi:=min[1];
          pnt:= min[2];
          gg:=mt[i][min[2]];
          next:= min[3];
          if next <> 0 then
              

              # Check that the centralizer works
              if IdGroup(Centralizer(gg,mi))=IdGroup(mt[i+1][next]) then
                  Print(" Centralizer checks out\n");
              else
                  Print(" Bad Centralizer\n");
                  Print(" Checked element ", mi, "\n");
                  Print( " Group one: ", IdGroup(Centralizer(gg,mi)), "\n");
                  Print( " Level ", i , ", Element ", j, "\n");
                  Print( " Current group at index " , pnt, "\n");
                  Print( " Next group at index ", next, "\n");
                  Print(" Group two: ", IdGroup(mt[i+1][next]) ,"\n\n"); 
              fi;
          fi;
      od;
  od;
  return true;
end);
# End          
           
#
# EasyMinimizeTuple
#
InstallGlobalFunction(EasyMinimizeTuple, function(group, genus, tuple)
  local minTree, minSet, numberOfGens, Orb, ttuple, start, ptuple, mintup, r;
  ttuple:=ShallowCopy(tuple);
  start:=2*genus+1;
  ptuple:= ttuple{[start..Length(tuple)]};
  r:=PrepareMinTree(ptuple, group, Length(ptuple), genus);
  minTree:=r.MinimizationTree;
  minSet:=r.MinimumSet;
  mintup:=MinimizeTuple(tuple, minTree, minSet, 2*genus+Length(ptuple));
  return mintup;
end);


## Generates data for quick minimization
InstallGlobalFunction(GenerateMinData2, function(ccdata, mintree, minset, group)
  ## Data is a follows
  ## We have a level 
  ## we have an index which describe the index at which we are at
  ## for each minimum corresponding to element at index 2 in minset
  local i, indices, minptrs,c, mindata, id, rep, m , z, index, ccrev, rrev,
  count, o,g, orb, mins, level,l;
  mindata:=[[[]],[[]]];
  mindata:=List([1..Length(mintree)], 
            z -> List([1..Length(mintree[z])], 
            w -> []) );
  ccrev:=Reversed(ccdata.cc);
  rrev:=Reversed(ccdata.RR);

  for level in [1..Length(mintree)-1] do
    indices:=Set(List(minset[level], z -> z[2]));
    for index in  indices do
      # loop over all minimals for a fixed index
      mins:=Filtered(minset[level], z -> z[2] = index);
      for  l in [1..Length(mins)] do 
        m:=mins[l];
        g:=mintree[level][m[2]];
        orb:=Orbit(g, m[1]);
        for o in orb do
          rep:=RepresentativeAction( g, o, m[1]);
          mindata[level][index][IdElement(o, level, ccdata.base,
          rrev)]:=[rep,l];
        od;
      od;
    od;
  od;
  return mindata;
end);

## QuickMinimizeTuple
InstallGlobalFunction(QuickMinimizeTuple, function(tt, MinimizationTree,
  MinimumSet, NumberOfGenerators, mindata, ccdata) 
  local t,k,i,n,g,j,r,next,rep,pnt,min,mi,y,rr;

    t:=ShallowCopy(tt);
    t:=Reversed(t);
    next:=1;
    rr:=Reversed(ccdata.RR);

    #Print(NumberOfGenerators, "\n");
    for i in [1..NumberOfGenerators-1] do
         # Print("Step ", i , "\n");

        # Find the minima for this level
        mi:=StructuralCopy(MinimumSet[i]);
        mi:=Filtered(mi, y-> y[2]=next);

        # if the tree becomes trivial then break
        if Length(mi)=0 then
            break;
        fi;
        


        rep:= mindata[i][next][IdElement(t[i], i, ccdata.base,
              rr)];

        for j in [i..NumberOfGenerators] do
              t[j]:=t[j]^rep[1];
        od;
        next:= mi[mindata[i][next][IdElement(t[i], i, ccdata.base,
              rr)][2]][3];

        # for r in [1..Length(mi)] do
        #     min:=mi[r][1];
        #     Print("minimal element here is ", min, "\n");
        #     next:=mi[r][3];
        #     rep:= mindata[r][mi[r][2]][IdElement(t[i], r, ccdata.base,
        #           ccdata.RR)];
   #         Print("tuple after step ", i, " = ", Reversed(t), "\n");
            # break;
        # od;
        if next=0 then
            break;
        fi;
    od;
    t:=Reversed(t);
    t[1]:=Product(t{[2..Length(t)]})^(-1);

    #Print("Tuple Minimized\n");
    return t;
end);


