#include <stdio.h>
#include <stdlib.h>
#include "src/compiled.h"
   
Obj FuncSET_CARAT_DIR( Obj self, Obj str ) {
  setenv("CARAT_DIR", CSTR_STRING(str), 1);
  return (Obj) 0; 
  }

static StructGVarFunc GVarFuncs [] = {

{ "SET_CARAT_DIR", 1, "str", FuncSET_CARAT_DIR, "src/setcaratdir.c:FuncSET_CARAT_DIR" },

};


/**************************************************************************

*F  InitKernel( <module> )  . . . . . . . . initialise kernel data structures
*/
static Int InitKernel (
    StructInitInfo *    module )
{

    /* init filters and functions                                          */
    InitHdlrFuncsFromTable( GVarFuncs );

    /* return success                                                      */
    return 0;
}


/****************************************************************************
**
*F  InitLibrary( <module> ) . . . . . . .  initialise library data structures
*/
static Int InitLibrary (
    StructInitInfo *    module )
{
  /*    UInt            gvar;
	Obj             tmp; */

    /* init filters and functions                                          */
    /* printf("Init El..Small\n");fflush(stdout); */
    InitGVarFuncsFromTable( GVarFuncs );

    /* return success                                                      */
    return 0;
}


/****************************************************************************
**
*F  InitInfopl()  . . . . . . . . . . . . . . . . . table of init functions
*/
/* <name> returns the description of this module */
static StructInitInfo module = {
#ifdef EDIVSTATIC
    .type = MODULE_STATIC,
#else
    .type = MODULE_DYNAMIC,
#endif
    .name = "set_carat_dir",
    .initKernel = InitKernel,
    .initLibrary = InitLibrary,
};

#ifndef EDIVSTATIC
StructInitInfo * Init__Dynamic ( void )
{
 return &module;
}
#endif

StructInitInfo * Init__ediv ( void )
{
  return &module;
}
