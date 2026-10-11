gap> START_TEST("MapClass package: ClassOrder.tst");

# A character table may list the conjugacy classes in another order than
# its group does. Here the group and each subgroup returned by
# MaximalSubgroupClassReps store the identity class last, whereas a character
# table has it first.
gap> IdLast:=function(G)
>   local reps,H;
>   reps:=List(ConjugacyClasses(G),Representative);
>   reps:=Concatenation(reps{[2..Length(reps)]},reps{[1]});
>   H:=GroupWithGenerators(GeneratorsOfGroup(G),One(G));
>   SetConjugacyClasses(H,List(reps,x->ConjugacyClass(H,x)));
>   SetMaximalSubgroupClassReps(H,List(MaximalSubgroupClassReps(G),IdLast));
>   return H;
> end;;
gap> G:=IdLast(SymmetricGroup(4));;
gap> ForAll(Concatenation([G],MaximalSubgroupClassReps(G)),
>      H->IdentificationOfConjugacyClasses(CharacterTable(H))
>         <>[1..NrConjugacyClasses(H)]);
true
gap> t7:=ListWithIdenticalEntries(7,(1,2));;
gap> t8:=ListWithIdenticalEntries(8,(1,2));;
gap> NumberGeneratingTuples(G,[7],t7,0);
0
gap> NumberGeneratingTuples(G,[8],t8,0);
131040
gap> NumberGeneratingTuples(G,[2,2],[(1,2),(1,2),(1,2,3),(1,2,3)],0);
144
gap> NumberGeneratingTuples(G,[1],[(1,2,3)],1);
216
gap> orbs:=GeneratingMCOrbits(G,0,t7:OutputStyle:="silent");;
gap> Length(orbs);
0
gap> orbs:=GeneratingMCOrbits(G,0,[(1,2),(1,2),(1,2,3),(1,2,3)]:
>      OutputStyle:="silent");;
gap> List(orbs,o->Length(o.TupleTable));
[ 6 ]
gap> STOP_TEST( "ClassOrder.tst" );
