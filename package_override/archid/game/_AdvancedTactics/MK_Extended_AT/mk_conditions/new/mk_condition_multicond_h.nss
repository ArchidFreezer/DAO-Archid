#ifndef MK_CONDITION_MUTICONDITION_ENEMY_SEARCH_H
#defsym MK_CONDITION_MUTICONDITION_ENEMY_SEARCH_H

//==============================================================================
//                              INCLUDES
//==============================================================================
#include "mk_condition_ai_status_h"
#include "mk_condition_ai_statusnot_h"
#include "mk_condition_any_h"
#include "mk_condition_atrange_h"
#include "mk_condition_attack_party_h"
#include "mk_condition_beingattack_h"
#include "mk_condition_beingattackn_h"
#include "mk_condition_gamemode_h"
#include "mk_condition_has_armortyp_h"
#include "mk_condition_has_rank_h"
#include "mk_condition_has_resist_h"
#include "mk_condition_hasbuff_h"
#include "mk_condition_hasdebuff_h"
#include "mk_condition_lineofsight_h"
#include "mk_condition_logic_h"
#include "mk_condition_near_buff_h"
#include "mk_condition_near_class_h"
#include "mk_condition_near_gender_h"
#include "mk_condition_near_race_h"
#include "mk_condition_near_visible_h"
#include "mk_condition_stat_level_h"
#include "mk_condition_surrounded_h"
#include "mk_condition_targetofally_h"
#include "mk_condition_useattacktyp_h"
#include "mk_condition_userangedat_h"
#include "mk_condition_x_at_range_h"
#include "mk_x_at_range_party_h"
#include "mk_cond_affected_ability_h"

#include "mk_get_creatures_h"
#include "mk_sort_creatures_h"

#include "mk_print_to_log_h"
#include "mk_talmud_wrappers_h"

//==============================================================================
//                          CONSTANTS
//==============================================================================
//========
const int MK_PREFERENCES_PREFER_SELF       = 1;
const int MK_PREFERENCES_PREFER_FOLLOWER   = 2;
const int MK_PREFERENCES_PREFER_HERO       = 3;
const int MK_PREFERENCES_PREFER_CONTROLLED = 4;

const int MK_PREFERENCES_EXCLUDE_SELF       = 11;
const int MK_PREFERENCES_EXCLUDE_FOLLOWER   = 12;
const int MK_PREFERENCES_EXCLUDE_HERO       = 13;
const int MK_PREFERENCES_EXCLUDE_CONTROLLED = 14;
const int MK_PREFERENCES_EXCLUDE_SUMMONED   = 15;

const int MK_PREFERENCES_INCLUDE_DEAD = 21;

//========
const int MK_PREFERENCES_PREFER_SELF_TARGET       = 1;
const int MK_PREFERENCES_PREFER_FOLLOWER_TARGET   = 2;
const int MK_PREFERENCES_PREFER_HERO_TARGET       = 3;
const int MK_PREFERENCES_PREFER_CONTROLLED_TARGET = 4;

const int MK_PREFERENCES_EXCLUDE_SELF_TARGET       = 11;
const int MK_PREFERENCES_EXCLUDE_FOLLOWER_TARGET   = 12;
const int MK_PREFERENCES_EXCLUDE_HERO_TARGET       = 13;
const int MK_PREFERENCES_EXCLUDE_CONTROLLED_TARGET = 14;

const int MK_PREFERENCES_INCLUDE_DEAD_TARGET       = 21;
const int MK_PREFERENCES_INCLUDE_SLEEP_ROOT_TARGET = 22;

//==============================================================================
//                          DECLARATIONS
//==============================================================================

//======== Conditions Tests
int IsHostileCreatureSatysfyingConditionsList(object oEnemy, int[] arTacticID, int[] arBaseCondition, int[] arTacticParameter1, int[] arTacticParameter2);
int IsFriendlyCreatureSatysfyingConditionsList(object oFriend, int[] arTacticID, int[] arBaseCondition, int[] arTacticParameter1, int[] arTacticParameter2);
int IsHostileCreatureSatysfyingCondition(object oEnemy, int nTacticID, int nBaseCondition, int nTacticParameter1, int nTacticParameter2);
int IsFriendlyCreatureSatysfyingCondition(object oFriend, int nTacticID, int nBaseCondition, int nTacticParameter1, int nTacticParameter2);
int IsCreatureSatysfyingTargetIndependentCondition(object oCreature, int nBaseCondition, int nTacticParameter1, int nTacticParameter2);

int MK_IsHostileCreatureValidForAnyAbility(object oEnemy, int[] arAbilities, int[] arAbilitiesTargetType);
int MK_IsFriendlyCreatureValidForAnyAbility(object oFriend, int[] arAbilities, int[] arAbilitiesTargetType);
int _MK_AbilityIdFromTacticParameters(int nTacticParameter1, int nTacticParameter2);

//======== SortBy Sorting Functions
object[] _MK_AI_GetEnemiesSortedBy(int[] arSortTypeIds, int[] arPreferencesIds);
object[] _MK_AI_GetFriendsSortedBy(int[] arSortTypeIds, int[] arPreferences);
int _MK_AI_GetEnemiesByPreferences(int[] arPreferencesIds, object[] outEnemies);
int _MK_AI_GetFriendsByPreferences(int[] arPreferencesIds, object[] outFollowers);

//======== Multi Condition Search Functions
int MK_AI_HandleMulticondition(struct TacticRow tTactic, int nUseGUITables, int nPackageTable);

//======== Multi Condition Syntax
int MK_CheckMultiConditionSyntax(struct TacticRow tTacticCurrent, struct TacticRow tTacticPrevious);
int MK_IsMultiConditionTactic(struct TacticRow tTactic);
void MK_Print_MultiConditionSyntaxError(struct TacticRow tTactic);

//==============================================================================
//                      DEFINITIONS : Conditions Tests
//==============================================================================

/** @brief
* Auxiliary function for IsHostileCreatureSatysfyingCondition()
* and IsFriendlyCreatureSatysfyingCondition().
*
* This function processes those conditions that do not require separate
* implementations for Party Members and Enemies.
*
* If given condition is not supported then MK_UNPROCESSED is returned.
*
* @param oCreature         - creature to test condition for
* @param nBaseCondition    - id of condition (see tacticsbaseconditions.gda). Determines condition function that will be used.
* @param nTacticParameter1 - meaning depends on condition (see tacticsconditions.gda). Parameter for condition function.
* @param nTacticParameter2 - meaning depends on condition (see tacticsconditions.gda). Parameter for condition function.
* @returns  MK_SUCCESS, MK_FAILURE or MK_UNPROCESSED
*/
int IsCreatureSatysfyingTargetIndependentCondition(object oCreature, int nBaseCondition, int nTacticParameter1, int nTacticParameter2)
{
    int nResult = MK_SUCCESS;

    switch(nBaseCondition)
    {
        case AI_BASE_CONDITION_HAS_EFFECT_APPLIED:
        {
            if(_MK_AI_HasAIStatus(oCreature, nTacticParameter1) == FALSE)
                nResult = MK_FAILURE;
            break;
        }
        case MK_BASE_CONDITION_AI_STATUS_NOT:
        {
            if(_MK_AI_HasAIStatus(oCreature, nTacticParameter1) == TRUE)
                nResult = MK_FAILURE;
            break;
        }
        case AI_BASE_CONDITION_HP_LEVEL:
        {
            if(MK_AI_HasStatLevel(oCreature, AI_STAT_TYPE_HP, nTacticParameter1, nTacticParameter2) == FALSE)
                nResult = MK_FAILURE;
            break;
        }
        case AI_BASE_CONDITION_MANA_OR_STAMINA_LEVEL:
        {
            if(MK_AI_HasStatLevel(oCreature, AI_STAT_TYPE_MANA_OR_STAMINA, nTacticParameter1, nTacticParameter2) == FALSE)
                nResult = MK_FAILURE;
            break;
        }
        case AI_BASE_CONDITION_HAS_ANY_BUFF_EFFECT:
        {
            if(_MK_SubCondition_HasBuff(oCreature, nTacticParameter2) == FALSE)
                nResult = MK_FAILURE;
            break;
        }
        case AT_BASE_CONDITION_HAS_DEBUFF_SPELL:
        {
            if(_AT_SubCondition_HasDebuff(oCreature, nTacticParameter1) == FALSE)
                nResult = MK_FAILURE;
            break;
        }
        case AI_BASE_CONDITION_HAS_ARMOR_TYPE:
        {
            if((_AI_GetArmorType(oCreature) & nTacticParameter1) == 0)
                nResult = MK_FAILURE;
            break;
        }
        case MK_BASE_CONDITION_HAS_RESISTANCE:
        {
            if(_MK_AI_HasResistance(oCreature, nTacticParameter1,nTacticParameter2) == FALSE)
                nResult = MK_FAILURE;
            break;
        }
        /*case MK_BASE_CONDITION_HAS_IMMUNITY:
        {
            //TODO
            break;
        }*/
        case AI_BASE_CONDITION_NEAREST_RACE:
        {
            if(_MK_AI_IsRace(oCreature, nTacticParameter1) == FALSE)
                nResult = MK_FAILURE;
            break;
        }
        case AI_BASE_CONDITION_NEAREST_CLASS:
        {
            if (_MK_AI_IsClass(oCreature, nTacticParameter1) == FALSE)
                nResult = MK_FAILURE;
            break;
        }
        case AI_BASE_CONDITION_NEAREST_GENDER:
        {
            if(_MK_AI_IsGender(oCreature, nTacticParameter1) == FALSE)
                nResult = MK_FAILURE;
            break;
        }
        case AI_BASE_CONDITION_USING_ATTACK_TYPE:
        case AI_BASE_CONDITION_TARGET_USING_ATTACK_TYPE_FOLLOWER:
        {
            if( _AT_AI_SubCondition_UsingAttackType(oCreature, nTacticParameter1) == FALSE
            || (nTacticParameter2 != 0 && AT_IsAtFlank(GetAttackTarget(oCreature)) == FALSE))
            {
                nResult = MK_FAILURE;
            }
            break;
        }
        case AI_BASE_CONDITION_USING_RANGED_ATTACKS_AT_RANGE:
        {
            int nAttackType = AI_ATTACK_TYPE_RANGED | AI_ATTACK_TYPE_MAGIC;
            if( _AT_AI_SubCondition_UsingAttackType(oCreature, nAttackType) == FALSE
            ||  _MK_AI_IsAtRange(oCreature, nTacticParameter1) == FALSE)
            {
                nResult = MK_FAILURE;
            }
            break;
        }
        case AI_BASE_CONDITION_ENEMY_AI_TARGET_AT_RANGE:
        case AI_BASE_CONDITION_FOLLOWER_AI_TARGET_AT_RANGE:
        {
            if(_MK_AI_SubCondition_AtRange(oCreature, nTacticParameter1) == FALSE)
            {
                nResult = MK_FAILURE;
            }
            break;
        }
        case MK_BASE_CONDITION_AFFECTED_BY_SPELL:
        case MK_BASE_CONDITION_AFFECTED_BY_TALENT:
        {
            if(MK_IsAffectedByAbility(oCreature, nTacticParameter2) == FALSE)
            {
                nResult = MK_FAILURE;
            }
            break;
        }
        default:
        {
            nResult = MK_UNPROCESSED;
        }
    }

    return nResult;
}

/** @brief Check whether hostile creature is satysfying given list of conditions.
* This is auxiliary function for choosing enemy using multiple conditions.
* If you want to test single condition then use dedicated function instead.
*
* @param oEnemy             - hostile creature to test conditions for
* @param arTacticID         - id of tactic slot, required to process GeneratePerFollower conditions
* @param arBaseCondition    - id of condition (see tacticsbaseconditions.gda). Determines condition function that will be used.
* @param arTacticParameter1 - meaning depends on condition (see tacticsconditions.gda). Parameter for condition function.
* @param arTacticParameter2 - meaning depends on condition (see tacticsconditions.gda). Parameter for condition function.
* @returns  True or False
*/
int IsHostileCreatureSatysfyingConditionsList(object oEnemy, int[] arTacticID, int[] arBaseCondition, int[] arTacticParameter1, int[] arTacticParameter2)
{
    int i;
    int nSize = GetArraySize(arTacticID);

    for (i = 0; i < nSize; i++)
    {
        if (IsHostileCreatureSatysfyingCondition(oEnemy, arTacticID[i], arBaseCondition[i], arTacticParameter1[i], arTacticParameter2[i]) == FALSE)
            return FALSE;
    }

    return TRUE;
}

/** @brief Check whether hostile creature is satysfying given condition.
* This is auxiliary function for choosing enemy using multiple conditions.
* If you want to test single condition then use dedicated function instead.
*
* @param oEnemy            - hostile creature to test condition for
* @param nTacticID         - id of tactic slot, required to process GeneratePerFollower conditions
* @param nBaseCondition    - id of condition (see tacticsbaseconditions.gda). Determines condition function that will be used.
* @param nTacticParameter1 - meaning depends on condition (see tacticsconditions.gda). Parameter for condition function.
* @param nTacticParameter2 - meaning depends on condition (see tacticsconditions.gda). Parameter for condition function.
* @returns  True or False
*/
int IsHostileCreatureSatysfyingCondition(object oEnemy, int nTacticID, int nBaseCondition, int nTacticParameter1, int nTacticParameter2)
{
    int nIncludeSummoned = FALSE;
    int nResult = FALSE;

    int nConditionCheck = IsCreatureSatysfyingTargetIndependentCondition(oEnemy, nBaseCondition, nTacticParameter1, nTacticParameter2);

    if (nConditionCheck == MK_SUCCESS)
        nResult = TRUE;
    else if (nConditionCheck == MK_FAILURE)
        nResult = FALSE;
    else if (nConditionCheck == MK_UNPROCESSED)
    {
        switch(nBaseCondition)
        {
            case AI_BASE_CONDITION_BEING_ATTACKED_BY_ATTACK_TYPE:
            {
                object[] arAttackers = _MK_AI_GetFollowersInParty(TRUE, nIncludeSummoned);
                int nAttackersNum = GetArraySize(arAttackers);

                //TODO: refactoring needed for 'not being attacked'

                if (nTacticParameter2 == 0)
                {
                    nResult = FALSE;
                    int i;
                    for (i = 0; i < nAttackersNum; i++)
                    {
                        if (_MK_AI_IsAttackedByAttackType(arAttackers[i], oEnemy, nTacticParameter1) == TRUE)
                        {
                            nResult = TRUE;
                            break;
                        }
                    }
                }
                else
                {
                    nResult = TRUE;
                    int i;
                    for (i = 0; i < nAttackersNum; i++)
                    {
                        if (_MK_AI_IsAttackedByAttackType(arAttackers[i], oEnemy, nTacticParameter1) == TRUE)
                        {
                            nResult = FALSE;
                            break;
                        }
                    }
                }
                break;
            }
            /*case AT_BASE_CONDITION_NOT_BEING_ATTACKED_BY_ATTACK_TYPE:
            {
             //TODO:
             break;
            }*/
            case AI_BASE_CONDITION_TARGET_HAS_RANK:
            {
                if(_AT_AI_SubCondition_HasRank(oEnemy, nTacticParameter1) == TRUE)
                    nResult = TRUE;
                break;
            }
            case AI_BASE_CONDITION_ATTACKING_PARTY_MEMBER:
            {
                object oTarget = _AT_AI_GetRelatedPartyTarget(nTacticParameter1, nTacticID);
                if(GetAttackTarget(oEnemy) == oTarget)
                    nResult = TRUE;
                break;
            }
            default:
            {
                string sMsg = "Unknown Base Condition = " + IntToString(nBaseCondition);
                MK_Error(nTacticID, "IsHostileCreatureSatysfyingCondition", sMsg);
            }
        }
    }
    else
    {
        string sMsg = "Unknown Check Result = " + IntToString(nConditionCheck);
        MK_Error(nTacticID, "IsHostileCreatureSatysfyingCondition", sMsg);
    }

    #ifdef MK_DEBUG_MULTI_CONDITIONS
    string[] arCols;
    int nColNum = 0;

    arCols[nColNum++] = IntToString(nTacticID);
    arCols[nColNum++] = ObjectToStringName(oEnemy);
    arCols[nColNum++] = ObjectToString(oEnemy);
    arCols[nColNum++] = BaseConditionIdToString(nBaseCondition);
    arCols[nColNum++] = IntToString(nTacticParameter1);
    arCols[nColNum++] = IntToString(nTacticParameter2);
    arCols[nColNum++] = MkResultToString(nResult);
    MK_PrintToLog(ArStringToCsv(arCols));
    #endif

    return nResult;
}

/** @brief Check whether friendly creature is satysfying given list of conditions.
* This is auxiliary function for choosing enemy using multiple conditions.
* If you want to test single condition then use dedicated function instead.
*
* @param oEnemy             - friendly creature to test conditionss for
* @param arTacticID         - id of tactic slot, required to process GeneratePerFollower conditions
* @param arBaseCondition    - id of condition (see tacticsbaseconditions.gda). Determines condition function that will be used.
* @param arTacticParameter1 - meaning depends on condition (see tacticsconditions.gda). Parameter for condition function.
* @param arTacticParameter2 - meaning depends on condition (see tacticsconditions.gda). Parameter for condition function.
* @returns  True or False
*/
int IsFriendlyCreatureSatysfyingConditionsList(object oFriend, int[] arTacticID, int[] arBaseCondition, int[] arTacticParameter1, int[] arTacticParameter2)
{
    int i;
    int nSize = GetArraySize(arTacticID);

    for (i = 0; i < nSize; i++)
    {
        if (IsFriendlyCreatureSatysfyingCondition(oFriend, arTacticID[i], arBaseCondition[i], arTacticParameter1[i], arTacticParameter2[i]) == FALSE)
            return FALSE;
    }

    return TRUE;
}

/** @brief Check whether party member is satysfying given condition.
* This is auxiliary function for choosing party member using multiple conditions.
* If you want to test single condition then use dedicated function instead.
*
* @param oFriend           - follower or summoned creature to test condition for
* @param nTacticID         - id of tactic slot, required to process GeneratePerFollower conditions
* @param nBaseCondition    - id of condition (see tacticsbaseconditions.gda). Determines condition function that will be used.
* @param nTacticParameter1 - parameter for condition function. Meaning depends on condition (see tacticsconditions.gda).
* @param nTacticParameter2 - parameter for condition function. Meaning depends on condition (see tacticsconditions.gda).
* @returns  True or False
*/
int IsFriendlyCreatureSatysfyingCondition(object oFriend, int nTacticID, int nBaseCondition, int nTacticParameter1, int nTacticParameter2)
{
    int nConditionCheck = IsCreatureSatysfyingTargetIndependentCondition(oFriend, nBaseCondition, nTacticParameter1, nTacticParameter2);

    int nResult = FALSE;

    if (nConditionCheck == MK_SUCCESS)
        nResult = TRUE;
    else if (nConditionCheck == MK_FAILURE)
        nResult = FALSE;
    else if (nConditionCheck == MK_UNPROCESSED)
    {
        switch(nBaseCondition)
        {
            case AI_BASE_CONDITION_BEING_ATTACKED_BY_ATTACK_TYPE:
            {
                object[] arAttackers = _MK_AI_GetEnemies(oFriend);
                int nAttackersNum = GetArraySize(arAttackers);

                if (nTacticParameter1 == 0)
                {
                    nResult = FALSE;
                    int i;
                    for (i = 0; i < nAttackersNum; i++)
                    {
                        if (_MK_AI_IsAttackedByAttackType(arAttackers[i], oFriend, nTacticParameter1) == TRUE)
                        {
                            nResult = TRUE;
                            break;
                        }
                    }
                }
                else
                {
                    nResult = TRUE;
                    int i;
                    for (i = 0; i < nAttackersNum; i++)
                    {
                        if (_MK_AI_IsAttackedByAttackType(arAttackers[i], oFriend, nTacticParameter1) == TRUE)
                        {
                            nResult = FALSE;
                            break;
                        }
                    }
                }
                break;
            }
            /*case AT_BASE_CONDITION_NOT_BEING_ATTACKED_BY_ATTACK_TYPE:
            {
             //TODO:
             break;
            }*/
            default:
            {
                string sMsg = "Unknown Base Condition = " + IntToString(nBaseCondition);
                MK_Error(nTacticID, "IsFriendlyCreatureSatysfyingCondition", sMsg);
            }
        }
    }
    else
    {
        string sMsg = "Unknown Check Result = " + IntToString(nConditionCheck);
        MK_Error(nTacticID, "IsFriendlyCreatureSatysfyingCondition", sMsg);
    }

    #ifdef MK_DEBUG_MULTI_CONDITIONS
    string[] arCols;
    int nColNum = 0;

    arCols[nColNum++] = IntToString(nTacticID);
    arCols[nColNum++] = ObjectToStringName(oFriend);
    arCols[nColNum++] = ObjectToString(oFriend);
    arCols[nColNum++] = BaseConditionIdToString(nBaseCondition);
    arCols[nColNum++] = IntToString(nTacticParameter1);
    arCols[nColNum++] = IntToString(nTacticParameter2);
    arCols[nColNum++] = MkResultToString(nResult);
    MK_PrintToLog(ArStringToCsv(arCols));
    #endif

    return nResult;
}


/** @brief Check whether given enemy is valid for any ability from provided ability list.
* @param oEnemy
* @param arAbilities
* @param arAbilitiesTargetType
* @returns  True or False
*/
int MK_IsHostileCreatureValidForAnyAbility(object oEnemy, int[] arAbilities, int[] arAbilitiesTargetType)
{
    int i;
    int nSize = GetArraySize(arAbilities);

    if (nSize == 0)
        return TRUE;

    int nResult = FALSE;

    for (i = 0; i < nSize; i++)
    {
        int nAbility = arAbilities[i];
        int nAbilityTargetType = arAbilitiesTargetType[i];

        if (_AT_AI_IsEnemyValidForAbility(oEnemy, AI_COMMAND_USE_ABILITY, nAbility, nAbilityTargetType))
        {
            nResult = TRUE;
            break;
        }
    }

    #ifdef MK_DEBUG_MULTI_CONDITIONS
    string[] arCols;
    int nColNum = 0;

    string sBooleanExpression = "";
    for (i = 0; i < nSize; i++)
        sBooleanExpression = AbilityIdToString(arAbilities[i]) + "(" + IntToString(arAbilities[i]) + ")" + " || ";
    sBooleanExpression = StringLeft(sBooleanExpression, GetStringLength(sBooleanExpression)-1);

    arCols[nColNum++] = ObjectToStringName(oEnemy);
    arCols[nColNum++] = ObjectToString(oEnemy);
    arCols[nColNum++] = sBooleanExpression;
    arCols[nColNum++] = MkResultToString(nResult);
    MK_PrintToLog(ArStringToCsv(arCols));
    #endif

    return nResult;
}

/** @brief Check whether given friendly creature is valid for any ability from provided ability list.
* @param oFriend
* @param arAbilities
* @param arAbilitiesTargetType
* @returns  True or False
*/
int MK_IsFriendlyCreatureValidForAnyAbility(object oFriend, int[] arAbilities, int[] arAbilitiesTargetType)
{
    int i;
    int nSize = GetArraySize(arAbilities);

    if (nSize == 0)
        return TRUE;

    int nResult = FALSE;

    for (i = 0; i < nSize; i++)
    {
        int nAbility = arAbilities[i];
        int nAbilityTargetType = arAbilitiesTargetType[i];

        if (_MK_AI_IsFriendValidForAbility(oFriend, AI_COMMAND_USE_ABILITY, nAbility, nAbilityTargetType))
        {
            nResult = TRUE;
            break;
        }
    }

    #ifdef MK_DEBUG_MULTI_CONDITIONS
        string[] arCols;
        int nColNum = 0;

        string sBooleanExpression = "";
        for (i = 0; i < nSize; i++)
            sBooleanExpression = AbilityIdToString(arAbilities[i]) + "(" + IntToString(arAbilities[i]) + ")" + " || ";
        sBooleanExpression = StringLeft(sBooleanExpression, GetStringLength(sBooleanExpression)-1);

        arCols[nColNum++] = ObjectToStringName(oFriend);
        arCols[nColNum++] = ObjectToString(oFriend);
        arCols[nColNum++] = sBooleanExpression;
        arCols[nColNum++] = MkResultToString(nResult);
        MK_PrintToLog(ArStringToCsv(arCols));
    #endif

    return nResult;
    return FALSE;
}

/** @brief
* This is auxiliary function for IsValidForAbility condition
* @returns Ability ID
*/
int _MK_AbilityIdFromTacticParameters(int nTacticParameter1, int nTacticParameter2)
{
    return nTacticParameter2;//(nTacticParameter1 * 100 + nTacticParameter2);
}

//==============================================================================
//                 DEFINITIONS : SortBy Sorting Functions
//==============================================================================

/** @brief Return array of valid Enemies according to input list of preferences.
* See MK_PREFERENCES_ for list of valid preferences.
*  @param arPreferencesIds list of preferences
*  @param outEnemies output array of enemies
*  @returns number of preferred enemies at the beginning of the output array
*  @author MkBot
**/
int _MK_AI_GetEnemiesByPreferences(int[] arPreferencesIds, object[] outEnemies)
{
    //-------- Cache
    object oSelfTarget       = GetAttackTarget(OBJECT_SELF);
    object oHeroTarget       = GetAttackTarget(GetHero());
    object oControlledTarget = GetAttackTarget(GetMainControlled());

    //-------- Settings
    int nCheckLiving    = TRUE;
    int nCheckPerceived = TRUE;

    int nExcludeSelfTarget       = FALSE;
    //int nExcludeFollowerTarget = FALSE;
    int nExcludeHeroTarget       = FALSE;
    int nExcludeControlledTarget = FALSE;
    int nExcludeSleepRoot        = TRUE;

    //--------
    int i;
    int nOutputSize = 0;
    int nPreferencesSize = GetArraySize(arPreferencesIds);
    #ifdef MK_DEBUG
    _MK_PrintToLogIntegers(arPreferencesIds);
    #endif

    for (i = 0; i < nPreferencesSize; i++)
    {
        switch(arPreferencesIds[i])
        {
            case MK_PREFERENCES_PREFER_SELF_TARGET:
            {
                if (_AT_AI_IsEnemyValid(oSelfTarget, nCheckLiving, nCheckPerceived) == TRUE)
                {
                    outEnemies[nOutputSize++] = oSelfTarget;
                    nExcludeSelfTarget = TRUE;
                }
                break;
            }
            case MK_PREFERENCES_PREFER_FOLLOWER_TARGET:
            {
                //TODO:MK_PREFERENCES_PREFER_FOLLOWER_TARGET
                break;
            }
            case MK_PREFERENCES_PREFER_HERO_TARGET:
            {
                if (_AT_AI_IsEnemyValid(oHeroTarget, nCheckLiving, nCheckPerceived) == TRUE)
                {
                    outEnemies[nOutputSize++] = oHeroTarget;
                    nExcludeHeroTarget = TRUE;
                }
                break;
            }
            case MK_PREFERENCES_PREFER_CONTROLLED_TARGET:
            {
                if (_AT_AI_IsEnemyValid(oControlledTarget, nCheckLiving, nCheckPerceived) == TRUE)
                {
                    outEnemies[nOutputSize++] = oControlledTarget;
                    nExcludeControlledTarget = TRUE;
                }
                break;
            }
            case MK_PREFERENCES_EXCLUDE_SELF_TARGET:
            {
                nExcludeSelfTarget = TRUE;
                break;
            }
            case MK_PREFERENCES_EXCLUDE_FOLLOWER_TARGET:
            {
                //TODO:MK_PREFERENCES_EXCLUDE_FOLLOWER_TARGET
                break;
            }
            case MK_PREFERENCES_EXCLUDE_HERO_TARGET:
            {
                nExcludeHeroTarget = TRUE;
                break;
            }
            case MK_PREFERENCES_EXCLUDE_CONTROLLED_TARGET:
            {
                nExcludeControlledTarget = TRUE;
                break;
            }
            case MK_PREFERENCES_INCLUDE_SLEEP_ROOT_TARGET:
            {
                nExcludeSleepRoot = FALSE;
            }
            case MK_PREFERENCES_INCLUDE_DEAD_TARGET:
            {
                nCheckLiving = FALSE;
                break;
            }
            default:
            {
                string sMsg = "[_MK_AI_GetEnemiesByPreferences] ERROR: Unknown Preference Id= " + IntToString(arPreferencesIds[i]);
                DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, 0xFF0000, 5.0);
                MK_PrintToLog(sMsg);
                break;
            }
        } // switch
    } // for

    object[] arEnemies = GetNearestObjectByHostility(OBJECT_SELF,
                                                     TRUE,
                                                     OBJECT_TYPE_CREATURE,
                                                     AT_MAX_ENEMIES_NEAREST,
                                                     nCheckLiving,
                                                     nCheckPerceived,
                                                     FALSE);

    int nEnemiesSize = GetArraySize(arEnemies);
    int nPreferredCount = nOutputSize;
    #ifdef MK_DEBUG
    MK_PrintToLog("nPreferredCount = " + IntToString(nPreferredCount));
    _MK_PrintToLogCreatures(arEnemies);
    _MK_PrintToLogCreatures(outEnemies);
    #endif

    for (i = 0; i < nEnemiesSize; i++)
    {
        if (nExcludeSelfTarget == TRUE && arEnemies[i] == oSelfTarget)
            continue;
        //TODO: nExcludeFollowerTarget
        //if (nExcludeFollowerTarget == TRUE && )
        //    continue;
        if (nExcludeHeroTarget == TRUE && arEnemies[i] == oHeroTarget)
            continue;
        if (nExcludeControlledTarget == TRUE && arEnemies[i] == oControlledTarget)
            continue;
        if (nExcludeSleepRoot == TRUE && _MK_AI_IsSleepRoot(arEnemies[i]) == TRUE)
            continue;

        if (_AT_AI_IsEnemyValid(arEnemies[i], nCheckLiving, nCheckPerceived) == TRUE)
            outEnemies[nOutputSize++] = arEnemies[i];
    }
    #ifdef MK_DEBUG
    _MK_PrintToLogCreatures(outEnemies);
    #endif
    return nPreferredCount;

}

/** @brief
*
*/
object[] _MK_AI_GetEnemiesSortedBy(int[] arSortIds, int[] arPreferencesIds)
{
    object[] arEnemies;
    int nStartIndex = _MK_AI_GetEnemiesByPreferences(arPreferencesIds, arEnemies);
    InsertSort(arEnemies, arSortIds, nStartIndex);

    #ifdef MK_DEBUG
    _MK_PrintToLogCreatures(arEnemies);
    #endif
    return arEnemies;
}

/** @brief Return array of valid Followers according to input list of preferences.
* See MK_PREFERENCES_ for list of valid preferences.
*  @param arPreferencesIds list of preferences
*  @param outFollowers output array of followers
*  @returns number of preferred followers at the beginning of the output array
*  @author MkBot
**/
int _MK_AI_GetFriendsByPreferences(int[] arPreferencesIds, object[] outFollowers)
{
    //-------- Cache
    object oHero       = GetHero();
    object oControlled = GetMainControlled();

    //-------- Settings
    int nCheckLiving    = TRUE;
    int nCheckPerceived = FALSE;

    int nExcludeSelf       = FALSE;
    //int nExcludeFollower = FALSE;
    int nExcludeHero       = FALSE;
    int nExcludeControlled = FALSE;
    int nExcludeSummoned   = FALSE;

    //--------
    int i;
    int nOutputSize = 0;
    int nPreferencesSize = GetArraySize(arPreferencesIds);
    #ifdef MK_DEBUG
    _MK_PrintToLogIntegers(arPreferencesIds);
    #endif

    for (i = 0; i < nPreferencesSize; i++)
    {
        int nTacticId = 0;
        if (arPreferencesIds[i] < 0)
        {
            nTacticId = -1 * arPreferencesIds[i];
            arPreferencesIds[i] = MK_PREFERENCES_PREFER_FOLLOWER;
        }

        switch (arPreferencesIds[i])
        {
            case MK_PREFERENCES_PREFER_SELF:
            {
                outFollowers[nOutputSize++] = OBJECT_SELF;
                nExcludeSelf = TRUE;
                break;
            }
            case MK_PREFERENCES_PREFER_FOLLOWER:
            {
                //TODO: MK_PREFERENCES_PREFER_FOLLOWER
                //object oTarget = GetTacticTargetObject(OBJECT_SELF, nTacticId)
                //if (_AT_AI_IsAllyValid(oTarget, nCheckLiving, nCheckPerceived))
                //    outFollowers[nOutputSize++] = oTarget;
                break;
            }
            case MK_PREFERENCES_PREFER_HERO:
            {
                if (_AT_AI_IsAllyValid(oHero, nCheckLiving, nCheckPerceived))
                {
                    outFollowers[nOutputSize++] = oHero;
                    nExcludeHero = TRUE;
                }
                break;
            }
            case MK_PREFERENCES_PREFER_CONTROLLED:
            {
                if (_AT_AI_IsAllyValid(oControlled, nCheckLiving, nCheckPerceived))
                {
                    outFollowers[nOutputSize++] = oControlled;
                    nExcludeControlled = TRUE;
                }
                break;
            }
            case MK_PREFERENCES_EXCLUDE_SELF:
            {
                nExcludeSelf = TRUE;
                break;
            }
            case MK_PREFERENCES_EXCLUDE_FOLLOWER:
            {
                //TODO: MK_PREFERENCES_EXCLUDE_FOLLOWER:
                break;
            }
            case MK_PREFERENCES_EXCLUDE_HERO:
            {
                nExcludeHero = TRUE;
                break;
            }
            case MK_PREFERENCES_EXCLUDE_CONTROLLED:
            {
                nExcludeControlled = TRUE;
                break;
            }
            case MK_PREFERENCES_EXCLUDE_SUMMONED:
            {
                nExcludeSummoned = TRUE;
                break;
            }
            case MK_PREFERENCES_INCLUDE_DEAD:
            {
                nCheckLiving = FALSE;
                break;
            }
            default:
            {
                string sMsg = "[_MK_AI_GetFollowersByPreferences] ERROR: Unknown Preference Id= " + IntToString(arPreferencesIds[i]);
                DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, 0xFF0000, 5.0);
                MK_PrintToLog(sMsg);
                break;
            }
        } // switch
    } // for

    object[] arPartyPool = GetPartyPoolList();
    int nPoolSize = GetArraySize(arPartyPool);
    int nPreferredCount = nOutputSize;
    #ifdef MK_DEBUG
    MK_PrintToLog("nPreferredCount = " + IntToString(nPreferredCount));
    _MK_PrintToLogCreatures(arPartyPool);
    _MK_PrintToLogCreatures(outFollowers);
    #endif

    for (i = 0; i < nPoolSize; i++)
    {
        if (nExcludeSelf == TRUE && arPartyPool[i] == OBJECT_SELF)
            continue;
        //TODO: nExcludeFollower
        //if (nExcludeFollower == TRUE && )
        //    continue;
        if (nExcludeHero == TRUE && arPartyPool[i] == oHero)
            continue;
        if (nExcludeControlled == TRUE && arPartyPool[i] == oControlled)
            continue;
        if (nExcludeSummoned == TRUE && IsSummoned(arPartyPool[i]) == TRUE)
            continue;

        if (_AT_AI_IsAllyValid(arPartyPool[i], nCheckLiving, nCheckPerceived) == TRUE)
            outFollowers[nOutputSize++] = arPartyPool[i];
    }
    #ifdef MK_DEBUG
    _MK_PrintToLogCreatures(outFollowers);
    #endif
    return nPreferredCount;
}

/** @brief
*
*/
object[] _MK_AI_GetFriendsSortedBy(int[] arSortIds, int[] arPreferencesIds)
{
    object[] arFriends;
    int nStartIndex = _MK_AI_GetFriendsByPreferences(arPreferencesIds, arFriends);

    InsertSort(arFriends, arSortIds, nStartIndex);
    #ifdef MK_DEBUG
    _MK_PrintToLogCreatures(arFriends);
    #endif
    return arFriends;
}

//==============================================================================
//                      DEFINITIONS : Multi Condition Search Functions
//==============================================================================

int MK_IsMultiConditionTactic(struct TacticRow tTactic)
{
    int nResult = tTactic.nTargetTypeID == MK_TARGET_TYPE_MULTI_CONDITION_SETTINGS ||
                  tTactic.nTargetTypeID == MK_TARGET_TYPE_MULTI_CONDITION_ENEMY  ||
                  tTactic.nTargetTypeID == MK_TARGET_TYPE_MULTI_CONDITION_FRIEND;
    return nResult;
}

/** @brief Checks whether syntax of tactics for MultiCondition is valid
*
* Syntaz for Enemies : [MultiCondition Settings : Sort By] [MultiCondition Settings : Preferences Enemies] [MultiCondition Enemy  : Base Condition]
* Syntaz for Friends : [MultiCondition Settings : Sort By] [MultiCondition Settings : Preferences Friends] [MultiCondition Friend : Base Condition]
*
* @returns TRUE or FALSE
*/
int MK_CheckMultiConditionSyntax(struct TacticRow tTacticCurrent, struct TacticRow tTacticPrevious)
{
    if (!MK_IsMultiConditionTactic(tTacticCurrent))
        return FALSE;

    if (IsTacticEmpty(tTacticPrevious))
        return TRUE;

    switch (tTacticCurrent.nTargetTypeID)
    {
        case MK_TARGET_TYPE_MULTI_CONDITION_ENEMY:
        {
            if (tTacticPrevious.nTargetTypeID == MK_TARGET_TYPE_MULTI_CONDITION_FRIEND)
                return FALSE;
            if(tTacticPrevious.nBaseConditionID == MK_BASE_CONDITION_PREFERENCES_FRIEND)
                return FALSE;
            break;
        }
        case MK_TARGET_TYPE_MULTI_CONDITION_FRIEND:
        {
            if (tTacticPrevious.nTargetTypeID == MK_TARGET_TYPE_MULTI_CONDITION_ENEMY)
                return FALSE;
            if(tTacticPrevious.nBaseConditionID == MK_BASE_CONDITION_PREFERENCES_ENEMY)
                return FALSE;
            break;
        }
        case MK_TARGET_TYPE_MULTI_CONDITION_SETTINGS:
        {
            if (tTacticPrevious.nTargetTypeID != MK_TARGET_TYPE_MULTI_CONDITION_SETTINGS)
                return FALSE;
            if (tTacticPrevious.nBaseConditionID == MK_BASE_CONDITION_PREFERENCES_ENEMY &&
                tTacticCurrent.nBaseConditionID != MK_BASE_CONDITION_PREFERENCES_ENEMY)
                return FALSE;
            if (tTacticPrevious.nBaseConditionID == MK_BASE_CONDITION_PREFERENCES_FRIEND &&
                tTacticCurrent.nBaseConditionID != MK_BASE_CONDITION_PREFERENCES_FRIEND)
                return FALSE;
            break;
        }
        default:
        {
            return FALSE;
        }
    }


    if (tTacticCurrent.nTargetTypeID == MK_TARGET_TYPE_MULTI_CONDITION_ENEMY &&
        tTacticPrevious.nTargetTypeID == MK_TARGET_TYPE_MULTI_CONDITION_FRIEND)
        return FALSE;

    if (tTacticCurrent.nTargetTypeID == MK_TARGET_TYPE_MULTI_CONDITION_FRIEND &&
        tTacticPrevious.nTargetTypeID == MK_TARGET_TYPE_MULTI_CONDITION_ENEMY )
        return FALSE;

    return TRUE;
}

void MK_Print_MultiConditionSyntaxError(struct TacticRow tTactic)
{
    string sMsg = "[HandleMulticondition] TacticID = " + IntToString(tTactic.nTacticID) + " SYNTAX ERROR";
    DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, 0xFF0000, 5.0);
    MK_PrintToLog(sMsg);
    MK_PrintToLog(TacticRowToString(tTactic));
}

int MK_AI_HandleMultiCondition(struct TacticRow tTactic, int nTacticsNum, int nUseGUITables, int nPackageTable)
{
    int nTacticCount = 1;

    struct TacticRow tTacticPrevious = EmptyTactic();
    struct TacticRow tTacticCurrent = tTactic;

    int nSortTypesCount = 0;
    int[] arSortTypes;

    int nPreferencesCount = 0;
    int[] arPreferences;

    int nConditionsCount = 0;
    int[] arTacticID;
    int[] arBaseCondition;
    int[] arConditionParameter1;
    int[] arConditionParameter2;

    int nAbilitiesCount = 0;
    int[] arAbilities;
    int[] arAbilitiesTargetType;

    while (tTacticCurrent.nTacticID <= nTacticsNum)
    {
        #ifdef MK_DEBUG_MULTI_CONDITIONS
        MK_PrintToLog(TacticRowToString(tTacticCurrent));
        #endif

        if(!MK_CheckMultiConditionSyntax(tTacticCurrent, tTacticPrevious))
        {
            MK_Print_MultiConditionSyntaxError(tTacticCurrent);
            return 0;
        }

        switch (tTacticCurrent.nBaseConditionID)
        {
            case AI_BASE_CONDITION_ANY:
            {
                //Empty condition.
                //It is required to allow user to save Enemy/Friend in cases when
                //he wants to use MultiCondition Settings only.
                break;
            }
            case MK_BASE_CONDITION_SORT_BY:
            {
                arSortTypes[nSortTypesCount] = tTacticCurrent.nConditionParameter1;
                nSortTypesCount++;
                break;
            }
            case MK_BASE_CONDITION_PREFERENCES_ENEMY:
            case MK_BASE_CONDITION_PREFERENCES_FRIEND:
            {
                arPreferences[nPreferencesCount] = tTacticCurrent.nConditionParameter1;
                nPreferencesCount++;
                break;
            }
            case MK_BASE_CONDITION_IS_VALID_FOR_ABILITY:
            {
                arAbilities[nAbilitiesCount]           = tTactic.nSubCommandID;
                arAbilitiesTargetType[nAbilitiesCount] = tTactic.nCommandTargetType;
                nAbilitiesCount++;
                break;
            }
            default:
            {
                arTacticID[nConditionsCount]            = tTacticCurrent.nTacticID;
                arBaseCondition[nConditionsCount]       = tTacticCurrent.nBaseConditionID;
                arConditionParameter1[nConditionsCount] = tTacticCurrent.nConditionParameter1;
                arConditionParameter2[nConditionsCount] = tTacticCurrent.nConditionParameter2;
                nConditionsCount++;
                break;
            }
        }

        switch (tTacticCurrent.nCommandID)
        {
            case MK_COMMAND_SAVE_CONDITION:
            {
                //Save condition only. Nothing more.
                break;
            }
            /*
            case AI_COMMAND_USE_ABILITY:
            {
                //arAbilities[nAbilitiesCount]           = tTactic.nSubCommandID;
                //arAbilitiesTargetType[nAbilitiesCount] = tTactic.nCommandTargetType;
                //nAbilitiesCount++;

                arTacticID[nConditionsCount]            = tTacticCurrent.nTacticID;
                arBaseCondition[nConditionsCount]       = MK_BASE_CONDITION_IS_VALID_FOR_ABILITY;
                arConditionParameter1[nConditionsCount] = 0;
                arConditionParameter2[nConditionsCount] = tTacticCurrent.nSubCommandID;
                nConditionsCount++;
                break;
            }
            */
            case MK_COMMAND_SAVE_ENEMY:
            {
                object oTarget = OBJECT_INVALID;
                object[] arEnemies = _MK_AI_GetEnemiesSortedBy(arSortTypes, arPreferences);
                int nSize = GetArraySize(arEnemies);

                int i;
                for(i = 0; i < nSize; i++)
                {
                    if (IsHostileCreatureSatysfyingConditionsList(arEnemies[i], arTacticID, arBaseCondition, arConditionParameter1, arConditionParameter2) &&
                        MK_IsHostileCreatureValidForAnyAbility(arEnemies[i], arAbilities, arAbilitiesTargetType))
                    {
                        oTarget = arEnemies[i];
                        break;
                    }
                }

                #ifdef MK_DEBUG_MULTI_CONDITIONS
                string[] arCols;
                int nColNum = 0;

                arCols[nColNum++] = IntToString(tTacticCurrent.nTacticID);
                arCols[nColNum++] = ObjectToStringName(oTarget);
                arCols[nColNum++] = ObjectToString(oTarget);
                arCols[nColNum++] = CommandTypeIdToString(tTacticCurrent.nCommandID);
                MK_PrintToLog(ArStringToCsv(arCols));
                #endif

                MK_SetSavedEnemy(oTarget);
                return nTacticCount;
            }
            case MK_COMMAND_SAVE_FRIEND:
            {
                object oTarget = OBJECT_INVALID;
                object[] arFriends = _MK_AI_GetFriendsSortedBy(arSortTypes, arPreferences);
                int nSize = GetArraySize(arFriends);

                int i;
                for(i = 0; i < nSize; i++)
                {
                    if (IsFriendlyCreatureSatysfyingConditionsList(arFriends[i], arTacticID, arBaseCondition, arConditionParameter1, arConditionParameter2) &&
                        MK_IsFriendlyCreatureValidForAnyAbility(arFriends[i], arAbilities, arAbilitiesTargetType))
                    {
                        oTarget = arFriends[i];
                        break;
                    }
                }

                #ifdef MK_DEBUG_MULTI_CONDITIONS
                string[] arCols;
                int nColNum = 0;

                arCols[nColNum++] = IntToString(tTacticCurrent.nTacticID);
                arCols[nColNum++] = ObjectToStringName(oTarget);
                arCols[nColNum++] = ObjectToString(oTarget);
                arCols[nColNum++] = CommandTypeIdToString(tTacticCurrent.nCommandID);
                MK_PrintToLog(ArStringToCsv(arCols));
                #endif

                MK_SetSavedFriend(oTarget);
                return nTacticCount;
            }
            default:
            {
                string sMsg = "Unknown Command = " + IntToString(tTacticCurrent.nCommandID);
                MK_Error(tTacticCurrent.nTacticID, "HandleMulticondition", sMsg);

                return 0;
            }
        }

        tTacticPrevious = tTacticCurrent;
        tTacticCurrent = GetTacticRowFromTable(tTacticCurrent.nTacticID + 1, nUseGUITables, nPackageTable);
        nTacticCount++;

        #ifdef MK_DEBUG_TACTIC_ROW
        MK_PrintToLog(TacticRowToString(tTacticCurrent));
        #endif
    }

    MK_Print_MultiConditionSyntaxError(tTacticCurrent);
    return 0;
}

//void main(){}
#endif