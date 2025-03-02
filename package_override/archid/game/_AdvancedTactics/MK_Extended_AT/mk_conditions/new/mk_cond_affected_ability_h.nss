#ifndef MK_CONDITION_AFFECTED_BY_ABILITY_H
#defsym MK_CONDITION_AFFECTED_BY_ABILITY_H
//==============================================================================
//                              INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"

/* MkBot */
#include "mk_cond_tools_h"
#include "mk_constants_ai_h"
#include "mk_test_framework_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object MK_Condition_AffectedByAbility(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nParameter1, int nAbilityId);
int MK_IsAffectedByAbility(object oCreature, int nAbilityId);

//==============================================================================
//                               DEFINITIONS
//==============================================================================

/** @brief Returns nearest enemy that has any effect caused by given ability
*
* @param nTacticCommand     - see constants : AI_COMMAND_, AT_COMMAND_, MK_COMMAND_
* @param nTacticSubCommand  - see constants : AT_ABILITY_
* @param nTargetType        - see constants : AI_TARGET_TYPE_, AT_TARGET_TYPE, MK_TARGET_TYPE_
* @param nTacticID          - required for AI_TARGET_TYPE_FOLLOWER to acquire follower's ID from GUI
* @param nAbilityTargetType - see constants : TARGET_TYPE_
* @param Parameter1         - not used
* @param nAbilityId         - see constants : AT_ABILITY_
* @returns                  - valid target if found, else OBJECT_INVALID
* @author MkBot
**/
object MK_Condition_AffectedByAbility(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nParameter1, int nAbilityId)
{
    switch (nTargetType)
    {        
        case AI_TARGET_TYPE_ENEMY:
        case AT_TARGET_TYPE_TARGET:
        case MK_TARGET_TYPE_SAVED_ENEMY:
        case AI_TARGET_TYPE_MOST_HATED:
        {
            object[] arTargets = _MK_AI_GetEnemiesFromTargetType(nTargetType);
            int nSize = GetArraySize(arTargets);
            
            int i;
            for (i = 0; i < nSize; i++)
            {
                if (_AT_AI_IsEnemyValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE &&
                    _MK_AI_IsSleepRoot(arTargets[i]) == FALSE &&  
                    MK_IsAffectedByAbility(arTargets[i], nAbilityId) == TRUE)
                {
                    return arTargets[i];
                }                
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
            int nSize = GetArraySize(arTargets);
            
            int i;
            for (i = 0; i < nSize; i++)
            {
                if (_MK_AI_IsFriendValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE &&
                    MK_IsAffectedByAbility(arTargets[i], nAbilityId) == TRUE)
                {
                    return arTargets[i];
                }
            }
            
            break;
        }
        default:
        {
            string sMsg = "Unknown nTargetType = " + IntToString(nTargetType);
            MK_Error(nTacticID, "MK_Condition_AffectedByAbility", sMsg);

            break;
        }    
    }

    return OBJECT_INVALID;    
}



/** @brief Checks whether oCreature has any effect caused by given ability
*
* @param oCreature  - creature to test
* @param nAbilityId - see constants : AT_ABILITY_
* @returns          - TRUE or FALSE
* @author MkBot
**/
int MK_IsAffectedByAbility(object oCreature, int nAbilityId)
{
    effect[] arEffects = GetEffectsByAbilityId(oCreature, nAbilityId);
    if (GetArraySize(arEffects) > 0)
        return TRUE;    
    return FALSE;    
}

//==============================================================================
//                              UNIT TESTS
//==============================================================================
int UnitTest_IsAffectedByAbility()
{    
    PrintUnitTestHeader("UnitTest_IsAffectedByAbility");

    object oCreature = OBJECT_SELF;
    int nAbilityId = AT_ABILITY_RAPIDSHOT;
    
    return AssertBool(MK_IsAffectedByAbility(oCreature, nAbilityId));
}

int UnitTest_TargetAffectedByAbility()
{       
    PrintUnitTestHeader("UnitTest_TargetAffectedByAbility");
    
    object oEnemy = MK_Condition_AffectedByAbility(AI_COMMAND_ATTACK, 
                                                   ABILITY_INVALID, 
                                                   AI_TARGET_TYPE_ENEMY, 
                                                   MK_TACTIC_ID_INVALID, 
                                                   TARGET_TYPE_HOSTILE_CREATURE, 
                                                   0, 
                                                   AT_ABILITY_SHATTERING_SHOT);
 
    return AssertObject(oEnemy) && AssertObjectEqual(oEnemy, GetAttackTarget(OBJECT_SELF));
}

int TestSuite_IsAffectedByAbility()
{
    PrintTestSuiteHeader("TestSuite_IsAffectedByAbility");    
    int nResult = TRUE;

    nResult = UnitTest_IsAffectedByAbility() && nResult;
    nResult = UnitTest_TargetAffectedByAbility() && nResult;

    PrintTestSuiteSummary("TestSuite_IsAffectedByAbility", nResult);
    return nResult;
}

//void main() {TestSuite_IsAffectedByAbility();}
#endif
