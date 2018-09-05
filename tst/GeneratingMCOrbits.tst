gap> START_TEST("MapClass package: GeneratingMCOrbits.tst");
gap> G:=SymmetricGroup(4);;
gap> orbs:=GeneratingMCOrbits(G,0,[(1,2),(1,2),(1,2),(1,2),(1,2),(1,2),(1,2)]:OutputStyle:="silent");;
gap> Length(orbs);
0
gap> orbs:=GeneratingMCOrbits(G,0,[(1,2),(1,2),(1,2),(1,2),(1,2),(1,2),(1,2),(1,2)]:OutputStyle:="silent");;
gap> Length(orbs);                                                     
1
gap> STOP_TEST( "GeneratingMCOrbits.tst" );
