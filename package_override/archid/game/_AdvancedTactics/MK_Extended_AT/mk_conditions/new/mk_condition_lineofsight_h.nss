#ifndef MK_CONDITION_GET_NEAREST_VISIBLE_CREATURE_IN_LINE_OF_SIGHT_H
#defsym MK_CONDITION_GET_NEAREST_VISIBLE_CREATURE_IN_LINE_OF_SIGHT_H
//==============================================================================
//                              INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_condition_most_hated_h"

/* MkBot */
#include "mk_cond_tools_h"
#include "mk_other_h"
#include "mk_constants_ai_h"
#include "mk_test_framework_h"

//==============================================================================
//                              CONSTANTS
//==============================================================================

//==============================================================================
//                              DECLARATIONS
//==============================================================================
object MK_AI_Condition_InLineOfSight(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType);

void MK_SetSneakyBastardStatus(int nBool, object oEnemy);
int MK_HasSneakyBastardStatus(object oEnemy);

//==============================================================================
//                              DEFINITIONS
//==============================================================================
void MK_SetSneakyBastardStatus(int nBool, object oEnemy)
{
    int nIndex = MK_GetFollowerIndexInActiveParty(OBJECT_SELF);
    //Performance: nIndex >= 0 check is not necessary because only followers in active party can call script
    MK_AI_SetLocalBool(nIndex, nBool, oEnemy);
}


int MK_HasSneakyBastardStatus(object oEnemy)
{
    int nIndex = MK_GetFollowerIndexInActiveParty(OBJECT_SELF);
    //Performance: nIndex >= 0 check is not necessary because only followers in active party can call script
    return MK_AI_GetLocalBool(nIndex, oEnemy);
}

/** @brief Return creature which is in line of sight. This function use "Sneaky Bastard" feature which makes it more robust.
*
* This condition uses "Sneaky Bastard" feature i.e. it takes into account whether
* our last ranged attack against target was unsuccessful. Simple use of
* CheckLineOfSightObject() function is not enough since it is partially
* broken and sometimes it returns false positives.
*
* @param nTacticCommand     - see constants : AI_COMMAND_, AT_COMMAND_, MK_COMMAND_
* @param nTacticSubCommand  - see constants : AT_ABILITY_
* @param nTargetType        - see constants : AI_TARGET_TYPE_, AT_TARGET_TYPE, MK_TARGET_TYPE_
* @param nTacticID          - required for AI_TARGET_TYPE_FOLLOWER to acquire follower's ID from GUI
* @param nAbilityTargetType - see constants : TARGET_TYPE_
* @returns                  - valid target if found, else OBJECT_INVALID
* @author MkBot
**/
object MK_AI_Condition_InLineOfSight(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType)
{
    switch(nTargetType)
    {
        case AI_TARGET_TYPE_ENEMY:
        case AT_TARGET_TYPE_TARGET:
        case MK_TARGET_TYPE_SAVED_ENEMY:
        case AI_TARGET_TYPE_MOST_HATED:
        {
            object[] arEnemies = _MK_AI_GetEnemiesFromTargetType(nTargetType);
            int nSize = GetArraySize(arEnemies);

            int i;
            for (i = 0; i < nSize; i++)
            {
                int nIsValidTarget = _AT_AI_IsEnemyValidForAbility(arEnemies[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) &&
                                     //_MK_AI_IsAtRange(arEnemies[i], MK_RANGE_ID_BOW) &&
                                     !_MK_AI_IsSleepRoot(arEnemies[i]) &&
                                     !MK_HasSneakyBastardStatus(arEnemies[i]) &&
                                     CheckLineOfSightObject(OBJECT_SELF, arEnemies[i]);
                if (nIsValidTarget)
                    return arEnemies[i];
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
            object[] arFriends = _MK_AI_GetFollowersFromTargetType(nTargetType, nTacticID);
            int nSize = GetArraySize(arFriends);

            int i;
            for (i = 0; i < nSize; i++)
            {
                int nIsValidTarget = _MK_AI_IsFriendValidForAbility(arFriends[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) &&
                                     //_MK_AI_IsAtRange(arFriends[i], MK_RANGE_ID_BOW) &&
                                     CheckLineOfSightObject(OBJECT_SELF, arFriends[i]);
                if (nIsValidTarget)
                    return arFriends[i];
            }

            break;
        }
        default:
        {
            string sMsg = "Unknown Target Type = " + IntToString(nTargetType);
            MK_Error(nTacticID, "MK_AI_Condition_InLineOfSight", sMsg);

            break;
        }
    }

    return OBJECT_INVALID;
}

//==============================================================================
//                              UNIT TESTS
//==============================================================================
int UnitTest_SneakyBastardStatus(object oEnemy)
{
    PrintUnitTestHeader("UnitTest_SneakyBastardStatus");

    int nResult = TRUE;
    int nIsBastard;
    string sMsg;

    nIsBastard = MK_HasSneakyBastardStatus(oEnemy);
    sMsg = "(1) oEnemy.name = " + ObjectToStringName(oEnemy) +
           "; oEnemy.id = " + ObjectToString(oEnemy) +
           "; oEnemy.isBastard = " + BoolToString(nIsBastard);
    MK_PrintToLog(sMsg);

    MK_SetSneakyBastardStatus(TRUE, oEnemy);
    nIsBastard = MK_HasSneakyBastardStatus(oEnemy);
    sMsg = "(2) oEnemy.name = " + ObjectToStringName(oEnemy) +
           "; oEnemy.id = " + ObjectToString(oEnemy) +
           "; oEnemy.isBastard = " + BoolToString(nIsBastard);
    MK_PrintToLog(sMsg);
    nResult = nResult && AssertBoolEqual(nIsBastard, TRUE);

    MK_SetSneakyBastardStatus(FALSE, oEnemy);
    nIsBastard = MK_HasSneakyBastardStatus(oEnemy);
    sMsg = "(3) oEnemy.name = " + ObjectToStringName(oEnemy) +
           "; oEnemy.id = " + ObjectToString(oEnemy) +
           "; oEnemy.isBastard = " + BoolToString(nIsBastard);
    MK_PrintToLog(sMsg);
    nResult = nResult && AssertBoolEqual(nIsBastard, FALSE);

    return nResult;
}

int UnitTest_InLineOfSight()
{
    PrintUnitTestHeader("UnitTest_InLineOfSight");

    object[] arEnemies = _MK_AI_GetEnemies(OBJECT_SELF);
    int nSize = GetArraySize(arEnemies);

    int i;
    for (i = 0; i < nSize; i++)
    {
        string sMsg;
        sMsg = "oEnemy.name = " + ObjectToStringName(arEnemies[i]) +
               "; oEnemy.id = " + ObjectToString(arEnemies[i]) +
               "; oEnemy.isValidForAbility = " + BoolToString(_AT_AI_IsEnemyValidForAbility(arEnemies[i], AI_COMMAND_ATTACK, ABILITY_INVALID, TARGET_TYPE_HOSTILE_CREATURE)) +
               "; oEnemy.isSleepRoot = " + BoolToString(_MK_AI_IsSleepRoot(arEnemies[i])) +
               "; oEnemy.isBastard = " + BoolToString(MK_HasSneakyBastardStatus(arEnemies[i])) +
               "; oEnemy.lineOfSight = " + BoolToString(CheckLineOfSightObject(OBJECT_SELF, arEnemies[i]));

        MK_PrintToLog(sMsg);
    }

    object oEnemy = MK_AI_Condition_InLineOfSight(AI_COMMAND_ATTACK,
                                              ABILITY_INVALID,
                                              AI_TARGET_TYPE_ENEMY,
                                              MK_TACTIC_ID_INVALID,
                                              TARGET_TYPE_HOSTILE_CREATURE);
    return AssertObject(oEnemy);
}

int TestSuite_SneakyBastard()
{
    PrintTestSuiteHeader("TestSuite_SneakyBastard");
    int nResult = TRUE;

    object[] arEnemies = _MK_AI_GetEnemies(OBJECT_SELF, FALSE, FALSE);
    int nSize = GetArraySize(arEnemies);

    int i;
    for (i = 0; i < nSize; i++)
        nResult = nResult && UnitTest_SneakyBastardStatus(arEnemies[i]);

    nResult = nResult && UnitTest_InLineOfSight();

    PrintTestSuiteSummary("TestSuite_SneakyBastard", nResult);
    return nResult;
}

//void main() {TestSuite_SneakyBastard();}

#endif