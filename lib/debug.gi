# These programs classify the Hurwitz loci of low genus
# for groups from Breuer's list
#
# (C) 2004 by K. Magaard, S. Shpectorov and H. Voelklein


#
# a debugging tool
#

Wait:=function(pppp)

local iiii,jjjj;
Print("Wait: ",pppp,"\n");
for iiii in [1..70000000] do
jjjj:=iiii;
od;
end;

#
# error print
#

ErrorPrint:=function(nnnn,pppp)

 PrintTo(nnnn,pppp);

end;


# End
