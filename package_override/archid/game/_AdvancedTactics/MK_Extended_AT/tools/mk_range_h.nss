#ifndef _MK_RANGE_H
#defsym _MK_RANGE_H

//==============================================================================
//                                INCLUDES
//==============================================================================
#include "mk_print_to_log_h"
#include "mk_constants_h"
#include "mk_get_creatures_h"
#include "mk_test_framework_h"
#include "mk_logger_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
float _MK_GetRangeFromID(int nRangeID);
int MK_IsAnyEnemyAtRange(float fRange, int nTargetType);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
//******************************************************************************
float _MK_GetRangeFromID(int nRangeID)
{
    MK_PushToCallStackTrace("_MK_GetRangeFromID");
    
    float fResult;    
    switch(nRangeID)
    {
        case MK_RANGE_ID_SHORT:
            fResult = MK_RANGE_SHORT;
            break;
        case MK_RANGE_ID_MEDIUM:
            fResult = MK_RANGE_MEDIUM;
            break;
        case MK_RANGE_ID_LONG:
            fResult = MK_RANGE_LONG;
            break;
        case MK_RANGE_ID_DOUBLE_SHORT:
            fResult = MK_RANGE_DOUBLE_SHORT;
            break;
        case MK_RANGE_ID_DOUBLE_MEDIUM:
            fResult = MK_RANGE_DOUBLE_MEDIUM;
            break;
        case MK_RANGE_ID_BOW:
            fResult = MK_RANGE_BOW;
            break;
        default:
            fResult = -1.0;
            MK_Logger("Unknown RangeTypeID = " + IntToString(nRangeID), MK_LOG_LEVEL_ERROR);            
            break;
    }

    MK_RemoveLastFromCallStackTrace();
    return fResult;
}

/** @brief Checks whether there is any enemy at given range to given TARGET_TYPE_*
*
*   Description of function
*
* @param nRangeId - see constants : MK_RANGE_ID_
* @param nTargetTypeId - see constants : AI_TARGET_TYPE_ (AI_TARGET_TYPE_FOLLOWER not supported)
* @returns True/False
* @author MkBot
**/
int MK_IsAnyEnemyAtRange(float fRange, int nTargetType)
{
    if (nTargetType == AI_TARGET_TYPE_FOLLOWER)
    {
        MK_Error(MK_TACTIC_ID_INVALID, "IsEnemyAtRange", "AI_TARGET_TYPE_FOLLOWER is not supported");
        return FALSE;
    }

    object[] arEnemies = _AT_AI_GetEnemies();
    int nEnemiesSize = GetArraySize(arEnemies);

    object[] arFollowers = _MK_AI_GetFollowersFromTargetType(nTargetType, MK_TACTIC_ID_INVALID);
    int nFollowersSize = GetArraySize(arFollowers);


    int iEnemy;
    int iFollower;
    for (iEnemy = 0; iEnemy < nEnemiesSize; iEnemy++)
    {
        for(iFollower = 0; iFollower < nFollowersSize; iFollower++)
        {
            float fDistance = GetDistanceBetween(arFollowers[iFollower], arEnemies[iEnemy]);
            if (fDistance <= fRange)
                return TRUE;
        }
    }

    return FALSE;
}

//#defsym MY_DEFINE if ( TRUE !=
//==============================================================================
//                            UNIT TESTS
//==============================================================================
//******************************************************************************
int UnitTest_IsAnyEnemyAtRangeWhenNoEnemies()
{
    PrintUnitTestHeader("UnitTest_IsAnyEnemyAtRange");

    object oHero = GetHero();
    SetLocation(oHero, TF_GetLocNearShortRange());

    object oAlistair = TF_AddAlistairToParty();
    SetLocation(oAlistair, TF_GetLocNear2xShortRange());

    object oDog = TF_AddDogToParty();
    SetLocation(oDog, TF_GetLocNearMediumRange());

    TF_RefreshPartyPerception();

    int bResult = TRUE;

    int[] arTargetTypes = TF_GetFriendlyTargetTypes();
    int nSize = GetArraySize(arTargetTypes);
    int i;
    for (i = 0; i < nSize; i++)
        bResult = ResultAnd(bResult, AssertBoolNot(MK_IsAnyEnemyAtRange(1000.0, arTargetTypes[i])));

    TF_RemoveAllFromParty();
    return AssertBool(bResult);
}

//******************************************************************************
int UnitTest_IsAnyEnemyAtRangeWhenEnemyAt2xShort()
{
    PrintUnitTestHeader("UnitTest_IsAnyEnemyAtRangeWhenEnemyAt2xShort");
    int bResult = TRUE;

    object oDog = TF_AddDogToParty();
    SetLocation(GetHero(), TF_GetLocNearShortRange());
    SetLocation(oDog, GetFollowerWouldBeLocation(oDog));

    TF_CreatePassiveEnemy(MK_RANGE_DOUBLE_SHORT);
    TF_RefreshPartyPerception();

    bResult = ResultAnd(bResult, AssertBoolNot(MK_IsAnyEnemyAtRange(MK_RANGE_SHORT, AI_TARGET_TYPE_SELF)));
    bResult = ResultAnd(bResult, AssertBool(MK_IsAnyEnemyAtRange(MK_RANGE_DOUBLE_SHORT, AI_TARGET_TYPE_SELF)));

    SetLocation(GetHero(), TF_GetLocNear2xShortRange());
    bResult = ResultAnd(bResult, AssertBool(MK_IsAnyEnemyAtRange(MK_RANGE_SHORT, AI_TARGET_TYPE_SELF)));
    SetLocation(GetHero(), TF_GetLocNearMediumRange());
    bResult = ResultAnd(bResult, AssertBoolNot(MK_IsAnyEnemyAtRange(MK_RANGE_SHORT, AI_TARGET_TYPE_SELF)));

    bResult = ResultAnd(bResult, AssertBoolNot(MK_IsAnyEnemyAtRange(MK_RANGE_SHORT, AI_TARGET_TYPE_ALLY)));
    bResult = ResultAnd(bResult, AssertBoolNot(MK_IsAnyEnemyAtRange(MK_RANGE_DOUBLE_SHORT, AI_TARGET_TYPE_ALLY)));

    SetLocation(oDog, TF_GetLocNearShortRange());
    bResult = ResultAnd(bResult, AssertBool(MK_IsAnyEnemyAtRange(MK_RANGE_DOUBLE_SHORT, AI_TARGET_TYPE_ALLY)));

    SetLocation(oDog, TF_GetLocNear2xShortRange());
    bResult = ResultAnd(bResult, AssertBool(MK_IsAnyEnemyAtRange(MK_RANGE_SHORT, AI_TARGET_TYPE_ALLY)));

    SetLocation(GetHero(), TF_GetStartLoc());
    TF_RemoveAllFromParty();
    TF_RemoveAllEnemies();
    return bResult;
}

//******************************************************************************
int TestSuite_IsAnyEnemyAtRange()
{
    PrintTestSuiteHeader("TestSuite_IsAnyEnemyAtRange");

    int bResult = TRUE;

    bResult = ResultAnd(bResult, UnitTest_IsAnyEnemyAtRangeWhenNoEnemies());
    bResult = ResultAnd(bResult, UnitTest_IsAnyEnemyAtRangeWhenEnemyAt2xShort());

    PrintTestSuiteSummary("TestSuite_IsAnyEnemyAtRange", bResult);
    return bResult;
}


//******************************************************************************
//void main(){TestSuite_IsAnyEnemyAtRange();}
#endif