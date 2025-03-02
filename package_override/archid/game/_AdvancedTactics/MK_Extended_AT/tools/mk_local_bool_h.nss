#ifndef MK_AI_LOCAL_BOOL_H
#defsym MK_AI_LOCAL_BOOL_H

//==============================================================================
//                              INCLUDES
//==============================================================================
#include "mk_test_framework_h"

//==============================================================================
//                              CONSTANTS
//==============================================================================

//-------- Followers
//const int LOCAL_INT_BITSHIFT_POSSESSED
//const int LOCAL_INT_BITSHIFT_TRAITOR
const int LOCAL_INT_BITSHIFT_BOOLEAN_1 = 2;
const int LOCAL_INT_BITSHIFT_BOOLEAN_2 = 3;

//-------- Enemies
/*
8 bits are reserved for Improved Ranged Combat (4 followers + 4 summoned)
*/

//==============================================================================
//                          DEFINITIONS
//============================================================================== 
//******************************************************************************
int MK_AI_GetLocalBool(int nBitShift, object oCreature)
{
    int nBitVar = GetLocalInt(oCreature, "AI_CUSTOM_AI_VAR_INT");
    int nBool = nBitVar & (1 << nBitShift);
    return nBool != 0;
}

//******************************************************************************
void MK_AI_SetLocalBool(int nBitShift, int nBool, object oCreature = OBJECT_SELF)
{
    int nBitVar = GetLocalInt(oCreature, "AI_CUSTOM_AI_VAR_INT");
    if (nBool != FALSE)
        nBitVar |= (1 << nBitShift);
    else
        nBitVar &= ~(1 << nBitShift);
    SetLocalInt(oCreature, "AI_CUSTOM_AI_VAR_INT", nBitVar);
}

//==============================================================================
//                            UNIT TESTS
//==============================================================================
//******************************************************************************
int SmokeTest_Int2Bool(int nBool)
{
    MK_PrintToLog("==== SmokeTest_Int2Bool ====");

    if (nBool == TRUE)
    {
        MK_PrintToLog("nBool = " + IntToString(nBool) + " is TRUE");
        if (nBool != 0)
        {
            MK_PrintToLog("SUCCESS");
            return TRUE;
        }
        else
        {
            MK_PrintToLog("FAILURE");
            return FALSE;
        }
    }
    else
    {
        MK_PrintToLog("nBool = " + IntToString(nBool) + " is FALSE");
        return AssertInt(nBool, 0);
    }
}

//******************************************************************************
int SmokeTest_LocalInt(int nSetValue)
{
    MK_PrintToLog("==== SmokeTest_GetLocalInt ====");

    int nOldLocalInt = GetLocalInt(OBJECT_SELF, "AI_CUSTOM_AI_VAR_INT");
    MK_PrintToLog("nOldLocalInt = " + IntToString(nOldLocalInt));

    SetLocalInt(OBJECT_SELF, "AI_CUSTOM_AI_VAR_INT", nSetValue);
    int nNewLocalInt = GetLocalInt(OBJECT_SELF, "AI_CUSTOM_AI_VAR_INT");
    MK_PrintToLog("nSetValue = " + IntToString(nSetValue));
    MK_PrintToLog("nNewLocalInt = " + IntToString(nNewLocalInt));

    return AssertInt(nNewLocalInt, nSetValue);
}

//******************************************************************************
int UnitTest_GetLocalBool(int nBitShift, int nSetValue)
{
    MK_PrintToLog("==== UnitTest_GetLocalBool ====");

    SetLocalInt(OBJECT_SELF, "AI_CUSTOM_AI_VAR_INT", nSetValue);
    int nNewLocalBool = MK_AI_GetLocalBool(nBitShift, OBJECT_SELF);
    int nMaskedSetValue = nSetValue & (1 << nBitShift);

    MK_PrintToLog("nBitShift = " + IntToString(nBitShift));
    MK_PrintToLog("nSetValue = " + IntToString(nSetValue));
    MK_PrintToLog("nMaskedSetValue = " + IntToString(nMaskedSetValue));
    MK_PrintToLog("nNewLocalBool = " + IntToString(nNewLocalBool));

    return AssertInt(nNewLocalBool, nMaskedSetValue);
}

//******************************************************************************
int UnitTest_SetLocalBool(int nBitShift, int nBool, int nSetValue)
{
    MK_PrintToLog("==== UnitTest_SetLocalBool ====");

    SetLocalInt(OBJECT_SELF, "AI_CUSTOM_AI_VAR_INT", nSetValue);
    MK_AI_SetLocalBool(nBitShift, nBool);
    int nNewLocalInt = GetLocalInt(OBJECT_SELF, "AI_CUSTOM_AI_VAR_INT");
    int nMaskedNewLocalInt = nNewLocalInt & (1 << nBitShift);
    int nMaskedSetValue = nSetValue & (1 << nBitShift);

    MK_PrintToLog("nBitShift = " + IntToString(nBitShift));
    MK_PrintToLog("nBool = " + IntToString(nBool));
    MK_PrintToLog("nSetValue = " + IntToString(nSetValue));
    MK_PrintToLog("nMaskedSetValue = " + IntToString(nMaskedSetValue));
    MK_PrintToLog("nNewLocalInt = " + IntToString(nNewLocalInt));
    MK_PrintToLog("nMaskedNewLocalInt = " + IntToString(nMaskedNewLocalInt));

    return AssertInt(nMaskedNewLocalInt, (nBool ? (1 << nBitShift) : 0) );
}

//******************************************************************************
int TestSuite_LocalBool()
{
    MK_PrintToLog("#### TestSuite_LocalBool ####");

    int nResult = FALSE;
    nResult = SmokeTest_LocalInt(1 << LOCAL_INT_BITSHIFT_BOOLEAN_1);
    nResult = SmokeTest_LocalInt(1 << LOCAL_INT_BITSHIFT_BOOLEAN_2) && nResult;

    nResult = UnitTest_GetLocalBool(0, 0x0B) && nResult;
    nResult = UnitTest_GetLocalBool(1, 0x0B) && nResult;
    nResult = UnitTest_GetLocalBool(2, 0x0B) && nResult;
    nResult = UnitTest_GetLocalBool(3, 0x0B) && nResult;

    /*
    nResult = SmokeTest_Int2Bool(0x00) && nResult;
    nResult = SmokeTest_Int2Bool(0x01) && nResult;
    nResult = SmokeTest_Int2Bool(0x02) && nResult;
    nResult = SmokeTest_Int2Bool(0x03) && nResult;
    nResult = SmokeTest_Int2Bool(0x04) && nResult;
    nResult = SmokeTest_Int2Bool(0x05) && nResult;
    nResult = SmokeTest_Int2Bool(0x06) && nResult;
    nResult = SmokeTest_Int2Bool(0x07) && nResult;
    nResult = SmokeTest_Int2Bool(0x08) && nResult;
    nResult = SmokeTest_Int2Bool(0x09) && nResult;
    nResult = SmokeTest_Int2Bool(0x0A) && nResult;
    nResult = SmokeTest_Int2Bool(0x0B) && nResult;
    nResult = SmokeTest_Int2Bool(0x0C) && nResult;
    nResult = SmokeTest_Int2Bool(0x0D) && nResult;
    nResult = SmokeTest_Int2Bool(0x0E) && nResult;
    nResult = SmokeTest_Int2Bool(0x0F) && nResult;
    nResult = SmokeTest_Int2Bool(0x11) && nResult;
    nResult = SmokeTest_Int2Bool(0x12) && nResult;
    nResult = SmokeTest_Int2Bool(0x13) && nResult;
    */

    nResult = UnitTest_SetLocalBool(0, 1, 0x0B) && nResult;
    nResult = UnitTest_SetLocalBool(1, 1, 0x0B) && nResult;
    nResult = UnitTest_SetLocalBool(2, 1, 0x0B) && nResult;
    nResult = UnitTest_SetLocalBool(3, 1, 0x0B) && nResult;
    nResult = UnitTest_SetLocalBool(0, 0, 0x0B) && nResult;
    nResult = UnitTest_SetLocalBool(1, 0, 0x0B) && nResult;
    nResult = UnitTest_SetLocalBool(2, 0, 0x0B) && nResult;
    nResult = UnitTest_SetLocalBool(3, 0, 0x0B) && nResult;

    PrintTestSuiteSummary("TestSuite_LocalBool", nResult);
    return nResult;
}

//******************************************************************************
//void main() {TestSuite_LocalBool();}

#endif