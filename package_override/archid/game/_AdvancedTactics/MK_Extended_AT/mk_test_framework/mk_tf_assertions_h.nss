#ifndef MK_TEST_FRAMEWORK_H
#defsym MK_TEST_FRAMEWORK_H

#include "mk_print_to_log_h"
#include "mk_to_string_h"

//==============================================================================
//                              DECLARATIONS
//==============================================================================
void PrintUnitTestHeader(string sUnitTestName);
void PrintTestSuiteHeader(string sTestSuiteName);
void PrintTestSuiteSummary(string sTestSuiteName, int nResult);

int ResultAnd(int bResult, int bTest);

int AssertInt(int nInteger, int nOracle);

int AssertBool(int nBool);
int AssertBoolNot(int nBool);    
int AssertTrue(int nBool);
int AssertFalse(int nBool);
int AssertBoolEqual(int nBool, int nOracle);

int AssertObject(object oObject);
int AssertObjectEqual(object oObject, object oOracle);
int AssertObjectNotEqual(object oObject, object oOracle);

int AssertLocationEqual(location lLocation, location lOracle);
int AssertLocationNotEqual(location lLocation, location lOracle);

int AssertStringEqual(string sString, string sOracle);
int AssertStringNotEqual(string sString, string sOracle);

//==============================================================================
//                              DEFINITIONS
//==============================================================================
int ResultAnd(int bResult, int bTest)
{
 return bTest && bResult;
}

int AssertInt(int nInteger, int nOracle)
{
    if (nInteger == nOracle)
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

//******************************************************************************
int AssertBool(int nBool)
{
    if (nBool != FALSE)
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

//******************************************************************************
int AssertBoolNot(int nBool)
{    
    return AssertBool(!nBool);   
}

//******************************************************************************
int AssertTrue(int nBool)
{
    return AssertBool(nBool);
}

//******************************************************************************
int AssertFalse(int nBool)
{
    return AssertBoolNot(nBool);
}

//******************************************************************************
int AssertBoolEqual(int nBool, int nOracle)
{
    if ((nBool != FALSE && nOracle != FALSE) || (nBool == FALSE && nOracle == FALSE))
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

//******************************************************************************
int AssertObject(object oObject)
{
    if (oObject != OBJECT_INVALID)
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

//******************************************************************************
int AssertObjectEqual(object oObject, object oOracle)
{
    
    if (oObject == oOracle &&
        oObject != OBJECT_INVALID &&
        oOracle != OBJECT_INVALID)
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

//******************************************************************************
int AssertObjectNotEqual(object oObject, object oOracle)
{
    
    if (oObject != oOracle &&
        oObject != OBJECT_INVALID &&
        oOracle != OBJECT_INVALID)
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

//******************************************************************************
int AssertLocationEqual(location lLocation, location lOracle)
{
    if (lLocation == lOracle)
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

//******************************************************************************
int AssertLocationNotEqual(location lLocation, location lOracle)
{
    if (lLocation != lOracle)
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

//******************************************************************************
int AssertStringEqual(string sString, string sOracle)
{
    if (StringUpperCase(sString) == StringUpperCase(sOracle) &&
        IsStringEmpty(sString) == FALSE &&
        IsStringEmpty(sOracle) == FALSE)
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

//******************************************************************************
int AssertStringNotEqual(string sString, string sOracle)
{
    if (StringUpperCase(sString) != StringUpperCase(sOracle) &&
        IsStringEmpty(sString) == FALSE &&
        IsStringEmpty(sOracle) == FALSE)
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

//******************************************************************************
void PrintUnitTestHeader(string sUnitTestName)
{
    MK_PrintToLog("==== " + sUnitTestName);
}

//******************************************************************************
void PrintTestSuiteHeader(string sTestSuiteName)
{
    MK_PrintToLog("#### " + sTestSuiteName + " ####");
}

//******************************************************************************
void PrintTestSuiteSummary(string sTestSuiteName, int nResult)
{
    string sSummary = "#### " + sTestSuiteName + " = " + (nResult ? "SUCCESS" : "FAILURE") + " ####";
    MK_PrintToLog(sSummary);
    DisplayFloatyMessage(OBJECT_SELF, (nResult ? "SUCCESS" : "FAILURE"));
}

#endif