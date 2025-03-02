#ifndef MK_CONSTANTS_AT_H
#defsym  MK_CONSTANTS_AT_H

#include "at_tools_ai_constants_h"
//==============================================================================
//                          AI_TacticsConditions_mk.xls
//==============================================================================
//---------------------- TacticsBaseConditions
const int MK_BASE_CONDITION_HAS_RESISTANCE = 17;
const int MK_BASE_CONDITION_AT_LEAST_X_ENEMIES_AT_RANGE          = 40;
const int MK_BASE_CONDITION_AT_LEAST_X_ENEMIES_AT_RANGE_OF_PARTY = 41;
const int MK_BASE_CONDITION_AI_STATUS_NOT  = 42;
const int MK_BASE_CONDITION_LOGIC          = 45;

const int MK_BASE_CONDITION_IS_VALID_FOR_ABILITY = 46;
const int MK_BASE_CONDITION_SORT_BY              = 47;
const int MK_BASE_CONDITION_PREFERENCES_FRIEND   = 48;
const int MK_BASE_CONDITION_PREFERENCES_ENEMY    = 49;

const int MK_BASE_CONDITION_AFFECTED_BY_SPELL    = 50;
const int MK_BASE_CONDITION_AFFECTED_BY_TALENT   = 51;

//---------------------- Tactics SubConditions
const int MK_SUB_CONDITION_NEAREST_TARGET_OF_ALLY = -1;
const int MK_SUB_CONDITION_NEAREST_TARGET_OF_TEAMMATE = -2;
const int MK_SUB_CONDITION_NEAREST_TARGET_OF_TEAM_MEMBER = -3;
const int MK_SUB_CONDITION_NEAREST_TARGET_OF_PARTY_MEMBER = -4;

//---------------------- TacticsTargetTypes
const int MK_TARGET_TYPE_SAVED_ENEMY  = 9;
const int MK_TARGET_TYPE_SAVED_FRIEND = 10;
const int MK_TARGET_TYPE_MULTI_CONDITION_SETTINGS = 11;
const int MK_TARGET_TYPE_MULTI_CONDITION_ENEMY    = 12;
const int MK_TARGET_TYPE_MULTI_CONDITION_FRIEND   = 13;
const int MK_TARGET_TYPE_TEAM_MEMBER  = 14;
const int MK_TARGET_TYPE_TEAMMATE     = 15;
const int MK_TARGET_TYPE_PARTY_MEMBER = 16;

//---------------------- CommandTypes
//const int MK_COMMAND_ATTACK_HOLD_POSITION = 27;
//const int MK_COMMAND_ATTACK_WEAPON_RANGE = 28;
//const int MK_COMMAND_ATTACK_MELEE = 29;
//const int MK_COMMAND_ATTACK_RANGED = 30;
const int MK_COMMAND_DEACTIVATE_ALMOST_ALL_MODAL_ABILITIES = 8;
const int MK_COMMAND_BREAK = 9;

const int MK_COMMAND_DISARM_TRAPS = 26;
const int MK_COMMAND_PICK_LOCKS   = 27;
const int MK_COMMAND_ADJUST_AMMO  = 28;
const int MK_COMMAND_UNEQUIP_AMMO = 29;

const int MK_COMMAND_MOVE_TO_TARGET_AT_SHORT  = 30;
const int MK_COMMAND_MOVE_TO_TARGET_AT_MEDIUM = 31;

const int MK_COMMAND_SET_AS_TARGET          = 32;
const int MK_COMMAND_SAVE_ENEMY             = 33;
const int MK_COMMAND_SAVE_FRIEND            = 34;
const int MK_COMMAND_CLEAR_SAVED_ENEMY      = 35;
const int MK_COMMAND_CLEAR_SAVED_FRIEND     = 36;

const int MK_COMMAND_BOOL_1_STORE_COND_RESULT = 38;   //BooleanVar1 = Cond.Result
const int MK_COMMAND_BOOL_2_STORE_COND_RESULT = 39;   //BooleanVar2 = Cond.Result
const int MK_COMMAND_BOOL_1_STORE_NOT_COND_RESULT = 40;   //BooleanVar1 = NOT Cond.Result
const int MK_COMMAND_BOOL_2_STORE_NOT_COND_RESULT = 41;   //BooleanVar2 = NOT Cond.Result
const int MK_COMMAND_BOOL_1_STORE_COND_RESULT_AND_BOOL_1 = 42;    //BooleanVar1 = Cond.Result AND BooleanVar1
const int MK_COMMAND_BOOL_2_STORE_COND_RESULT_AND_BOOL_2 = 43;    //BooleanVar2 = Cond.Result AND BooleanVar2
const int MK_COMMAND_BOOL_1_STORE_COND_RESULT_OR_BOOL_1 = 44;     //BooleanVar1 = Cond.Result OR BooleanVar1
const int MK_COMMAND_BOOL_2_STORE_COND_RESULT_OR_BOOL_2 = 45;     //BooleanVar2 = Cond.Result OR BooleanVar2
const int MK_COMMAND_BOOL_1_STORE_NOT_COND_RESULT_AND_BOOL_1 = 46;    //BooleanVar1 = NOT Cond.Result AND BooleanVar1
const int MK_COMMAND_BOOL_2_STORE_NOT_COND_RESULT_AND_BOOL_2 = 47;    //BooleanVar2 = NOT Cond.Result AND BooleanVar2
const int MK_COMMAND_BOOL_1_STORE_NOT_COND_RESULT_OR_BOOL_1 = 48;     //BooleanVar1 = NOT Cond.Result OR BooleanVar1
const int MK_COMMAND_BOOL_2_STORE_NOT_COND_RESULT_OR_BOOL_2 = 49;     //BooleanVar2 = NOT Cond.Result OR BooleanVar2

const int MK_COMMAND_SAVE_CONDITION = 51;

const int AT_COMMAND_BEHAVIOR_DEFAULT = 60;
const int AT_COMMAND_BEHAVIOR_PASSIVE = 61;
const int AT_COMMAND_BEHAVIOR_AGGRESSIVE = 62;
const int AT_COMMAND_BEHAVIOR_RANGED = 63;
const int AT_COMMAND_BEHAVIOR_CAUTIOUS = 64;
const int AT_COMMAND_BEHAVIOR_DEFENSIVE = 65;  
const int AT_COMMAND_BEHAVIOR_PROTECTIVE = 66;
const int AT_COMMAND_BEHAVIOR_TEMPLAR = 67;
const int AT_COMMAND_BEHAVIOR_DEFAULT_STATIONARY = 70;
const int AT_COMMAND_BEHAVIOR_PASSIVE_STATIONARY = 71;
const int AT_COMMAND_BEHAVIOR_AGGRESSIVE_STATIONARY = 72;
const int AT_COMMAND_BEHAVIOR_RANGED_STATIONARY = 73;
const int AT_COMMAND_BEHAVIOR_CAUTIOUS_STATIONARY = 74;   
const int AT_COMMAND_BEHAVIOR_DEFENSIVE_STATIONARY = 75; 
const int AT_COMMAND_BEHAVIOR_PROTECTIVE_STATIONARY = 76;
const int AT_COMMAND_BEHAVIOR_TEMPLAR_STATIONARY = 77;
#endif