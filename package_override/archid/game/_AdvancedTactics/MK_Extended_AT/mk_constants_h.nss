#ifndef MK_CONSTANTS_H
#defsym MK_CONSTANTS_H

//==============================================================================
//                                Timeouts
//==============================================================================
const float MK_TIMEOUT_BEHAVIOR_ATTACK_MELEE    = 5.0;
const float MK_TIMEOUT_BEHAVIOR_ATTACK_RANGED   = 5.0;
const float MK_TIMEOUT_BEHAVIOR_MOVE            = 4.0;
const float MK_TIMEOUT_MOVE     = 5.0;
const float MK_TIMEOUT_ATTACK   = 3.0;
const float MK_TIMEOUT_ABILITY  = 3.0;

//==============================================================================
//                                Special Tactic Ids
//==============================================================================
const int MK_TACTIC_ID_INVALID = -1;
const int MK_TACTIC_ID_TIMEOUT = -1000;
const int MK_TACTIC_ID_DEAD    = -1001;
//----
const int MK_TACTIC_ID_NOT_COMBATANT = -99;
const int MK_TACTIC_ID_GAMEMODE_TEST_FAIL = -100;
const int MK_TACTIC_ID_PROCESSING_COMMAND_QUEUE = -101;
const int MK_TACTIC_ID_AI_OFF = -102;
const int MK_TACTIC_ID_AI_PARTIAL = -104;
const int MK_TACTIC_ID_AI_MODIFIER_IGNORE = -105;
const int MK_TACTIC_ID_CONTROLLED_BY_PLAYER = -108;
const int MK_TACTIC_ID_BALLISTA_AI = -109;
const int MK_TACTIC_ID_TOO_MANY_TACTICS = -110;
const int MK_TACTIC_ID_OBJECT_NOT_ACITVE = -111;
const int MK_TACTIC_ID_OBJECT_NOT_IN_COMBAT = -112;
//----
const int MK_TACTIC_ID_BEHAVIOR_AVOID_AOE = -120;
const int MK_TACTIC_ID_BEHAVIOR_AVOID_MELEE = -121;
const int MK_TACTIC_ID_BEHAVIOR_SWITCH_WEAPON = -122;
const int MK_TACTIC_ID_BEHAVIOR_AVOID_ENEMIES = -123;
const int MK_TACTIC_ID_BEHAVIOR_ATTACK = -124;
const int MK_TACTIC_ID_BEHAVIOR_MOVE = -125;
const int MK_TACTIC_ID_WAIT = -126;

//==============================================================================
//                                Function Result
//==============================================================================
const int MK_FAILURE     = 0;
const int MK_SUCCESS     = 1;
const int MK_UNPROCESSED = 2;

//==============================================================================
//                               TALMUD TABLES
//==============================================================================
//------------------------- PARTY MEMBERS INDEX TABLE
const string MK_PARTY_MEMBER_INDEX_TABLE = "mkPMIT";

//------------------------- ORDERS AND STRATEGIES
const string MK_COMBAT_START_TABLE              = "mkCST";
const string MK_ISSUE_ORDER_PARTY_TABLE         = "mkSOGOET";
const string MK_CHANGE_STRATEGY_PERSONAL_TABLE  = "mkSOPT";
const string MK_CHANGE_STRATEGY_PARTY_TABLE     = "mkSOGT";

//==============================================================================
//                               RANGED CONSTANTS
//==============================================================================
const float MAX_RANGED_COMBAT_DISTANCE = 45.0;

// AI ranges IDs
const int MK_RANGE_ID_ANY = -1;
const int MK_RANGE_ID_INVALID = 0;
const int MK_RANGE_ID_SHORT = 1;
const int MK_RANGE_ID_MEDIUM = 2;
const int MK_RANGE_ID_LONG = 3;

const int MK_RANGE_ID_DOUBLE_SHORT = 4;
const int MK_RANGE_ID_DOUBLE_MEDIUM = 5;
const int MK_RANGE_ID_BOW = 6;

const int MK_RANGE_ID_IN_LINE_OF_SIGHT = 10;

//==============================================================================
//                               RANGED CONDITIONS CONSTANTS
//==============================================================================
const int MK_RANGE_ID_BETWEEN_SHORT_AND_MEDIUM = MK_RANGE_ID_MEDIUM;//must be the same as core AI_RANGE_ID_MEDIUM
const int MK_RANGE_ID_BETWEEN_MEDIUM_AND_LONG = MK_RANGE_ID_LONG;//must be the same as core AI_RANGE_ID_LONG

const int MK_RANGE_ID_AT_SHORT = MK_RANGE_ID_SHORT; //must same as core AI_RANGE_ID_SHORT
const int MK_RANGE_ID_AT_MEDIUM = 12;
const int MK_RANGE_ID_AT_LONG = 13;
const int MK_RANGE_ID_AT_DOUBLE_SHORT = 14;
const int MK_RANGE_ID_AT_DOUBLE_MEDIUM = 15;
const int MK_RANGE_ID_AT_BOW = 16;

const int MK_RANGE_ID_FURTHER_THAN_SHORT = 21;
const int MK_RANGE_ID_FURTHER_THAN_MEDIUM = 22;
const int MK_RANGE_ID_FURTHER_THAN_LONG = 23;
const int MK_RANGE_ID_FURTHER_THAN_DOUBLE_SHORT = 24;
const int MK_RANGE_ID_FURTHER_THAN_DOUBLE_MEDIUM = 25;
const int MK_RANGE_ID_FURTHER_THAN_BOW = 26;

// Distances
const float MK_RANGE_SHORT = 3.5;
const float MK_RANGE_MEDIUM = 12.0;
const float MK_RANGE_LONG = 80.0;

const float MK_RANGE_DOUBLE_SHORT = 7.0;
const float MK_RANGE_DOUBLE_MEDIUM = 24.0;
const float MK_RANGE_BOW = MAX_RANGED_COMBAT_DISTANCE;

// Distance to move away from enemy


//==============================================================================
//                               SKILLS
//==============================================================================
const int MK_ABILITY_SET_AS_TARGET =  60020;
#endif