#ifndef MK_LOG_CREATURE_VAR_H
#defsym MK_LOG_CREATURE_VAR_H

#include "log_creature_var_h"

void MK_LogCreatureVar(object oCreature)
{
    int nWidth = 8;
    int nDecimals = 4;
    //object oCreature = OBJECT_SELF;
    string sLogEntry;
    int i;

    int nSizeFloat  = StringToInt( MK_LogTableFloat(-1) );
    int nSizeInt    = StringToInt( MK_LogTableInt(-1) );
    int nSizeObject = StringToInt( MK_LogTableObject(-1) );
    int nSizeString = StringToInt( MK_LogTableString(-1) );


    sLogEntry = ";" + MK_LogCreatureId(oCreature);
    for(i=0; i < nSizeFloat; i++)
    {
        float fVar = GetLocalFloat(oCreature, MK_LogTableFloat(i) );
        sLogEntry = sLogEntry + FloatToString(fVar, nWidth, nDecimals) + ";" ;
    }
    for(i=0; i < nSizeInt; i++)
    {
        int nVar = GetLocalInt(oCreature, MK_LogTableInt(i));
        sLogEntry = sLogEntry + IntToString(nVar) + ";" ;
    }
    for(i=0; i < nSizeObject; i++)
    {
        object oVar = GetLocalObject(oCreature, MK_LogTableObject(i));
        sLogEntry = sLogEntry + ObjectToString(oVar) + ";" ;
    }
    for(i=0; i < nSizeString; i++)
    {
        string oVar = GetLocalString(oCreature, MK_LogTableString(i));
        sLogEntry = sLogEntry + oVar + ";" ;
    }

    PrintToLog(sLogEntry);
}

void MK_LogCreatureVarHeader()
{
    string sHeader;
    int i;

    int nSizeFloat  = StringToInt( MK_LogTableFloat(-1) );
    int nSizeInt    = StringToInt( MK_LogTableInt(-1) );
    int nSizeObject = StringToInt( MK_LogTableObject(-1) );
    int nSizeString = StringToInt( MK_LogTableString(-1) );


    sHeader = ";NAME;ID;" ;
    for(i=0; i < nSizeFloat; i++)
        sHeader = sHeader + MK_LogTableFloat(i) + ";" ;
    for(i=0; i < nSizeInt; i++)
        sHeader = sHeader + MK_LogTableInt(i) + ";" ;
    for(i=0; i < nSizeObject; i++)
        sHeader = sHeader + MK_LogTableObject(i) + ";" ;
    for(i=0; i < nSizeString; i++)
        sHeader = sHeader + MK_LogTableString(i) + ";" ;

    //sHeader = sHeader + MK_LogCreatureVarTitle();
    PrintToLog(sHeader);

}

#endif