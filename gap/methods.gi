#############################################################################
##
#W  methods.gi             Interface to Carat                   Franz G"ahler
##
#Y  Copyright (C) 1999,      Franz G"ahler,        ITAP, Stuttgart University
##
##  Methods for high level functions using Carat
##

#############################################################################
##
#F  BravaisGroupFun( grp, act ) . . . . . . . . . . . . .Bravais group of grp
##
BravaisGroupFun := function( grp, act )

    local grpfile, resfile, gen, data, res;

    # group must be integer and finite
    if not IsIntegerMatrixGroup( grp ) then
        Error( "grp must be an integer matrix group" );
    fi;
    if not IsFinite( grp ) then
        Error( "grp must be finite" );
    fi;

    # get temporary file names
    grpfile := CaratTmpFile( "grp" );  
    resfile := CaratTmpFile( "res" );

    # write Carat input to temporary file
    gen := GeneratorsOfGroup( grp );
    if gen = [] then
        gen := [ One(grp) ];
    fi;
    if act = RightAction then
        gen := List( gen, TransposedMat );
    fi;
    data := rec( generators := gen, size := Size( grp ) );
    CaratWriteBravaisFile( grpfile, data );

    # execute Carat program
    CaratCommand( "Bravais_grp", grpfile, resfile );

    # read back result, and remove temporary files
    data := CaratReadBravaisFile( resfile );
    RemoveFile( grpfile );
    RemoveFile( resfile );

    # convert result to appropriate format
    if act = RightAction then
        data.generators := List( data.generators, TransposedMat );
    fi;
    res := GroupByGenerators( data.generators, One( grp ) );
    if IsBound( data.size ) then
        SetSize( res, data.size );
    fi;
    return res;

end;


#############################################################################
##
#M  BravaisGroupOnRight( grp ) . . . . . . . . . . right Bravais group of grp
##
InstallMethod( BravaisGroupOnRight, 
    "with Carat function Bravais_grp",
    true, [ IsCyclotomicMatrixGroup ], 0,
    grp -> BravaisGroupFun( grp, RightAction )
);


#############################################################################
##
#M  BravaisGroupOnLeft( grp ) . . . . . . . . . . . left Bravais group of grp
##
InstallMethod( BravaisGroupOnLeft, 
    "with Carat function Bravais_grp",
    true, [ IsCyclotomicMatrixGroup ], 0,
    grp -> BravaisGroupFun( grp, LeftAction )
);


#############################################################################
##
#F  CaratBravaisInclusions( grp, opt, act ) . . Bravais inclusions (internal)
##
CaratBravaisInclusions := function( grp, opt, act )

    local grpfile, resfile, gen, data, args, output, res, g;

    # get temporary file names
    grpfile := CaratTmpFile( "grp" );  
    resfile := CaratTmpFile( "res" );

    # write Carat input to file
    gen := GeneratorsOfGroup( grp );
    if gen = [] then
        gen := [ One(grp) ];
    fi;
    if act = RightAction then
        gen := List( gen, TransposedMat );
    fi;
    data := rec( generators := gen, size := Size( grp ) );
    CaratWriteBravaisFile( grpfile, data );

    # execute Carat program
    args := Concatenation( grpfile, " -G", opt );
    CaratCommand( "Bravais_inclusions", args, resfile );

    # read Carat result from file, and remove temporary files
    data := CaratReadBravaisInclusionsFile( resfile );
    RemoveFile( grpfile );
    RemoveFile( resfile );

    # convert result into desired format
    if act = RightAction then
        for g in data do
            g.generators := List( g.generators, TransposedMat );
        od;
    fi;
    res := List( data, x -> GroupByGenerators( x.generators, One(grp) ) );
    for g in res do
        SetSize( g, data[1].size );
    od;

    return res;

end;


#############################################################################
##
#M  BravaisSubgroupsOnRight( grp ) . . . . . . . . right Bravais subgroups of 
#M                                                 right Bravais group of grp
##
InstallMethod( BravaisSubgroupsOnRight, 
    "with Carat function Bravais_inclusions",
    true, [ IsCyclotomicMatrixGroup ], 0,
function( grp )
    if DimensionOfMatrixGroup( grp ) > 6 then
        Error( "sorry, only groups of dimension up to 6 are supported" );
    fi;
    return CaratBravaisInclusions( 
           BravaisGroupOnRight( grp ), "", RightAction );
end );


#############################################################################
##
#M  BravaisSubgroupsOnLeft( grp ) . . . . . . . . . left Bravais subgroups of 
#M                                                  left Bravais group of grp
##
InstallMethod( BravaisSubgroupsOnLeft, 
    "with Carat function Bravais_inclusions",
    true, [ IsCyclotomicMatrixGroup ], 0,
function( grp )
    if DimensionOfMatrixGroup( grp ) > 6 then
        Error( "sorry, only groups of dimension up to 6 are supported" );
    fi;
    return CaratBravaisInclusions( 
           BravaisGroupOnLeft( grp ), "", LeftAction );
end );


#############################################################################
##
#M  BravaisSupergroupsOnRight( grp ) . . . . . . right Bravais supergroups of 
#M                                                 right Bravais group of grp
##
InstallMethod( BravaisSupergroupsOnRight, 
    "with Carat function Bravais_inclusions",
    true, [ IsCyclotomicMatrixGroup ], 0,
function( grp )
    if DimensionOfMatrixGroup( grp ) > 6 then
        Error( "sorry, only groups of dimension up to 6 are supported" );
    fi;
    return CaratBravaisInclusions( 
           BravaisGroupOnRight( grp ), " -S", RightAction );
end );


#############################################################################
##
#M  BravaisSupergroupsOnLeft( grp ) . . . . . . . left Bravais supergroups of 
#M                                                  left Bravais group of grp
##
InstallMethod( BravaisSupergroupsOnLeft, 
    "with Carat function Bravais_inclusions",
    true, [ IsCyclotomicMatrixGroup ], 0,
function( grp )
    if DimensionOfMatrixGroup( grp ) > 6 then
        Error( "sorry, only groups of dimension up to 6 are supported" );
    fi;
    return CaratBravaisInclusions( 
           BravaisGroupOnLeft( grp ), " -S", LeftAction );
end );


#############################################################################
##
#F  CaratNormalizerInGLnZFunc( G, opt, act ) . . . . . .Normalizer of integer
#F                                                    matrix group in GL(n,Z)
##
CaratNormalizerInGLnZFunc := function( grp, opt, act )

    local grpfile, resfile, gen, data, output, res, args;

    # group must be integer and finite
    if not IsIntegerMatrixGroup( grp ) then
        Error( "grp must be an integer matrix group" );
    fi;
    if not IsFinite( grp ) then
        Error( "grp must be finite" );
    fi;

    # get temporary files
    grpfile := CaratTmpFile( "grp" );  
    resfile := CaratTmpFile( "res" );

    # write input data
    gen := GeneratorsOfGroup(grp);
    if gen = [] then
        gen := [ One(grp) ];
    fi;
    data := rec( generators := gen, size := Size( grp ) );
    if opt = "-b" and act = RightAction then
        data.generators := List( data.generators, TransposedMat );
    fi;
    CaratWriteBravaisFile( grpfile, data );

    # execute Carat command
    args    := Concatenation( grpfile, opt );
    CaratCommand( "Normalizer", args, resfile );

    # read back the data
    data := CaratReadBravaisFile( resfile );
    RemoveFile( grpfile );
    RemoveFile( resfile );

    # construct result
    if opt = "-b" and act = RightAction then
        data.generators := List( data.generators, TransposedMat );
        data.normalizer := List( data.normalizer, TransposedMat );
    fi;
    gen := Concatenation( data.generators, data.normalizer );
    res := GroupByGenerators( gen, One( grp ) );

    return res;

end;


#############################################################################
##
#M  NormalizerInGLnZ( G ) . . . Normalizer of integer matrix group in GL(n,Z)
##
InstallMethod( NormalizerInGLnZ, "with Carat function Normalizer",
    true, [ IsCyclotomicMatrixGroup ], 0, 
    G -> CaratNormalizerInGLnZFunc( G, "", LeftAction ) );

InstallMethod( NormalizerInGLnZ, "with Carat function Normalizer",
    true, [ IsBravaisGroupOnRight ], 0, BravaisNormalizerInGLnZOnRight );

InstallMethod( NormalizerInGLnZ, "with Carat function Normalizer",
    true, [ IsBravaisGroupOnLeft ], 0, BravaisNormalizerInGLnZOnLeft );

InstallMethod( NormalizerInGLnZ, "via Bravais group", 
    true, [ IsIntegerMatrixGroup and HasBravaisGroupOnLeft ], 0,
function( G )
    local B, N;
    N := NormalizerInGLnZ( BravaisGroupOnLeft( G ) );
    if IsFinite( N ) then
        return Stabilizer( N, G, OnPoints );
    else
        return CaratStabilizerInfiniteGroup( N, G, OnPoints );
    fi;
end );

InstallMethod( NormalizerInGLnZ, "via Bravais group", 
    true, [ IsIntegerMatrixGroup and HasBravaisGroupOnRight ], 0,
function( G )
    local B, N;
    N := NormalizerInGLnZ( BravaisGroupOnRight( G ) );
    if IsFinite( N ) then
        return Stabilizer( N, G, OnPoints );
    else
        return CaratStabilizerInfiniteGroup( N, G, OnPoints );
    fi;
end );


#############################################################################
##
#M  BravaisNormalizerInGLnZOnRight( G ) . . . . . Normalizer of right Bravais
#M                                                      group of G in GL(n,Z)
##
InstallMethod( BravaisNormalizerInGLnZOnRight, 
    "with Carat function Normalizer",
    true, [ IsCyclotomicMatrixGroup ], 0, 
function(G)
    local N;
    N := CaratNormalizerInGLnZFunc( G, " -b", RightAction );
    if HasBravaisGroupOnRight( G ) then
        SetNormalizerInGLnZ( BravaisGroupOnRight( G ), N );
    fi;
    return N;
end );


#############################################################################
##
#M  BravaisNormalizerInGLnZOnLeft( G ) . . . . . . Normalizer of left Bravais
#M                                                      group of G in GL(n,Z)
##
InstallMethod( BravaisNormalizerInGLnZOnLeft, 
    "with Carat function Normalizer",
    true, [ IsCyclotomicMatrixGroup ], 0, 
function(G)
    local N;
    N := CaratNormalizerInGLnZFunc( G, " -b", LeftAction );
    if HasBravaisGroupOnLeft( G ) then
        SetNormalizerInGLnZ( BravaisGroupOnLeft( G ), N );
    fi;
    return N;
end );


#############################################################################
##
#M  CentralizerInGLnZ( G ) . . . . . . . . . . . . . . Centralizer in GL(n,Z)
##
InstallMethod( CentralizerInGLnZ, "via NormalizerInGLnZ", 
    true, [ IsCyclotomicMatrixGroup ], 0,
function( G )
    local N, gens;
    if HasBravaisGroupOnLeft( G ) and not HasNormalizerInGLnZ( G ) then
        N := NormalizerInGLnZ( BravaisGroupOnLeft( G ) );
    elif HasBravaisGroupOnRight( G ) and not HasNormalizerInGLnZ( G ) then
        N := NormalizerInGLnZ( BravaisGroupOnRight( G ) );
    else
        N := NormalizerInGLnZ( G );
    fi;
    gens := GeneratorsOfGroup( G );
    if IsFinite( N ) then
        return Centralizer( N, G );
    else
        return CaratStabilizerInfiniteGroup( N, gens, OnTuples );
    fi;
end );


#############################################################################
##
#M  RepresentativeOperation( GL( n, Integers), G1, G2 ) . . . . .
#M                                    return m in GL(n,Z) with m*G1*m^-1 = G2
#T  perhaps it should be the other way around!
##
InstallOtherMethod( RepresentativeOperationOp, 
    "with Carat function Z_equiv", true, 
    [ IsNaturalGLnZ, IsCyclotomicMatrixGroup, IsCyclotomicMatrixGroup,
      IsFunction ], 0,

function( glnz, grp1, grp2, opr )

    local grp1file, grp2file, resfile, args, gen, data, input, line, res;

    # groups must be integer
    if not IsIntegerMatrixGroup( grp1 ) then
        Error( "grp1 must be an integer matrix group" );
    fi;
    if not IsIntegerMatrixGroup( grp2 ) then
        Error( "grp2 must be an integer matrix group" );
    fi;

    # groups must be finite
    if not IsFinite( grp1 ) then
        Error( "grp1 must be finite" );
    fi;
    if not IsFinite( grp2 ) then
        Error( "grp2 must be finite" );
    fi;

    # catch the trivial case
    if grp1 = grp2 then
        return IdentityMat( DimensionOfMatrixGroup( grp1 ) );
    fi;

    # get temporary file names
    grp1file := CaratTmpFile( "grp1" );  
    grp2file := CaratTmpFile( "grp2" );
    resfile  := CaratTmpFile( "res"  );

    # write Carat input to temporary files
    gen := GeneratorsOfGroup( grp1 );
    if gen = [] then
        gen := [ One(grp1) ];
    fi;
    data := rec( generators := gen, size := Size(grp1) );
    CaratWriteBravaisFile( grp1file, data );

    gen := GeneratorsOfGroup( grp2 );
    if gen = [] then
        gen := [ One(grp2) ];
    fi;
    data := rec( generators := gen, size := Size(grp2) );
    CaratWriteBravaisFile( grp2file, data );

    # execute Carat program
    args := Concatenation( grp2file, " ", grp1file );
    CaratCommand( "Z_equiv", args, resfile );

    # read back the result
    input := InputTextFile( resfile );
    line := CaratReadLine( input );
    if line = "the groups are not conjugated in GL_n(Z)\n" then
        res := fail;
    else
        res := CaratReadMatrix( input, line );        
    fi;
    CloseStream( input );

    # remove temporary files
    RemoveFile( grp1file );
    RemoveFile( grp2file );
    RemoveFile( resfile );

    return res;

end );


#############################################################################
##
#M  ZClassRepsQClass( grp )  . . . . . . . . . Z-class reps in Q-class of grp
##
InstallMethod( ZClassRepsQClass, "with Carat function QtoZ",
    true, [ IsCyclotomicMatrixGroup ], 0,

function( grp )

    local grpfile, resfile, gen, data, output, res, g;

    # group must be rational and finite
    if not IsRationalMatrixGroup( grp ) then
        Error( "grp must be a rational matrix group" );
    fi;
    if not IsFinite( grp ) then
        Error( "grp must be finite" );
    fi;

    # get temporary file names
    grpfile := CaratTmpFile( "grp" );  
    resfile := CaratTmpFile( "res" );

    # write Carat input to file
    gen := GeneratorsOfGroup( grp );
    if gen = [] then
        gen := [ One(grp) ];
    fi;
    data := rec( generators := gen, size := Size(grp) );
    CaratWriteBravaisFile( grpfile, data );

    # execute Carat program
    CaratCommand( "QtoZ", grpfile, resfile );

    # read Carat result from file, and remove temporary files
    data := CaratReadQtoZFile( resfile );
    RemoveFile( grpfile );
    RemoveFile( resfile );

    # convert result into desired format
    res := List( data, x -> GroupByGenerators( x.generators ) );
    for g in res do
        SetSize( g, data[1].size );
    od;

    return res;

end ); 


