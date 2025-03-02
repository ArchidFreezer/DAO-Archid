#ifndef AT_AI_CONSTANTS_H
#defsym AT_AI_CONSTANTS_H

/*
    Custom ai_constants_h
*/

#include "at_tools_constants_h"

/* Custom */
/*Mk Extended Advanced TActics*/

/* See AI_TacticsConditions_at.xls */
const int AT_STATUS_PETRIFY = 6;
const int AT_STATUS_FEAR = 10;
const int AT_STATUS_INVULNERABLE = 96;

const int AT_BASE_CONDITION_HAS_DEBUFF_SPELL = 13;
const int AT_BASE_CONDITION_NOT_BEING_ATTACKED_BY_ATTACK_TYPE = 37;
const int AT_BASE_CONDITION_GAME_MODE = 38;
const int AT_BASE_CONDITION_SUMMONING = 39;

const int AT_COMMAND_DISARM_TRAPS = 8; // MkBot: DEPRECIATED
const int AT_COMMAND_PICK_LOCKS = 9;   // MkBot: DEPRECIATED
const int AT_COMMAND_SWITCH_TO_WEAPON_SET_1 = 13;
const int AT_COMMAND_SWITCH_TO_WEAPON_SET_2 = 14;
const int AT_COMMAND_PAUSE = 19;
const int AT_COMMAND_SAVE_SECONDARY_TARGET = 26; // MkBot: DEPRECIATED


const int AT_TARGET_TYPE_TARGET = 8;
const int AT_TARGET_TYPE_SAVED = 9; // MkBot: DEPRECIATED

/* Bug fix */
const int AI_TARGET_TYPE_HERO = 5; // was named AI_TARGE_TYPE_HERO
const int COMMAND_TYPE_MOVE_AWAY_FROM_OBJECT = 16; // was not defined

/* Tweak */
const float AT_FOLLOWER_ENGAGE_DISTANCE_LONG = 50.0f; // was 30.0f.
const int   AT_MAX_ALLIES_NEAREST = 8; // 4 + 4 pets. was 5
const int   AT_MAX_ENEMIES_NEAREST = 10; // was 5

#endif