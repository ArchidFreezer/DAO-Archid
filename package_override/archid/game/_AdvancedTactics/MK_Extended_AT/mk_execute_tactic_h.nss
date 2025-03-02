#ifndef MK_AI_EXECUTE_TACTIC_H
#defsym MK_AI_EXECUTE_TACTIC_H

//==============================================================================
//                                MKBOT TODO
//==============================================================================
// AI_GetPartyAllowedToAttack is disabled. Party Members attacks Enemy at sight
// regardless of their behavior


//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_ai_conditions_nochange_h"
#include "at_tools_ai_h"
#include "at_tools_aoe_h"
#include "at_tools_geometry_h"
#include "at_tools_ai_constants_h"
#include "at_tools_log_h"

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
#include "mk_condition_mostdamaged_h"
#include "mk_condition_multicond_h"
#include "mk_condition_clustered_h"
#include "mk_cond_affected_ability_h"

/* MkBot */
#include "mk_constants_ai_h"
//#include "mk_ai_conditions_h"
#include "mk_commands_h"
#include "mk_add_command_h"
#include "mk_print_to_log_h"
#include "log_commands_h"
/* Talmud Storage*/
#include "talmud_storage_h"


//==============================================================================
//                              TACTIC TEMPLATE
//==============================================================================
//  [Target]:[BaseCondition]+[SubCondition] -> [Command]+[SubCommand]
//  We will call such a set a Tactic Instruction.

//==============================================================================
//                                DECLARATIONS
//==============================================================================
int _MK_AI_ExecuteTactic(struct TacticRow tTactic, object oLastTarget, int nLastCommand, int nLastCommandStatus, int nLastSubCommand);
command MK_DisarmTraps();
command MK_PickLock();

//==============================================================================
//                                DEFINITIONS
//==============================================================================

/** @brief Adds a new command to OBJECT_SELF's Command Queue  based on given Tactic Instruction.
*
* All Tactic Instructions are processed here. For given Tactic Instruction, Condition
* is evaluate and, if True, Command is added to Command Queue of OBJECT_SELF.
* In order to add a new condition you must create a proper function and this
* function must be called here.
*
* @param tTacitc Tactic Row struct that contains all tactic's data from GUI/2da table
* @param nLastCommand ID of last executed command
* @param nLastCommandStatus result of last command
*/

int _MK_AI_ExecuteTactic(struct TacticRow tTactic, object oLastTarget, int nLastCommand, int nLastCommandStatus, int nLastSubCommand)
{
    string FUNCTION_NAME = "_MK_AI_ExecuteTactic"; //pseudo-const for logging purposes

    if (!IsTacticRowValid(tTactic))
        return FALSE;

    int nTacticID = tTactic.nTacticID;

    string sTacticItemTag = tTactic.sAbilitySourceItem;

    int nTacticTargetType = tTactic.nTargetTypeID;
    int nTacticCondition  = tTactic.nSubConditionID;
    int nTacticCommand    = tTactic.nCommandID;
    int nTacticSubCommand = tTactic.nSubCommandID;

    int nTacticCondition_Base = tTactic.nBaseConditionID;

    int nTacticCondition_Parameter  = tTactic.nConditionParameter1;
    int nTacticCondition_Parameter2 = tTactic.nConditionParameter2;

    int nAbilityTargetType = tTactic.nCommandTargetType;

//------------------------------------------------------------------------------
//  Advanced Tactics:
//  Because some conditions involved 2 target, we will need to store 2 target
//  in some cases.
//  Bioware forget that after condition like [Enemy : Attacking party member],
//  it is possible to cast a spell on the concerned enemy or party member.
//------------------------------------------------------------------------------
    object[] arTargets;
    object oTarget;

//------------------------------------------------------------------------------
//          Search for [Target] that meets [Condition]
//------------------------------------------------------------------------------
//  Advanced Tactics:
//  The major part of the following switch/case has been rewrited to call
//  custom conditions functions.
//------------------------------------------------------------------------------
    #ifdef MK_DEBUG
    MK_PrintToLog("[ExecuteTactic] Section: Search for [Target] that meets [Condition]");
    #endif
    switch(nTacticCondition_Base)
    {
        case AI_BASE_CONDITION_HAS_EFFECT_APPLIED:
        {
            arTargets[0] = _MK_AI_Condition_GetCreatureWithAIStatus(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_HP_LEVEL:
        {
            arTargets[0] = _MK_AI_Condition_GetCreatureWithHPLevel(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_MANA_OR_STAMINA_LEVEL:
        {
            arTargets[0] = _MK_AI_Condition_GetCreatureWithManaStaminaLevel(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_MOST_DAMAGED_IN_PARTY:
        {
            arTargets[0] = _MK_AI_Condition_GetNthMostDamagedCreatureInGroup(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_CLUSTERED_WITH_SAME_GROUP:
        {
            arTargets[0] = _MK_AI_Condition_GetEnemyClusteredWithSameGroup(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_MOST_HATED_ENEMY:
        {
            // Missing target check with this condition
            arTargets[0] = _AT_AI_Condition_GetMostHatedEnemy();
            break;
        }
        case AI_BASE_CONDITION_NEAREST_VISIBLE:
        {
            arTargets[0] = _MK_AI_Condition_GetNearestVisibleCreature(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType);// MkBot fix: 4th and 5th were switched
            break;
        }
        case AI_BASE_CONDITION_NEAREST_RACE:
        {
            arTargets[0] = _MK_AI_Condition_GetNearestVisibleCreatureByRace(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_NEAREST_CLASS:
        {
            arTargets[0] = _MK_AI_Condition_GetNearestVisibleCreatureByClass(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_NEAREST_GENDER:
        {
            arTargets[0] = _MK_AI_Condition_GetNearestVisibleCreatureByGender(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_ATTACKING_PARTY_MEMBER:
        {
            // This is a multi target condition.
            // On who the ability will be cast depends on the valid target for
            // this ability.

            arTargets = _MK_AI_Condition_AttackingPartyMember(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_HAS_ANY_BUFF_EFFECT:
        {
            if( nTacticCondition_Parameter2 >= 0 )
            {
                arTargets[0] = _MK_Condition_HasBuff(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter, nTacticCondition_Parameter2 );
            }else
            {
                arTargets[0] = _MK_Condition_HasDebuff(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            }
            break;
        }
        case AI_BASE_CONDITION_ANY:
        {
            arTargets[0] = _MK_AI_Condition_GetAnyTarget(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType);
            break;
        }
        case MK_BASE_CONDITION_HAS_RESISTANCE:
        {
            arTargets[0] = _MK_Condition_HasResistance(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter, nTacticCondition_Parameter2);
            break;
        }
        case AI_BASE_CONDITION_HAS_ARMOR_TYPE:
        {
            arTargets[0] = _MK_AI_Condition_HasArmorType(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_MOST_ENEMIES_HAVE_ARMOR_TYPE:
        {
            arTargets[0] = _AT_AI_Condition_MostEnemiesHaveArmorType(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_ALL_ENEMIES_HAVE_ARMOR_TYPE:
        {
            arTargets[0] = _AT_AI_Condition_AllEnemiesHaveArmorType(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_TARGET_HAS_RANK:
        {
            arTargets[0] = _MK_AI_Condition_HasRank(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_BEING_ATTACKED_BY_ATTACK_TYPE:
        {
            // This is a multi target condition.
            // On who the ability will be cast depends on the valid target for
            // this ability.

            if( nTacticCondition_Parameter2 == 0)
                arTargets = _MK_AI_Condition_BeingAttackedByAttackType(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            else
                arTargets[0] = _MK_AI_Condition_NotBeingAttackedByAttackType(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_USING_ATTACK_TYPE:
        case AI_BASE_CONDITION_TARGET_USING_ATTACK_TYPE_FOLLOWER:
        {
            arTargets[0] = _MK_AI_Condition_UsingAttackType(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter, nTacticCondition_Parameter2);
            break;
        }
        case AI_BASE_CONDITION_MOST_ENEMIES_USING_ATTACK_TYPE:
        {
            arTargets[0] = _AT_AI_Condition_MostEnemiesUsingAttackType(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_ALL_ENEMIES_USING_ATTACK_TYPE:
        {
            arTargets[0] = _AT_AI_Condition_AllEnemiesUsingAttackType(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_AT_LEAST_X_ENEMIES_ARE_ALIVE:
        {
            arTargets[0] = _AT_AI_Condition_AtLeastXEnemiesAreAlive(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_AT_LEAST_X_CREATURES_ARE_DEAD:
        {
            arTargets[0] = _AT_AI_Condition_AtLeastXCreaturesAreDead(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_AT_LEAST_X_ALLIES_ARE_ALIVE:
        {
            arTargets[0] = _AT_AI_Condition_AtLeastXAlliesAreAlive(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter, nTacticCondition_Parameter2);
            break;
        }
        case AI_BASE_CONDITION_ENEMY_AI_TARGET_AT_RANGE:
        {
            arTargets[0] = _MK_AI_Condition_AtRange(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_FOLLOWER_AI_TARGET_AT_RANGE:
        {
            arTargets[0] = _MK_AI_Condition_AtRange(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_TARGET_AT_FLANK_LOCATION:
        {
            // No change
            arTargets[0] = _AI_Condition_GetTargetAtFlankLocation(nTacticCondition_Parameter, nTacticTargetType);
            break;
        }
        case AI_BASE_CONDITION_SURROUNDED_BY_TARGETS:
        {
            arTargets[0] = _AT_AI_Condition_SurroundedByAtLeastXEnemies(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_USING_RANGED_ATTACKS_AT_RANGE:
        {
            arTargets[0] = _MK_AI_Condition_UsingRangedWeaponsAtRange(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AI_BASE_CONDITION_PARTY_MEMBERS_TARGET:
        {
            arTargets[0] = _MK_AI_Condition_GetPartyMemberTarget(nTacticCommand, nTacticSubCommand, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        // Advanced Tactics
        case AT_BASE_CONDITION_HAS_DEBUFF_SPELL:
        {
            arTargets[0] = _MK_Condition_HasDebuff(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        //MkBot: Moved To AT_BASE_CONDITION_BEING_ATTACKED_BY_ATTACK_TYPE
        case AT_BASE_CONDITION_NOT_BEING_ATTACKED_BY_ATTACK_TYPE:
        {
            arTargets[0] = _MK_AI_Condition_NotBeingAttackedByAttackType(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case AT_BASE_CONDITION_GAME_MODE:
        {
            arTargets[0] = MK_Condition_GameMode(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter, nTacticCondition_Parameter2);
            break;
        }
        case AT_BASE_CONDITION_SUMMONING:
        {
            arTargets[0] = _AT_Condition_Summoning(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case MK_BASE_CONDITION_AT_LEAST_X_ENEMIES_AT_RANGE:
        {
            arTargets[0] = _MK_AI_Condition_AtLeastXEnemiesAtRange(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter, nTacticCondition_Parameter2);
            break;
        }
        case MK_BASE_CONDITION_AT_LEAST_X_ENEMIES_AT_RANGE_OF_PARTY:
        {
            arTargets[0] = _MK_AI_Condition_Party_AtLeastXEnemiesAtRange(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter, nTacticCondition_Parameter2);
            break;
        }
        case MK_BASE_CONDITION_AI_STATUS_NOT:
        {
            arTargets[0] = _MK_AI_Condition_GetCreatureWithAIStatusNot(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case MK_BASE_CONDITION_LOGIC:
        {
            arTargets[0] = _MK_AI_ConditionLogic(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter);
            break;
        }
        case MK_BASE_CONDITION_AFFECTED_BY_SPELL:
        case MK_BASE_CONDITION_AFFECTED_BY_TALENT:
        {
            arTargets[0] = MK_Condition_AffectedByAbility(nTacticCommand, nTacticSubCommand, nTacticTargetType, nTacticID, nAbilityTargetType, nTacticCondition_Parameter, nTacticCondition_Parameter2);
            break;
        }
        default:
        {
            string sMsg = "Unknown nTacticCondition_Base = " + IntToString(nTacticCondition_Base);
            MK_Error(nTacticID, FUNCTION_NAME, sMsg);

            return FALSE;
        }
    }

    oTarget = arTargets[0];
    #ifdef MK_DEBUG
    MK_PrintToLog("[ExecuteTactic] arTargets[0] = " + ObjectToString(arTargets[0]));
    MK_PrintToLog("[ExecuteTactic] arTargets[1] = " + ObjectToString(arTargets[1]));
    #endif
//------------------------------------------------------------------------------
//          MkBot: NON-Blocking Commands. COMMANDS THAT ALWAYS EXECUTE
//------------------------------------------------------------------------------
//  MkBot:
//  We have to process Save Secondary Target before Validity check because
//  we want to save OBJECT_INVALID if it occurs. It allows using Secondary
//  Target to simulate AND condition.
//------------------------------------------------------------------------------
    #ifdef MK_DEBUG
    MK_PrintToLog("[ExecuteTactic] Section: NON-Blocking Commands");
    #endif
    switch(nTacticCommand)
    {
        case MK_COMMAND_SAVE_ENEMY:
        {
            MK_SetSavedEnemy(oTarget);
            break;
        }
        case MK_COMMAND_SAVE_FRIEND:
        {
            MK_SetSavedFriend(oTarget);
            break;
        }
        case MK_COMMAND_CLEAR_SAVED_ENEMY:
        {
            MK_SetSavedEnemy(OBJECT_INVALID);
            oTarget = OBJECT_INVALID;
            break;
        }
        case MK_COMMAND_CLEAR_SAVED_FRIEND:
        {
            MK_SetSavedFriend(OBJECT_INVALID);
            oTarget = OBJECT_INVALID;
            break;
        }
        case MK_COMMAND_BOOL_1_STORE_COND_RESULT:
        {
            int nResult = IsObjectValid(oTarget);
            MK_AI_SetBoolean1(nResult);
            break;
        }
        case MK_COMMAND_BOOL_2_STORE_COND_RESULT:
        {
            int nResult = IsObjectValid(oTarget);
            MK_AI_SetBoolean2(nResult);
            break;
        }
        case MK_COMMAND_BOOL_1_STORE_NOT_COND_RESULT:
        {
            int nResult = !IsObjectValid(oTarget);
            MK_AI_SetBoolean1(nResult);
            break;
        }
        case MK_COMMAND_BOOL_2_STORE_NOT_COND_RESULT:
        {
            int nResult = !IsObjectValid(oTarget);
            MK_AI_SetBoolean2(nResult);
            break;
        }
        case MK_COMMAND_BOOL_1_STORE_COND_RESULT_AND_BOOL_1:
        {
            int nResult = IsObjectValid(oTarget) && MK_AI_GetBoolean1();
            MK_AI_SetBoolean1(nResult);
            break;
        }
        case MK_COMMAND_BOOL_2_STORE_COND_RESULT_AND_BOOL_2:
        {
            int nResult = IsObjectValid(oTarget) && MK_AI_GetBoolean2();
            MK_AI_SetBoolean2(nResult);
            break;
        }
        case MK_COMMAND_BOOL_1_STORE_COND_RESULT_OR_BOOL_1:
        {
            int nResult = IsObjectValid(oTarget) || MK_AI_GetBoolean1();
            MK_AI_SetBoolean1(nResult);
            break;
        }
        case MK_COMMAND_BOOL_2_STORE_COND_RESULT_OR_BOOL_2:
        {
            int nResult = IsObjectValid(oTarget) || MK_AI_GetBoolean2();
            MK_AI_SetBoolean2(nResult);
            break;
        }
        case MK_COMMAND_BOOL_1_STORE_NOT_COND_RESULT_AND_BOOL_1:
        {
            int nResult = !IsObjectValid(oTarget) && MK_AI_GetBoolean1();
            MK_AI_SetBoolean1(nResult);
            break;
        }
        case MK_COMMAND_BOOL_2_STORE_NOT_COND_RESULT_AND_BOOL_2:
        {
            int nResult = !IsObjectValid(oTarget) && MK_AI_GetBoolean2();
            MK_AI_SetBoolean2(nResult);
            break;
        }
        case MK_COMMAND_BOOL_1_STORE_NOT_COND_RESULT_OR_BOOL_1:
        {
            int nResult = !IsObjectValid(oTarget) || MK_AI_GetBoolean1();
            MK_AI_SetBoolean1(nResult);
            break;
        }
        case MK_COMMAND_BOOL_2_STORE_NOT_COND_RESULT_OR_BOOL_2:
        {
            int nResult = !IsObjectValid(oTarget) || MK_AI_GetBoolean2();
            MK_AI_SetBoolean2(nResult);
            break;
        }
    }

//------------------------------------------------------------------------------
//          Commands that are executed only if [Condition] == TRUE
//------------------------------------------------------------------------------
    if (IsObjectValid(oTarget) != TRUE)
    {
        #ifdef MK_DEBUG
        MK_PrintToLog("[ExecuteTactic] : Target provided by condition function is invalid -> return FALSE");
        #endif
        return FALSE;
    }

    #ifdef MK_DEBUG
    MK_PrintToLog("[ExecuteTactic] Section: Commands that are executed only if [Condition] == TRUE");
    #endif
    command cTacticCommand;
    switch(nTacticCommand)
    {
        // Advanced Tactics
        case MK_COMMAND_DISARM_TRAPS:
        {
            cTacticCommand = MK_DisarmTraps();
            break;
        }
        // Advanced Tactics
        case MK_COMMAND_PICK_LOCKS:
        {
            cTacticCommand = MK_PickLock();
            break;
        }
        // Advanced Tactics
        case AT_COMMAND_SWITCH_TO_WEAPON_SET_1:
        {
            cTacticCommand = CommandSwitchWeaponSet(0);

            break;
        }
        // Advanced Tactics
        case AT_COMMAND_SWITCH_TO_WEAPON_SET_2:
        {
            cTacticCommand = CommandSwitchWeaponSet(1);

            break;
        }
        // Advanced Tactics
        case AT_COMMAND_PAUSE:
        {
            cTacticCommand = _AT_Pause();

            break;
        }
        // Advanced Tactics
        case AT_COMMAND_BEHAVIOR_DEFAULT:
        case AT_COMMAND_BEHAVIOR_PASSIVE:
        case AT_COMMAND_BEHAVIOR_AGGRESSIVE:
        case AT_COMMAND_BEHAVIOR_RANGED:
        case AT_COMMAND_BEHAVIOR_CAUTIOUS:   
        case AT_COMMAND_BEHAVIOR_DEFENSIVE: 
        case AT_COMMAND_BEHAVIOR_PROTECTIVE:
        case AT_COMMAND_BEHAVIOR_TEMPLAR:
        case AT_COMMAND_BEHAVIOR_DEFAULT_STATIONARY:
        case AT_COMMAND_BEHAVIOR_PASSIVE_STATIONARY:
        case AT_COMMAND_BEHAVIOR_AGGRESSIVE_STATIONARY:
        case AT_COMMAND_BEHAVIOR_RANGED_STATIONARY:
        case AT_COMMAND_BEHAVIOR_CAUTIOUS_STATIONARY:   
        case AT_COMMAND_BEHAVIOR_DEFENSIVE_STATIONARY: 
        case AT_COMMAND_BEHAVIOR_PROTECTIVE_STATIONARY:
        case AT_COMMAND_BEHAVIOR_TEMPLAR_STATIONARY:
        {            
            int nBehaviorID = GetM2DAInt(TABLE_COMMAND_TYPES, "Type", nTacticCommand);
            cTacticCommand = _AT_ChangeBehavior(nBehaviorID);
            break;
        }
        case AI_COMMAND_USE_HEALTH_POTION_MOST:
        {
            // Advanced Tactics
            object oItem = _AT_AI_GetPotionByFilter(AI_POTION_TYPE_HEALTH, AI_POTION_LEVEL_MOST_POWERFUL);

            cTacticCommand = _AT_AI_GetPotionUseCommand(oItem);

            if (GetCommandType(cTacticCommand) == COMMAND_TYPE_INVALID)
                return FALSE;

            break;
        }
        case AI_COMMAND_USE_HEALTH_POTION_LEAST:
        {
            // Advanced Tactics
            object oItem = _AT_AI_GetPotionByFilter(AI_POTION_TYPE_HEALTH, AI_POTION_LEVEL_LEAST_POWERFUL);

            cTacticCommand = _AT_AI_GetPotionUseCommand(oItem);

            if (GetCommandType(cTacticCommand) == COMMAND_TYPE_INVALID)
                return FALSE;

            break;
        }
        case AI_COMMAND_USE_LYRIUM_POTION_MOST:
        {
            // Advanced Tactics
            object oItem = _AT_AI_GetPotionByFilter(AI_POTION_TYPE_MANA, AI_POTION_LEVEL_MOST_POWERFUL);

            cTacticCommand = _AT_AI_GetPotionUseCommand(oItem);

            if (GetCommandType(cTacticCommand) == COMMAND_TYPE_INVALID)
                return FALSE;

            break;
        }
        case AI_COMMAND_USE_LYRIUM_POTION_LEAST:
        {
            // Advanced Tactics
            object oItem = _AT_AI_GetPotionByFilter(AI_POTION_TYPE_MANA, AI_POTION_LEVEL_LEAST_POWERFUL);

            cTacticCommand = _AT_AI_GetPotionUseCommand(oItem);

            if (GetCommandType(cTacticCommand) == COMMAND_TYPE_INVALID)
                return FALSE;

            break;
        }
        case AI_COMMAND_SWITCH_TO_MELEE:
        {
            cTacticCommand = _AI_SwitchWeaponSet(AI_WEAPON_SET_MELEE);

            break;
        }
        case AI_COMMAND_SWITCH_TO_RANGED:
        {
            cTacticCommand = _AI_SwitchWeaponSet(AI_WEAPON_SET_RANGED);

            break;
        }
        case AI_COMMAND_JUMP_TO_LATER_TACTIC:
        {
            if ((nTacticSubCommand != -1)
            && (nTacticSubCommand <= nTacticID))
                return FALSE;

            // May be we should return nTacticSubCommand + 1 here to fix the
            // [Jump to] bug.

            return nTacticSubCommand;
        }
        case AI_COMMAND_USE_ITEM:
        {
            vector vNul;
            cTacticCommand = CommandUseAbility(nTacticSubCommand, OBJECT_SELF, vNul, -1.0, sTacticItemTag);

            break;
        }
        case AI_COMMAND_ACTIVATE_MODE:
        {
            cTacticCommand = CommandUseAbility(nTacticSubCommand, OBJECT_SELF);

            break;
        }
        case AI_COMMAND_DEACTIVATE_MODE:
        {
            cTacticCommand = CommandUseAbility(nTacticSubCommand, OBJECT_SELF);

            break;
        }
        case AI_COMMAND_WAIT:
        {
            int bQuick = FALSE;
            if (nTacticSubCommand == 1)
            {
                int nMoveStart = GetLocalInt(OBJECT_SELF, AI_WAIT_TIMER);
                int nCurrentTime = GetTime();

                if (nMoveStart != 0 && nCurrentTime - nMoveStart <= AI_WAIT_MIN_TIME)
                    return FALSE;

                SetLocalInt(OBJECT_SELF, AI_WAIT_TIMER, nCurrentTime);
                bQuick = TRUE;
            }

            cTacticCommand = _AT_AI_DoNothing(TRUE);

            break;
        }
        //MkBot:
        case MK_COMMAND_MOVE_TO_TARGET_AT_SHORT:
        {
            int nStandInFormation = !IsObjectHostile(OBJECT_SELF, oTarget);
            cTacticCommand = _MK_AI_MoveToTarget(oTarget, nLastCommandStatus, MK_RANGE_SHORT, nStandInFormation);
            break;
        }
        //MkBot:
        case MK_COMMAND_MOVE_TO_TARGET_AT_MEDIUM:
        {
            int nStandInFormation = FALSE;
            cTacticCommand = _MK_AI_MoveToTarget(oTarget, nLastCommandStatus, MK_RANGE_MEDIUM, nStandInFormation);
            break;
        }
        //MkBot:
        case MK_COMMAND_DEACTIVATE_ALMOST_ALL_MODAL_ABILITIES:
        {
            cTacticCommand = _MK_AI_DeactivateAlmostAllModalAbilities();
            break;
        }
        //MkBot:
        case MK_COMMAND_ADJUST_AMMO:
        {
            cTacticCommand = _MK_AI_AdjustAmmo();
            break;
        }
        //MkBot:
        case MK_COMMAND_UNEQUIP_AMMO:
        {
            cTacticCommand = _MK_AI_UnequipAmmo();
            break;
        }
        //MkBot:
        case MK_COMMAND_BREAK:
        {
            return -1; // -1 will break loop which goes through Tactics Table
        }
        //MkBot:
        case MK_COMMAND_SET_AS_TARGET:
        {
            object oCurrentTarget = GetAttackTarget(OBJECT_SELF);
            if( oTarget != oCurrentTarget )
                cTacticCommand = _MK_CommandUseAbility(MK_ABILITY_SET_AS_TARGET, oTarget);
            break;
        }
        //Advanced Tactics
        case AI_COMMAND_USE_ABILITY:
        case AI_COMMAND_ATTACK:
        {
            // Same targeting system for Attack

            if ((nTacticCommand == AI_COMMAND_USE_ABILITY)
            && (GetCreatureFlag(OBJECT_SELF, CREATURE_RULES_FLAG_AI_NO_ABILITIES) == TRUE))
                return FALSE;

            object oSelectedTarget = GetAttackTarget(OBJECT_SELF);

            // Advanced Tactics
            // All abilities can be cast at least on one of self, ally or enemy
            // All but one, spell ID 90061, only on Ground.

            // Here we are looking for a valid target.
            //   If the ability can be cast on the selected tactic target type,
            //   no problem.
            //   Else, we can try to find a valid target.

            switch(nTacticTargetType)
            {
                case MK_TARGET_TYPE_SAVED_ENEMY:
                case AI_TARGET_TYPE_ENEMY:
                case AI_TARGET_TYPE_MOST_HATED:
                case AT_TARGET_TYPE_TARGET:
                {
                    if (AT_IsHostileSelfAOE(nTacticCommand, nTacticSubCommand) == TRUE)
                    {
                        // Special case for Hostile AOE that need OBJECT_SELF for target.
                        // Both OBJECT_SELF and the enemy need to be Valid for the ability.

                        oTarget = OBJECT_SELF;

                        if (_AT_AI_IsSelfValidForAbility(nTacticCommand, nTacticSubCommand, nAbilityTargetType) != TRUE)
                            return FALSE;
                    }
                    else if ((nAbilityTargetType & TARGET_TYPE_HOSTILE_CREATURE) == 0)
                    {
                        // This is a fix to garantee that Self is not considered as an ally.
                         if (arTargets[1] == OBJECT_SELF)
                            arTargets[1] = OBJECT_INVALID;

                        // If we are in the case of a multi target condition, there
                        // could be something interesting in the second object variable.

                        if ((nAbilityTargetType & TARGET_TYPE_FRIENDLY_CREATURE)
                        && (_AT_AI_IsAllyValid(arTargets[1]) == TRUE)
                        && (_AT_AI_IsAllyValidForAbility(arTargets[1], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                            oTarget = arTargets[1];
                        // Else, self is the default target.
                        else if (((nAbilityTargetType & TARGET_TYPE_SELF) != 0)
                        && (_AT_AI_IsSelfValidForAbility(nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                            oTarget = OBJECT_SELF;
                        // Else, we are trying on the nearest ally.
                        else if (nAbilityTargetType & TARGET_TYPE_FRIENDLY_CREATURE)
                        {
                            oTarget = _MK_AI_Condition_GetAnyTarget(nTacticCommand, nTacticSubCommand, AI_TARGET_TYPE_ALLY, nTacticID, TARGET_TYPE_FRIENDLY_CREATURE);

                            if ((_AT_AI_IsAllyValid(oTarget) != TRUE)
                            || (_AT_AI_IsAllyValidForAbility(oTarget, nTacticCommand, nTacticSubCommand, nAbilityTargetType) != TRUE))
                                return FALSE;
                        }
                        else
                            // Should never occur.
                            return FALSE;
                    }
                    else
                    {
                        // Multi target condition test.
                        if ((arTargets[1] != OBJECT_INVALID)
                        && (_AT_AI_IsEnemyValidForAbility(oTarget, nTacticCommand, nTacticSubCommand, nAbilityTargetType) != TRUE))
                            return FALSE;
                    }

                    break;
                }
                case AI_TARGET_TYPE_PLACEABLE:
                {
                    if ((nAbilityTargetType & TARGET_TYPE_PLACEABLE) == 0)
                        return FALSE;
                    break;
                }
                case AI_TARGET_TYPE_SELF:
                {
                    if (AT_IsHostileSelfAOE(nTacticCommand, nTacticSubCommand) == TRUE)
                    {
                        // Special case for Hostile AOE that need OBJECT_SELF for target.
                        // Both OBJECT_SELF and the enemy need to be Valid for the ability.

                        if ((arTargets[1] != OBJECT_INVALID)
                        && (_AT_AI_IsEnemyValidForAbility(arTargets[1], nTacticCommand, nTacticSubCommand, nAbilityTargetType) != TRUE))
                            return FALSE;

                        oTarget = OBJECT_SELF;

                        if (_AT_AI_IsSelfValidForAbility(nTacticCommand, nTacticSubCommand, nAbilityTargetType) != TRUE)
                            return FALSE;
                    }
                    else if ((nAbilityTargetType & TARGET_TYPE_SELF) == 0)
                    {
                        if ((nAbilityTargetType & TARGET_TYPE_HOSTILE_CREATURE) != 0)
                        {
                            // If we are in the case of a multi target condition, there
                            // could be something interesting in the second object variable.

                            if ((_AT_AI_IsEnemyValid(arTargets[1], TRUE, arTargets[1] != oSelectedTarget) == TRUE)
                            && (_AT_AI_IsEnemyValidForAbility(arTargets[1], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                                oTarget = arTargets[1];
                            // Else, the current target is the default target.
                            else if ((_AT_AI_IsEnemyValid(oSelectedTarget) == TRUE)
                            && (_AT_AI_IsEnemyValidForAbility(oSelectedTarget, nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                                oTarget = oSelectedTarget;
                            // Else, we are trying on the nearest enemy.
                            else
                            {
                                oTarget = _MK_AI_Condition_GetAnyTarget(nTacticCommand, nTacticSubCommand, AI_TARGET_TYPE_ENEMY, nTacticID, TARGET_TYPE_HOSTILE_CREATURE);

                                if ((_AT_AI_IsEnemyValid(oTarget, TRUE, oTarget != oSelectedTarget) != TRUE)
                                || (_AT_AI_IsEnemyValidForAbility(oTarget, nTacticCommand, nTacticSubCommand, nAbilityTargetType) != TRUE))
                                    return FALSE;
                            }
                        }
                        // Else, we are trying on the nearest ally.
                        else if ((nAbilityTargetType & TARGET_TYPE_FRIENDLY_CREATURE) != 0)
                        {
                            oTarget = _MK_AI_Condition_GetAnyTarget(nTacticCommand, nTacticSubCommand, AI_TARGET_TYPE_ALLY, nTacticID, TARGET_TYPE_FRIENDLY_CREATURE);

                            if ((_AT_AI_IsAllyValid(oTarget) != TRUE)
                            || (_AT_AI_IsAllyValidForAbility(oTarget, nTacticCommand, nTacticSubCommand, nAbilityTargetType) != TRUE))
                                return FALSE;
                        }
                        else
                            // Should never occur.
                            return FALSE;
                    }
                    else
                    {
                        // Multi target condition test.
                        if ((arTargets[1] != OBJECT_INVALID)
                        && (_AT_AI_IsSelfValidForAbility(nTacticCommand, nTacticSubCommand, nAbilityTargetType) != TRUE))
                            return FALSE;
                    }

                    break;
                }
                case AI_TARGET_TYPE_ALLY:
                case AI_TARGET_TYPE_HERO:
                case AI_TARGET_TYPE_FOLLOWER:
                case AI_TARGET_TYPE_MAIN_CONTROLLED:
                default:
                {
                    if (AT_IsHostileSelfAOE(nTacticCommand, nTacticSubCommand) == TRUE)
                    {
                        // Special case for Hostile AOE that need OBJECT_SELF for target.
                        // Both OBJECT_SELF and the enemy need to be Valid for the ability.

                        if ((arTargets[1] != OBJECT_INVALID)
                        && (_AT_AI_IsEnemyValidForAbility(arTargets[1], nTacticCommand, nTacticSubCommand, nAbilityTargetType) != TRUE))
                            return FALSE;

                        oTarget = OBJECT_SELF;

                        if (_AT_AI_IsSelfValidForAbility(nTacticCommand, nTacticSubCommand, nAbilityTargetType) != TRUE)
                            return FALSE;
                    }
                    else if ((nAbilityTargetType & TARGET_TYPE_FRIENDLY_CREATURE) == 0)
                    {
                        // If we are in the case of a multi target condition, there
                        // could be something interesting in the second object variable.

                        if (((nAbilityTargetType & TARGET_TYPE_HOSTILE_CREATURE) != 0)
                        && (_AT_AI_IsEnemyValid(arTargets[1], TRUE, arTargets[1] != oSelectedTarget) == TRUE)
                        && (_AT_AI_IsEnemyValidForAbility(arTargets[1], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                            oTarget = arTargets[1];
                        // Else, self is the default target.
                        else if (((nAbilityTargetType & TARGET_TYPE_SELF) != 0)
                        && (_AT_AI_IsSelfValidForAbility(nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                            oTarget = OBJECT_SELF;
                        else if ((nAbilityTargetType & TARGET_TYPE_HOSTILE_CREATURE) != 0)
                        {
                            // Else, the current target is the default target.
                            if ((_AT_AI_IsEnemyValid(oSelectedTarget) == TRUE)
                            && (_AT_AI_IsEnemyValidForAbility(oSelectedTarget, nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                                oTarget = oSelectedTarget;
                            // Else, we are trying on the nearest enemy.
                            else
                            {
                                oTarget = _MK_AI_Condition_GetAnyTarget(nTacticCommand, nTacticSubCommand, AI_TARGET_TYPE_ENEMY, nTacticID, TARGET_TYPE_HOSTILE_CREATURE);

                                if ((_AT_AI_IsEnemyValid(oTarget, TRUE, oTarget != oSelectedTarget) != TRUE)
                                || (_AT_AI_IsEnemyValidForAbility(oTarget, nTacticCommand, nTacticSubCommand, nAbilityTargetType) != TRUE))
                                    return FALSE;
                            }
                        }
                        else
                            // Should never occur.
                            return FALSE;
                    }
                    else
                    {
                        // Multi target condition test.
                        if ((arTargets[1] != OBJECT_INVALID)
                        && (_AT_AI_IsAllyValidForAbility(oTarget, nTacticCommand, nTacticSubCommand, nAbilityTargetType) != TRUE))
                            return FALSE;
                    }

                    break;
                }
            }

            if (_AT_AI_IsTargetValidForAttack(oTarget, oLastTarget, nLastCommandStatus) != TRUE)
                return FALSE;

            if (nTacticCommand == AT_COMMAND_SAVE_SECONDARY_TARGET)
            {
                // TODO
                return FALSE;
            }
            else if (nTacticCommand == AI_COMMAND_USE_ABILITY)
                cTacticCommand = _MK_CommandUseAbility(nTacticSubCommand, oTarget);//CommandUseAbility(nTacticSubCommand, oTarget);
            else if (nTacticCommand == AI_COMMAND_ATTACK)
                cTacticCommand = MK_CommandAttack(oTarget, oLastTarget, nLastCommand, nLastCommandStatus);

            break;
        }
        /*
        some commands are handled earlier in separate switch-case so 'default: error' will not work
        default:
        {
            string sMsg = "Unknown nTacticCommand = " + IntToString(nTacticCommand);
            MK_Error(nTacticID, FUNCTION_NAME, sMsg);

            return FALSE;
        }
        */
    }

    if (GetCommandType(cTacticCommand) == COMMAND_TYPE_INVALID)
    {
        #ifdef MK_DEBUG
        MK_PrintToLog("[ExecuteTactic] : result TacticCommand is invalid -> return FALSE ");
        #endif
        return FALSE;
    }

//------------------------------------------------------------------------------
//  Confused(Waking Nightmare) cannot target [Self]
//------------------------------------------------------------------------------
    if (GetHasEffects(OBJECT_SELF, EFFECT_TYPE_CONFUSION)
    && (oTarget == OBJECT_SELF))
    {
        #ifdef MK_DEBUG
        MK_PrintToLog("[ExecuteTactic] : Confused(Waking Nightmare) cannot target [Self] -> return FALSE");
        #endif
        return FALSE;
    }

//------------------------------------------------------------------------------
//  If you target an [Enemy] but you are not allowed to attack
//  (it was not granted by the Player) then:
//  - If you are controlled by Player then give a party permisson to attack
//  - Else if your behavior do not grant such a permission then override
//    Command to be MoveToControlled
//------------------------------------------------------------------------------
    #ifdef MK_DEBUG
    MK_PrintToLog("[ExecuteTactic] Section: Attack Permission");
    #endif
    if( (_AT_AI_IsEnemyValid(oTarget) == TRUE)
    &&  (AI_GetPartyAllowedToAttack() != TRUE))
    {
        // Advanced Tactics
        if (IsControlled(OBJECT_SELF) == TRUE)
            _AT_AI_SetPartyAllowedToAttack(TRUE);
        else if (AI_BehaviorCheck_AttackOnCombatStart() != TRUE)
            cTacticCommand = _AT_AI_MoveToControlled(nLastCommandStatus);
    }

//------------------------------------------------------------------------------
//  Add command to Command Queue
//------------------------------------------------------------------------------
    #ifdef MK_DEBUG
    string logMsg = "[ExecuteTactic] Section:  Add command to Command Queue. cTacticCommand = ";
    logMsg += MK_CmdTypeToString(GetCommandType(cTacticCommand));
    MK_PrintToLog(logMsg);
    #endif
    SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, nTacticID);
    MK_AddCommand(OBJECT_SELF, cTacticCommand);

    return TRUE;

} // _MK_AI_ExecuteTactic


/** @brief Disarm nearest trap command constructor
*
* @author anakin55
**/
command MK_DisarmTraps()
{
    if (HasAbility(OBJECT_SELF, ABILITY_TALENT_HIDDEN_ROGUE) == TRUE)
    {
        object[] arTraps = GetObjectsInShape(OBJECT_TYPE_PLACEABLE, SHAPE_SPHERE, GetLocation(OBJECT_SELF), 15.0f);
        int nSize = GetArraySize(arTraps);

        int nPlayerScore = FloatToInt(GetDisableDeviceLevel(OBJECT_SELF));
        int nTargetScore;

        int i;
        for (i = 0; i < nSize; i++)
        {
            if ((Trap_GetType(arTraps[i]) > 0)
            && (Trap_IsPlayerCreated(arTraps[i]) != TRUE)
            && (Trap_GetDetected(arTraps[i]) == TRUE)
            && (Trap_IsArmed(arTraps[i]) == TRUE))
            {
                nTargetScore = GetTrapDisarmDifficulty(arTraps[i]);
                if (nPlayerScore >= nTargetScore)
                    return CommandUseObject(arTraps[i], PLACEABLE_ACTION_DISARM);
            }
        }
    }

    return MK_CommandInvalid();
}

/** @brief Open nearest lock command constructor
*
* @author anakin55
**/
command MK_PickLock()
{
    if (HasAbility(OBJECT_SELF, ABILITY_TALENT_HIDDEN_ROGUE) == TRUE)
    {
        object[] arLocks = GetObjectsInShape(OBJECT_TYPE_PLACEABLE, SHAPE_SPHERE, GetLocation(OBJECT_SELF), 10.0f);
        int nSize = GetArraySize(arLocks);

        int nPlayerScore = FloatToInt(GetDisableDeviceLevel(OBJECT_SELF));
        int nTargetScore;

        int nState;
        int bKeyRequired;
        string sKeyTag;
        object oKey;

        int i;
        for (i = 0; i < nSize; i++)
        {
            nState = GetPlaceableState(arLocks[i]);

            if ((GetObjectActive(arLocks[i]) == TRUE)
            && ((nState == PLC_STATE_DOOR_LOCKED)
            || (nState == PLC_STATE_CONTAINER_STATIC_LOCKED)
            || (nState == PLC_STATE_CONTAINER_LOCKED)
            || (nState == PLC_STATE_CAGE_LOCKED)
            || (nState == PLC_STATE_AREA_TRANSITION_LOCKED)))
            {
                nTargetScore = GetPlaceablePickLockLevel(arLocks[i]);

                if  ((nTargetScore > 1)
                && (nTargetScore < DEVICE_DIFFICULTY_IMPOSSIBLE)
                && (nPlayerScore >= nTargetScore))
                {
                    bKeyRequired = GetPlaceableKeyRequired(arLocks[i]);
                    sKeyTag = GetPlaceableKeyTag(arLocks[i]);

                    if (sKeyTag != "")
                    {
                        oKey = GetItemPossessedBy(OBJECT_SELF, sKeyTag);
                        if (IsObjectValid(oKey) != TRUE)
                            continue;
                    }

                    if (GetPlaceableKeyRequired(arLocks[i]) != TRUE)
                        return CommandUseObject(arLocks[i], PLACEABLE_ACTION_UNLOCK);
                }
            }
        }
    }

    return MK_CommandInvalid();
}
#endif