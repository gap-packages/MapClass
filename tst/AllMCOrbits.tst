gap> START_TEST("MapClass package: AllMCOrbits.tst");
gap> G:=SymmetricGroup(4);;
gap> orbs:=AllMCOrbits(G,1,[(1,2,3)]:OutputStyle:="silent");;
gap> Length(orbs);
2
gap> Set(List(orbs,o->Length(o.TupleTable)));
[ 3, 9 ]
gap> STOP_TEST( "AllMCOrbits.tst" );
