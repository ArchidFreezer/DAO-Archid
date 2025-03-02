#ifndef MK_CONDITION_LOGIC_H
#defsym MK_CONDITION_LOGIC_H


//==============================================================================
//                              INCLUDES
//==============================================================================
/* Core */
#include "ai_main_h_2"
#include "ai_conditions_h"
/* Advanced Tactics */
#include "at_tools_ai_constants_h"
#include "at_tools_conditions_h"
#include "at_ai_conditions_nochange_h"
/* MkBot */
#include "mk_constants_h"
#include "mk_constants_ai_h"

#include "mk_get_creatures_h"
#include "mk_cond_tools_h"

#include "mk_test_framework_h"
#include "mk_print_to_log_h"
/* Talmud Storage*/
#include "talmud_storage_h"

//==============================================================================
//                            CONSTANTS
//==============================================================================
const int MK_LOGIC_SUBCONDITION_BOOL_1 = 1;
const int MK_LOGIC_SUBCONDITION_BOOL_2 = 2;
const int MK_LOGIC_SUBCONDITION_NOT_BOOL_1 = 3;
const int MK_LOGIC_SUBCONDITION_NOT_BOOL_2 = 4;

const int MK_LOGIC_SUBCONDITION_BOOL_1_AND_BOOL_2 = 5;
const int MK_LOGIC_SUBCONDITION_BOOL_1_AND_NOT_BOOL_2 = 6;
const int MK_LOGIC_SUBCONDITION_NOT_BOOL_1_AND_BOOL_2 = 7;
const int MK_LOGIC_SUBCONDITION_NOT_BOOL_1_AND_NOT_BOOL_2 = 8;

const int MK_LOGIC_SUBCONDITION_BOOL_1_OR_BOOL_2 = 9;
const int MK_LOGIC_SUBCONDITION_BOOL_1_OR_NOT_BOOL_2 = 10;
const int MK_LOGIC_SUBCONDITION_NOT_BOOL_1_OR_BOOL_2 = 11;
const int MK_LOGIC_SUBCONDITION_NOT_BOOL_1_OR_NOT_BOOL_2 = 12;

//==============================================================================
//                            DECLARATIONS
//==============================================================================
object _MK_AI_ConditionLogic(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nOperation);
int  MK_AI_GetBoolean1(object oCreature = OBJECT_SELF);
int  MK_AI_GetBoolean2(object oCreature = OBJECT_SELF);
void MK_AI_SetBoolean1(int nBool);
void MK_AI_SetBoolean2(int nBool);

//==============================================================================
//                            DEFINITIONS
//==============================================================================

int MK_AI_GetBoolean1(object oCreature = OBJECT_SELF)
{
    return MK_AI_GetLocalBool(LOCAL_INT_BITSHIFT_BOOLEAN_1, oCreature);
}

int MK_AI_GetBoolean2(object oCreature = OBJECT_SELF)
{
    return MK_AI_GetLocalBool(LOCAL_INT_BITSHIFT_BOOLEAN_2, oCreature);
}

void MK_AI_SetBoolean1(int nBool)
{
    MK_AI_SetLocalBool(LOCAL_INT_BITSHIFT_BOOLEAN_1, nBool);
}

void MK_AI_SetBoolean2(int nBool)
{
    MK_AI_SetLocalBool(LOCAL_INT_BITSHIFT_BOOLEAN_2, nBool);
}

object _MK_AI_ConditionLogic(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nOperation)
{
    int nResult = FALSE;
    switch(nOperation)
    {
        case MK_LOGIC_SUBCONDITION_BOOL_1:
        {
            nResult = MK_AI_GetBoolean1();
            break;
        }
        case MK_LOGIC_SUBCONDITION_BOOL_2:
        {
            nResult = MK_AI_GetBoolean2();
            break;
        }
        case MK_LOGIC_SUBCONDITION_NOT_BOOL_1:
        {
            nResult = !MK_AI_GetBoolean1();
            break;
        }
        case MK_LOGIC_SUBCONDITION_NOT_BOOL_2:
        {
            nResult = !MK_AI_GetBoolean2();
            break;
        }

        case MK_LOGIC_SUBCONDITION_BOOL_1_AND_BOOL_2:
        {
            nResult = MK_AI_GetBoolean1() && MK_AI_GetBoolean2();
            break;
        }
        case MK_LOGIC_SUBCONDITION_BOOL_1_AND_NOT_BOOL_2:
        {
            nResult = MK_AI_GetBoolean1() && !MK_AI_GetBoolean2();
            break;
        }
        case MK_LOGIC_SUBCONDITION_NOT_BOOL_1_AND_BOOL_2:
        {
            nResult = !MK_AI_GetBoolean1() && MK_AI_GetBoolean2();
            break;
        }
        case MK_LOGIC_SUBCONDITION_NOT_BOOL_1_AND_NOT_BOOL_2:
        {
            nResult = !MK_AI_GetBoolean1() && !MK_AI_GetBoolean2();
            break;
        }
        case MK_LOGIC_SUBCONDITION_BOOL_1_OR_BOOL_2:
        {
            nResult = MK_AI_GetBoolean1() || MK_AI_GetBoolean2();
            break;
        }
        case MK_LOGIC_SUBCONDITION_BOOL_1_OR_NOT_BOOL_2:
        {
            nResult = MK_AI_GetBoolean1() || !MK_AI_GetBoolean2();
            break;
        }
        case MK_LOGIC_SUBCONDITION_NOT_BOOL_1_OR_BOOL_2:
        {
            nResult = !MK_AI_GetBoolean1() || MK_AI_GetBoolean2();
            break;
        }
        case MK_LOGIC_SUBCONDITION_NOT_BOOL_1_OR_NOT_BOOL_2:
        {
            nResult = !MK_AI_GetBoolean1() || !MK_AI_GetBoolean2();
            break;
        }
        default:
        {
            string sMsg = "[_MK_AI_ConditionLogic] ERROR: unknown logic operation = " + IntToString(nOperation);
            DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, 0xFF0000, 5.0);
            MK_PrintToLog(sMsg);
            return OBJECT_INVALID;
        }
    }
    //DisplayFloatyMessage(OBJECT_SELF, " logic nResult="+ IntToString(nResult), FLOATY_MESSAGE, 0xFFFFFF, 2.0);
    if( nResult == FALSE )
        return OBJECT_INVALID;


    object oTarget;
    switch(nTargetType)
    {
        case AI_TARGET_TYPE_ENEMY:
        case AT_TARGET_TYPE_TARGET:
        case MK_TARGET_TYPE_SAVED_ENEMY:
        case AI_TARGET_TYPE_MOST_HATED:
        {
            object[] arTargets = _MK_AI_GetEnemiesFromTargetType(nTargetType);

            int i;
            int nSize = GetArraySize(arTargets);
            for (i = 0; i < nSize; i++)
            {
                if (_AT_AI_IsEnemyValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE)
                    return arTargets[i];
            }

            break;
        }
        case MK_TARGET_TYPE_PARTY_MEMBER:
        case AI_TARGET_TYPE_ALLY:
        case MK_TARGET_TYPE_TEAMMATE:
        case MK_TARGET_TYPE_TEAM_MEMBER:
        case AI_TARGET_TYPE_SELF:
        case AI_TARGET_TYPE_HERO:
        case AI_TARGET_TYPE_FOLLOWER:
        case AI_TARGET_TYPE_MAIN_CONTROLLED:
        case MK_TARGET_TYPE_SAVED_FRIEND:
        {
            object[] arTargets = _MK_AI_GetFollowersFromTargetType(nTargetType, nTacticID);

            int i;
            int nSize = GetArraySize(arTargets);
            for (i = 0; i < nSize; i++)
            {
                if (_MK_AI_IsFriendValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE)
                    return arTargets[i];
            }

            break;
        }
        default:
        {
            string sMsg = "[_MK_AI_ConditionLogic] ERROR: Unknown Target Type = " + IntToString(nTargetType);
            DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, 0xFF0000, 5.0);
            MK_PrintToLog(sMsg);

            break;
        }
    }

    return OBJECT_INVALID;
}

//==============================================================================
//                            UNIT TESTS
//==============================================================================
int UnitTest_ConditionLogic(int nOperation, int nBoolOracle)
{
    int nTacticCommand     = MK_COMMAND_SAVE_FRIEND;
    int nTacticSubCommand  = -1;
    int nTargetType        = AI_TARGET_TYPE_SELF;
    int nTacticID          = 1;
    int nAbilityTargetType = TARGET_TYPE_HOSTILE_CREATURE;

    object oTarget;

    PrintUnitTestHeader("UnitTest_ConditionLogic : nOperation = " + IntToString(nOperation));
    oTarget = _MK_AI_ConditionLogic(nTacticCommand, nTacticSubCommand, nTargetType, nTacticID, nAbilityTargetType, nOperation);
    return AssertBoolEqual(oTarget != OBJECT_INVALID, nBoolOracle);
}

int UnitTest_Boolean1(int nBoolBefore)
{
    MK_PrintToLog("==== UnitTest_Boolean1 ====");

    MK_AI_SetBoolean1(nBoolBefore);
    int nBoolAfter = MK_AI_GetBoolean1();

    MK_PrintToLog("nBoolBefore = " + IntToString(nBoolBefore));
    MK_PrintToLog("nBoolAfter = " + IntToString(nBoolAfter));

    return AssertBoolEqual(nBoolAfter, nBoolBefore);
}

int UnitTest_Boolean2(int nBoolBefore)
{
    MK_PrintToLog("==== UnitTest_Boolean2 ====");

    MK_AI_SetBoolean2(nBoolBefore);
    int nBoolAfter = MK_AI_GetBoolean2();

    MK_PrintToLog("nBoolBefore = " + IntToString(nBoolBefore));
    MK_PrintToLog("nBoolAfter = " + IntToString(nBoolAfter));

    return AssertBoolEqual(nBoolAfter, nBoolBefore);
}

int TestSuite_Boolean()
{
    PrintUnitTestHeader("TestSuite_Boolean");
    int nResult;

    nResult = UnitTest_Boolean1(TRUE);
    nResult = UnitTest_Boolean1(FALSE) && nResult;
    nResult = UnitTest_Boolean2(TRUE)  && nResult;
    nResult = UnitTest_Boolean2(FALSE) && nResult;

    int nBool1 = TRUE;
    int nBool2 = FALSE;
    MK_AI_SetBoolean1(nBool1);
    MK_AI_SetBoolean2(nBool2);

    nResult = UnitTest_ConditionLogic(MK_LOGIC_SUBCONDITION_BOOL_1,     nBool1)  && nResult;
    nResult = UnitTest_ConditionLogic(MK_LOGIC_SUBCONDITION_BOOL_2,     nBool2)  && nResult;
    nResult = UnitTest_ConditionLogic(MK_LOGIC_SUBCONDITION_NOT_BOOL_1, !nBool1) && nResult;
    nResult = UnitTest_ConditionLogic(MK_LOGIC_SUBCONDITION_NOT_BOOL_2, !nBool2) && nResult;

    nResult = UnitTest_ConditionLogic(MK_LOGIC_SUBCONDITION_BOOL_1_AND_BOOL_2,         nBool1 && nBool2)   && nResult;
    nResult = UnitTest_ConditionLogic(MK_LOGIC_SUBCONDITION_BOOL_1_AND_NOT_BOOL_2,     nBool1 && !nBool2)  && nResult;
    nResult = UnitTest_ConditionLogic(MK_LOGIC_SUBCONDITION_NOT_BOOL_1_AND_BOOL_2,     !nBool1 && nBool2)  && nResult;
    nResult = UnitTest_ConditionLogic(MK_LOGIC_SUBCONDITION_NOT_BOOL_1_AND_NOT_BOOL_2, !nBool1 && !nBool2) && nResult;

    nResult = UnitTest_ConditionLogic(MK_LOGIC_SUBCONDITION_BOOL_1_OR_BOOL_2,         nBool1 || nBool2)   && nResult;
    nResult = UnitTest_ConditionLogic(MK_LOGIC_SUBCONDITION_BOOL_1_OR_NOT_BOOL_2,     nBool1 || !nBool2)  && nResult;
    nResult = UnitTest_ConditionLogic(MK_LOGIC_SUBCONDITION_NOT_BOOL_1_OR_BOOL_2,     !nBool1 || nBool2)  && nResult;
    nResult = UnitTest_ConditionLogic(MK_LOGIC_SUBCONDITION_NOT_BOOL_1_OR_NOT_BOOL_2, !nBool1 || !nBool2) && nResult;

    PrintTestSuiteSummary("TestSuite_Boolean", nResult);
    return nResult;
}

//void main() {TestSuite_Boolean();}
#endif

