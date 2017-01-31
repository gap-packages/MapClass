# This file is part of the GAP package MAPCLASS
# This file contains a system of GAP programs motivated by Staszewski and Voelklein
# to compute the number of generating tuples
# 
#  A.James, K. Magaard, and S.Shpectorov 2011


#
# NumberGeneratingTuples
# general function computing the number of generating tuples
#
InstallGlobalFunction(NumberGeneratingTuples,function(group,p,t,g)
  local tp,i,full,sz,cc,oc,ct,str,StepDown;
  tp:=[];
  for i in [1..Length(p)] do
   Append(tp,List([1..p[i]],c->i));
  od;
  
  full:=[];
  sz:=Size(group);
  cc:=ConjugacyClasses(group);
  oc:=List(t,s->Filtered([1..Length(cc)],i->s in cc[i]));
   
  ct:=CharacterTable(group);     
  str:=TotalNumberOfTuples(ct,g,List(oc,c->c[1]));
 
  Add(full,rec(gp:=group,sz:=sz,cc:=cc,oc:=oc,str:=str,pr:=0,nx:=0));
  
## RECURSIVE FUNCTION STARTS HERE 
  StepDown:=function(no)
    local gp,cc,oc,ms,m,sz,p,pp,fl,mcc,moc,ct,str,t,i;
    gp:=full[no].gp;
    cc:=full[no].cc;
    oc:=full[no].oc;

    ms:=MaximalSubgroupClassReps(gp); 
    for m in ms do
      sz:=Size(m);
      p:=no;
      pp:=full[no].pr;
      fl:=false;

## Find the next subgroup
      while full[p].sz>=sz do
        if full[p].sz=sz then
          if IsConjugate(group,full[p].gp,m) then
            fl:=true;
            break;
          fi;
        fi;
        pp:=p;
        p:=full[p].nx;
        if p=0 then
          break;
        fi;
      od;
      if not fl then 
        mcc:=ConjugacyClasses(m);
        moc:=List(oc,s-> Union(List(s, n-> Filtered([1..Length(mcc)],i ->
              Representative(mcc[i]) in cc[n]))));
        if not ([] in moc) then
          ct:=CharacterTable(m);     
          str:=0;
          t:=List(tp,c->1);
          repeat
            str:=str+TotalNumberOfTuples(ct, g,
                  List([1..Length(t)],i->moc[i][t[i]]));
            i:=1;
            while i<=Length(tp) do
              if t[i]<>Length(moc[i]) then
                t[i]:=t[i]+1;
                break;
              else
                t[i]:=1;
                i:=i+1;
              fi;
            od;
          until i>Length(tp);
          Add(full,rec(gp:=m,sz:=sz,cc:=mcc,oc:=moc,str:=str,pr:=pp,nx:=p));
          if pp<>0 then
            full[pp].nx:=Length(full);
          fi;
          if p<>0 then
            full[p].pr:=Length(full);
          fi;
          StepDown(Length(full));  
        fi;
      fi;
    od;

    str:=full[no].str;
    p:=full[no].nx;
    while p<>0 do
      if (full[no].sz mod full[p].sz)=0 then
        ## If is a p-group then try something else because Isomorphic subgroups
        ## sloooow
        if IsPGroup(gp) then
          ms:=IsomorphicSubgroups(gp,full[p].gp);
          for m in ms do
            m:=Image(m);
            if IsConjugate(group,m,full[p].gp) then
              str:=str-full[p].str*Index(gp,Normalizer(gp,m));
            fi;
          od;
        else
          ms:=IsomorphicSubgroups(gp,full[p].gp);
          for m in ms do
            m:=Image(m);
            if IsConjugate(group,m,full[p].gp) then
              str:=str-full[p].str*Index(gp,Normalizer(gp,m));
            fi;
          od;
        fi;
      fi;
      p:=full[p].nx;
    od;
    full[no].str:=str;
  end;
## END OF RECURSIVE FUNCTION 

  StepDown(Length(full));  
  return full[1].str;  
end);


# End
