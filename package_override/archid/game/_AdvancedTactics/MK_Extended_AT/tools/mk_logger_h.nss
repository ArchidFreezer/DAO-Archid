#ifndef MK_LOGGER_H
#defsym MK_LOGGER_H

#defsym MK_CALL_STACK_TRACE

#include "mk_print_to_log_h"

const int MK_LOG_LEVEL_FATAL        = 0;
const int MK_LOG_LEVEL_ERROR        = 1;
const int MK_LOG_LEVEL_WARNIG       = 2;
const int MK_LOG_LEVEL_INFORMATION  = 3;
const int MK_LOG_LEVEL_DEBUG        = 4;

const string MK_STACK_TRACE_SEPARATOR = ";";

//AI_CUSTOM_AI_VAR_STRING
//GetLocalInt(oCreature, "AI_CUSTOM_AI_VAR_INT");
//SetLocalInt(oCreature, "AI_CUSTOM_AI_VAR_INT", nBitVar);

//******************************************************************************
void MK_PushToCallStackTrace(string functionName)
{
    #ifdef MK_CALL_STACK_TRACE
    string sStackTrace = GetLocalString(OBJECT_SELF, "AI_CUSTOM_AI_VAR_STRING");
    sStackTrace = functionName + MK_STACK_TRACE_SEPARATOR + sStackTrace;;
    SetLocalString(OBJECT_SELF, "AI_CUSTOM_AI_VAR_STRING", sStackTrace);
    #endif
}

//******************************************************************************
void MK_RemoveLastFromCallStackTrace()
{
    #ifdef MK_CALL_STACK_TRACE
    string sStackTrace = GetLocalString(OBJECT_SELF, "AI_CUSTOM_AI_VAR_STRING");
    int index = FindSubString(sStackTrace, MK_STACK_TRACE_SEPARATOR);    
    sStackTrace = StringRight(sStackTrace, GetStringLength(sStackTrace) - (index+1));       
    SetLocalString(OBJECT_SELF, "AI_CUSTOM_AI_VAR_STRING", sStackTrace);
    #endif    
}

//******************************************************************************
string MK_GetCallStackTrace() 
{
    return GetLocalString(OBJECT_SELF, "AI_CUSTOM_AI_VAR_STRING");
}

//******************************************************************************
void MK_Logger(string sMsg, int nLogLevel)
{
    if (nLogLevel == MK_LOG_LEVEL_FATAL || nLogLevel == MK_LOG_LEVEL_ERROR)
    {
        sMsg = "[ERROR] " + sMsg;
        DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, 0xFF0000, 5.0);
    }
    MK_PrintToLog("===========================================================");
    MK_PrintToLog(sMsg);     
    MK_PrintToLog(MK_GetCallStackTrace());    
}

/*
void main()
{   
    MK_PushToCallStackTrace("");
    MK_RemoveLastFromCallStackTrace();
    MK_Logger("main", 0);
}
*/
#endif