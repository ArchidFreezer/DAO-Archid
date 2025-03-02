#ifndef MK_BEHAVIOR_ATTACK_H
#defsym MK_BEHAVIOR_ATTACK_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* MkBot */
#include "mk_cond_at_party_range_h"
#include "mk_condition_lineofsight_h"

#include "mk_cmd_attack_h"
#include "mk_setcommandtimeout_h"
#include "mk_constants_ai_h"
#include "mk_behavior_check_h"
#include "mk_logger_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
command MK_BehaviorAttack(object oLastTarget, int nLastCommandType, int nLastCommandStatus);

command _MK_AttackCurrentTargetWithinRange(struct PartyRange partyRange, object oLastTarget, int nLastCommandType, int nLastCommandStatus);
command _MK_AttackEnemyWithinRange(struct PartyRange partyRange, object oLastTarget, int nLastCommandType, int nLastCommandStatus);
command _MK_AttackCreatureWithinRange(int nHostileTargetType, int nRangeID, int nFollowerTargetType, object oLastTarget, int nLastCommandType, int nLastCommandStatus);

command _MK_AttackCurrentTargetInLineOfSight(object oLastTarget, int nLastCommandType, int nLastCommandStatus);
command _MK_AttackEnemyInLineOfSight(object oLastTarget, int nLastCommandType, int nLastCommandStatus);
command _MK_AttackCreatureInLineOfSight(int nTargetType, object oLastTarget, int nLastCommandType, int nLastCommandStatus);
int MK_IsLineOfSightCorrupted(object oTarget, object oLastTarget, int nLastCommandType, int nLastCommandStatus);

//==============================================================================
//                                DEFINITIONS
//==============================================================================
//******************************************************************************
/** @brief
*
* @param nLastCommandStatus - see constants COMMAND_SUCCESSFUL/COMMAND_FAILED_
* @returns valid command on success; command invalid on failure
* @author MkBot
**/
command MK_BehaviorAttack(object oLastTarget, int nLastCommandType, int nLastCommandStatus)
{
    if (MK_BehaviorCheck_CanAttack() == FALSE)
        return MK_CommandInvalid();

    MK_PushToCallStackTrace("MK_BehaviorAttack");
    command cResult = MK_CommandInvalid();

    int bIsRangedWeaponEquipped = (_AI_GetWeaponSetEquipped() == AI_WEAPON_SET_RANGED);
    int bCanPickNewTarget = MK_BehaviorCheck_CanPickNewTarget();   
    struct PartyRange meleeRange = MK_BehaviorCheck_MeleeAttackRange();
    
    if (bIsRangedWeaponEquipped == TRUE)
    {
        if (bCanPickNewTarget == TRUE)
            cResult = _MK_AttackEnemyInLineOfSight(oLastTarget, nLastCommandType, nLastCommandStatus);
        else
            cResult = _MK_AttackCurrentTargetInLineOfSight(oLastTarget, nLastCommandType, nLastCommandStatus);
    }else if (MK_IsPartyRangeValid(meleeRange) == TRUE)
    {
        if (bCanPickNewTarget == TRUE)
            cResult = _MK_AttackEnemyWithinRange(meleeRange, oLastTarget, nLastCommandType, nLastCommandStatus);
        else
            cResult = _MK_AttackCurrentTargetWithinRange(meleeRange, oLastTarget, nLastCommandType, nLastCommandStatus);      
    }

    MK_RemoveLastFromCallStackTrace();
    return cResult;
}

//******************************************************************************
/** @brief ***INTERNAL***
**/
command _MK_AttackCurrentTargetInLineOfSight(object oLastTarget, int nLastCommandType, int nLastCommandStatus)
{
    return _MK_AttackCreatureInLineOfSight( AT_TARGET_TYPE_TARGET,
                                            oLastTarget,
                                            nLastCommandType,
                                            nLastCommandStatus);
}

//******************************************************************************
/** @brief ***INTERNAL***
**/
command _MK_AttackEnemyInLineOfSight(object oLastTarget, int nLastCommandType, int nLastCommandStatus)
{
    MK_PushToCallStackTrace("_MK_AttackEnemyInLineOfSight");
    command cResult =_MK_AttackCreatureInLineOfSight( AI_TARGET_TYPE_ENEMY,
                                            oLastTarget,
                                            nLastCommandType,
                                            nLastCommandStatus);
    MK_RemoveLastFromCallStackTrace();
    return cResult;
}

//******************************************************************************
/** @brief ***INTERNAL***
**/
command _MK_AttackCreatureInLineOfSight(int nTargetType, object oLastTarget, int nLastCommandType, int nLastCommandStatus)
{
    MK_PushToCallStackTrace("_MK_AttackCreatureInLineOfSight");

    object oEnemy = MK_AI_Condition_InLineOfSight(  AI_COMMAND_ATTACK,
                                                    ABILITY_INVALID,
                                                    nTargetType,
                                                    MK_TACTIC_ID_INVALID,
                                                    TARGET_TYPE_HOSTILE_CREATURE);
    if (oEnemy == OBJECT_INVALID)
    {
        MK_RemoveLastFromCallStackTrace();
        return MK_CommandInvalid();
    }

    if (MK_IsLineOfSightCorrupted(oEnemy, oLastTarget, nLastCommandType, nLastCommandStatus) == TRUE)
    {
        MK_Logger("Line of sight to " + ObjectToStringNameAndId(oEnemy) + " is corrupted", MK_LOG_LEVEL_INFORMATION);
        MK_RemoveLastFromCallStackTrace();
        return MK_CommandInvalid();
    }

    command cResult = MK_CommandAttack(oEnemy, oLastTarget, nLastCommandType, nLastCommandStatus);
    cResult = MK_SetCommandTimeout(cResult, MK_TIMEOUT_BEHAVIOR_ATTACK_RANGED);

    MK_RemoveLastFromCallStackTrace();
    return cResult;
}

//******************************************************************************
/** @brief ***INTERNAL***
**/
int MK_IsLineOfSightCorrupted(object oTarget, object oLastTarget, int nLastCommandType, int nLastCommandStatus)
{
    if (oTarget == oLastTarget
     && nLastCommandType == COMMAND_TYPE_ATTACK
     && nLastCommandStatus == COMMAND_FAILED_TIMEOUT)
    {
        return TRUE;
    }

    return FALSE;
}

//******************************************************************************
/** @brief ***INTERNAL***
* @param nRangeID - see MK_RANGE_ID_ constants
* @param nFollowerTargetType - see constants _TARGET_TYPE_
* @param nLastCommandStatus - see constants COMMAND_SUCCESSFUL/COMMAND_FAILED_
* @returns valid command on success; command invalid on failure
* @author MkBot
**/
command _MK_AttackCurrentTargetWithinRange(struct PartyRange partyRange, object oLastTarget, int nLastCommandType, int nLastCommandStatus)
{
    MK_PushToCallStackTrace("_MK_AttackCurrentTargetWithinRange");
    command cResult = _MK_AttackCreatureWithinRange(AT_TARGET_TYPE_TARGET,
                                                    partyRange.nRangeId,
                                                    partyRange.nTargetType,
                                                    oLastTarget,
                                                    nLastCommandType,
                                                    nLastCommandStatus);
    MK_RemoveLastFromCallStackTrace();
    return cResult;
}

//******************************************************************************
/** @brief ***INTERNAL***
* @param nRangeID - see MK_RANGE_ID_ constants
* @param nFollowerTargetType - see constants _TARGET_TYPE_
* @param nLastCommandStatus - see constants COMMAND_SUCCESSFUL/COMMAND_FAILED_
* @returns valid command on success; command invalid on failure
* @author MkBot
**/
command _MK_AttackEnemyWithinRange(struct PartyRange partyRange, object oLastTarget, int nLastCommandType, int nLastCommandStatus)
{
    MK_PushToCallStackTrace("_MK_AttackEnemyWithinRange");
    command cResult = _MK_AttackCreatureWithinRange(AI_TARGET_TYPE_ENEMY,
                                                    partyRange.nRangeId,
                                                    partyRange.nTargetType,
                                                    oLastTarget,
                                                    nLastCommandType,
                                                    nLastCommandStatus);
    MK_RemoveLastFromCallStackTrace();
    return cResult;
}

//******************************************************************************
/** @brief ***INTERNAL***
* @param nHostileTargetType - see constants _TARGET_TYPE_
* @param nRangeID - see MK_RANGE_ID_ constants
* @param nFollowerTargetType - see constants _TARGET_TYPE_
* @param nLastCommandStatus - see constants COMMAND_SUCCESSFUL/COMMAND_FAILED_
* @returns valid command on success; command invalid on failure
* @author MkBot
**/
command _MK_AttackCreatureWithinRange(int nHostileTargetType, int nRangeID, int nFollowerTargetType, object oLastTarget, int nLastCommandType, int nLastCommandStatus)
{
    MK_PushToCallStackTrace("_MK_AttackCreatureWithinRange");
    object oEnemy = MK_AI_Condition_AtRangeOfParty( AI_COMMAND_ATTACK,
                                                    ABILITY_INVALID,
                                                    nHostileTargetType,
                                                    MK_TACTIC_ID_INVALID,
                                                    TARGET_TYPE_HOSTILE_CREATURE,
                                                    nRangeID,
                                                    nFollowerTargetType);
    if (oEnemy == OBJECT_INVALID)
    {
        MK_RemoveLastFromCallStackTrace();
        return MK_CommandInvalid();
    }

    command cResult = MK_CommandAttack(oEnemy, oLastTarget, nLastCommandType, nLastCommandStatus);
    cResult = MK_SetCommandTimeout(cResult, MK_TIMEOUT_BEHAVIOR_ATTACK_MELEE);

    MK_RemoveLastFromCallStackTrace();
    return cResult;
}

//void main() {MK_BehaviorAttack(OBJECT_SELF, 0, 0);}
#endif