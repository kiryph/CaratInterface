#############################################################################
##
#W  fix4b5.gi              Interface to Carat                   Franz G"ahler
##
#Y  Copyright (C) 1999,      Franz G"ahler,        ITAP, Stuttgart University
##
##  Contains methods that were missing in the beta release 5 fix 4 of GAP 4
##

#############################################################################
##
#M  IsBravaisGroupOnRight( <G> ) . . . . . . . . . . . .IsBravaisGroupOnRight
##
InstallMethod( IsBravaisGroupOnRight, 
    true, [ IsCyclotomicMatrixGroup ], 0,
function( G )
    return G = BravaisGroupOnRight( G );
end );

#############################################################################
##
#M  IsBravaisGroupOnLeft( <G> ) . . . . . . . . . . . . .IsBravaisGroupOnLeft
##
InstallMethod( IsBravaisGroupOnLeft, 
    true, [ IsCyclotomicMatrixGroup ], 0,
function( G )
    return G = BravaisGroupOnLeft( G );
end );

