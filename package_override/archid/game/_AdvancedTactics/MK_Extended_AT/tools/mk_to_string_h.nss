#ifndef MK_TO_STRING_H
#defsym MK_TO_STRING_H

//******************************************************************************
//                                INCLUDES
//******************************************************************************
#include "2da_constants_h"
#include "ai_constants_h"    
#include "mk_constants_h"

//******************************************************************************
//                                DECLARATIONS
//******************************************************************************
string MkResultToString(int MK_RESULT);
string BoolToString(int nBool);
string ObjectToStringName(object oObject);
string ObjectToStringNameAndId(object oObject);
string LabelFrom2DA(int nID, int n2DA);
string StrRefFrom2DA(int nID, int n2DA);
string BaseConditionIdToString(int nBaseConditionId);
string SubConditionIdToString(int nSubConditionId);
string TargetTypeIdToString(int nTargetTypeId);
string CommandTypeIdToString(int nCommandTypeId);
string AbilityIdToString(int nAbilityId);
string ArStringToCsv(string[] arString);
void MK_Print2DA(int n2DA, string s2DA = "");

//******************************************************************************
//                               DEFINITIONS
//******************************************************************************  

//==============================================================================
string MkResultToString(int MK_RESULT)
{
    switch (MK_RESULT)
    {
        case MK_SUCCESS:
            return "MK_SUCCESS";
        case MK_FAILURE:
            return "MK_FAILURE";
        case MK_UNPROCESSED:
            return "MK_UNPROCESSED";
    }
    return "MK_RESULT_UNKNOWN";
}

//==============================================================================
string BoolToString(int nBool)
{
    if (nBool == 0)
        return "FALSE";
    else
        return "TRUE";
}

//==============================================================================
string ObjectToStringName(object oObject)
{
    if (oObject == OBJECT_INVALID)
        return "OBJECT_INVALID";

    int nNameStrref = GetNameStrref(oObject);
    return GetTlkTableString(nNameStrref);
}

//==============================================================================
string ObjectToStringNameAndId(object oObject)
{
    return ObjectToStringName(oObject) + " (" + ObjectToString(oObject) +")";
}

//==============================================================================
string LabelFrom2DA(int nID, int n2DA)
{
    return GetM2DAString(n2DA, "Label", nID);
}

//==============================================================================
string StrRefFrom2DA(int nID, int n2DA)
{
    int nStrRef = GetM2DAInt(n2DA, "StrRef", nID);
    return GetTlkTableString(nStrRef);
}

//==============================================================================
string BaseConditionIdToString(int nBaseConditionId)
{
    return StrRefFrom2DA(nBaseConditionId, TABLE_TACTICS_BASE_CONDITIONS);
}

//==============================================================================
string SubConditionIdToString(int nSubConditionId)
{
    return StrRefFrom2DA(nSubConditionId, TABLE_TACTICS_CONDITIONS);
}

//==============================================================================
string TargetTypeIdToString(int nTargetTypeId)
{
    return StrRefFrom2DA(nTargetTypeId, TABLE_AI_TACTICS_TARGET_TYPE);
}

//==============================================================================
string CommandTypeIdToString(int nCommandTypeId)
{
    return StrRefFrom2DA(nCommandTypeId, TABLE_COMMAND_TYPES);
}

//==============================================================================
string AbilityIdToString(int nAbilityId)
{
    return StrRefFrom2DA(nAbilityId, TABLE_ABILITIES_TALENTS); // TABLE_ABILITIES_TALENTS == TABLE_ABILITIES_SPELLS
}

//==============================================================================
string ArStringToCsv(string[] arString)
{
    string sCsv = "";

    int i;
    int nSize = GetArraySize(arString);
    for (i = 0; i < nSize; i++)
        sCsv += ", " + arString[i];

    return sCsv;
}

//==============================================================================
void MK_Print2DA(int n2DA, string s2DA = "")
{
    string sHeader = ", n2DA, nIndex, nId, sLabel, nStrRef, sName";
    PrintToLog("");
    PrintToLog(sHeader);

    string s2DA_ID = IntToString(n2DA);

    int nRowIndex;
    int nRows = GetM2DARows(n2DA, s2DA);

    for (nRowIndex = 0; nRowIndex < nRows; nRowIndex++)
    {
        int nRowId = GetM2DARowIdFromRowIndex(n2DA, nRowIndex, s2DA);
        int nStrRef = GetM2DAInt(n2DA, "StrRef", nRowId, s2DA);

        string[] arString;
        int nColNum = 0;

        arString[nColNum++] = s2DA_ID;
        arString[nColNum++] = IntToString(nRowIndex);
        arString[nColNum++] = IntToString(nRowId);
        arString[nColNum++] = GetM2DAString(n2DA, "Label", nRowId, s2DA);
        arString[nColNum++] = IntToString(nStrRef);
        arString[nColNum++] = GetTlkTableString(nStrRef);
        PrintToLog(ArStringToCsv(arString));
    }
}

/*
//==============================================================================
void main()
{
    int nRows = GetM2DARows(TABLE_COMMANDS);
    int i;
    for (i = 0; i <= nRows; i++)
    {
        string sId = IntToString(GetM2DARowIdFromRowIndex(TABLE_COMMAND_TYPES, i));
        int nStrRef = GetM2DAInt(TABLE_COMMAND_TYPES, "StrRef", i);
        string sName= GetTlkTableString(nStrRef);
        PrintToLog(sId + " : " + sName);
    }
}
*/
#endif