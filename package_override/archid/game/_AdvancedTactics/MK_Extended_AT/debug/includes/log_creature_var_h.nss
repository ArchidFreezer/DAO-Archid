#ifndef MK_LOG_CREATURE_VAR_TOOLS_H
#defsym MK_LOG_CREATURE_VAR_TOOLS_H

//==============================================================================
//                              INCLUDES
//==============================================================================
#include "var_constants_h"
#include "ai_constants_h"
#include "sys_rubberband_h"
#include "utility_h"   

#include "log_name_id_h"
//==============================================================================
//                              CONSTANTS
//==============================================================================
//const string AI_CUSTOM_AI_VAR_FLOAT = "AI_CUSTOM_AI_VAR_FLOAT";
//const string RUBBER_HOME_LOCATION_X = "RUBBER_HOME_LOCATION_X";
//const string RUBBER_HOME_LOCATION_Y = "RUBBER_HOME_LOCATION_Y";
//const string RUBBER_HOME_LOCATION_Z = "RUBBER_HOME_LOCATION_Z";
//const string RUBBER_HOME_LOCATION_FACING = "RUBBER_HOME_LOCATION_FACING";
const string ROAM_DISTANCE = "ROAM_DISTANCE";

//const string AI_CUSTOM_AI_VAR_INT = "AI_CUSTOM_AI_VAR_INT";
const string CREATURE_SPAWN_COND = "CREATURE_SPAWN_COND";
//const string AI_CUSTOM_AI_ACTIVE = "AI_CUSTOM_AI_ACTIVE";
//const string AI_BALLISTA_SHOOTER_STATUS = "AI_BALLISTA_SHOOTER_STATUS";
//const string AI_FLAG_PREFERS_RANGED = "AI_FLAG_PREFERS_RANGED";
const string STAT_DMG = "STAT_DMG";
const string STAT_HIT = "STAT_HIT";
const string STAT_MISS = "STAT_MISS";
const string STAT_CRIT = "STAT_CRIT";
//const string SURR_SURRENDER_ENABLED = "SURR_SURRENDER_ENABLED";
//const string SURR_PLOT_FLAG = "SURR_PLOT_FLAG";
//const string RUBBER_HOME_ENABLED = "RUBBER_HOME_ENABLED";
//const string SURR_INIT_CONVERSATION = "SURR_INIT_CONVERSATION";

//const string AI_CUSTOM_AI_VAR_OBJECT = "AI_CUSTOM_AI_VAR_OBJECT";
//const string AI_PLACEABLE_BEING_USED = "AI_PLACEABLE_BEING_USED";

//const string AI_CUSTOM_AI_VAR_STRING = "AI_CUSTOM_AI_VAR_STRING";
//const string SURR_PLOT_NAME = "SURR_PLOT_NAME";

//==============================================================================
//                          DECLARATIONS
//==============================================================================
string MK_LogTableFloat(int idx);
string MK_LogTableInt(int idx);
string MK_LogTableObject(int idx);
string MK_LogTableString(int idx);

//==============================================================================
//                          DEFINITIONS
//==============================================================================
string MK_LogTableFloat(int idx)
{
    string[] sTable;
    int nSize = 0;

    sTable[nSize++] = AI_CUSTOM_AI_VAR_FLOAT;
    //sTable[nSize++] = CREATURE_SPAWN_HEALTH_MOD;
    sTable[nSize++] = SHOUTS_DELAY;
    //sTable[nSize++] = AMBIENT_ANIM_FREQ;
    //sTable[nSize++] = AMBIENT_ANIM_FREQ_OVERRIDE;
    sTable[nSize++] = DEBUG_TRACKING_POS;
    //sTable[nSize++] = RUBBER_HOME_LOCATION_X;
    //sTable[nSize++] = RUBBER_HOME_LOCATION_Y;
    //sTable[nSize++] = RUBBER_HOME_LOCATION_Z;
    //sTable[nSize++] = RUBBER_HOME_LOCATION_FACING;
    //sTable[nSize++] = TS_OVERRIDE_ITEM;
    //sTable[nSize++] = TS_OVERRIDE_HIGH;
    sTable[nSize++] = DEBUG_TRACKING_POS_Y;
    //sTable[nSize++] = TS_OVERRIDE_EQUIPMENT;
    sTable[nSize++] = AI_THREAT_GENERATE_EXTRA_THREAT;
    sTable[nSize++] = ROAM_DISTANCE;
    //sTable[nSize++] = TS_OVERRIDE_REACTIVE;

    if( idx < 0 )
        return IntToString(nSize);
    else if(idx >= nSize)
        return sTable[nSize-1];
    else
        return sTable[idx];
}

string MK_LogTableInt(int idx)
{
    string[] sTable;
    int nSize = 0;

    sTable[nSize++] = AI_DISABLE_PATH_BLOCKED_ACTION;
    sTable[nSize++] = AI_CUSTOM_AI_VAR_INT;
    sTable[nSize++] = AI_LAST_TACTIC;
    sTable[nSize++] = AI_MOVE_TIMER;
    sTable[nSize++] = CREATURE_COUNTER_1;
    sTable[nSize++] = CREATURE_COUNTER_2;
    sTable[nSize++] = CREATURE_COUNTER_3;
    sTable[nSize++] = CREATURE_DO_ONCE_A;
    sTable[nSize++] = CREATURE_DO_ONCE_B;
    //sTable[nSize++] = CREATURE_SPAWN_COND;
    sTable[nSize++] = AI_THREAT_SWITCH_TIMER_MIN;
    //sTable[nSize++] = SOUND_SET_FLAGS_0;
    //sTable[nSize++] = SOUND_SET_FLAGS_1;
    //sTable[nSize++] = SOUND_SET_FLAGS_2;
    //sTable[nSize++] = SPAWN_HOSTILE_LYING_ON_GROUND;
    //sTable[nSize++] = CREATURE_SPAWNED;
    //sTable[nSize++] = CREATURE_LYRIUM_USE;
    //sTable[nSize++] = CREATURE_SPAWN_DEAD;
    sTable[nSize++] = CREATURE_RULES_FLAG0;
    sTable[nSize++] = SHOUTS_ACTIVE;
    //sTable[nSize++] = AMBIENT_SYSTEM_STATE;
    //sTable[nSize++] = AMBIENT_MOVE_PATTERN;
    //sTable[nSize++] = AMBIENT_ANIM_PATTERN;
    //sTable[nSize++] = AMBIENT_ANIM_PATTERN_OVERRIDE;
    sTable[nSize++] = AI_CUSTOM_AI_ACTIVE;
    sTable[nSize++] = AI_BALLISTA_SHOOTER_STATUS;
    sTable[nSize++] = AI_FLAG_PREFERS_RANGED;
    //sTable[nSize++] = AI_THREAT_HATED_RACE;
    //sTable[nSize++] = AI_THREAT_HATED_CLASS;
    //sTable[nSize++] = AI_THREAT_HATED_GENDER;
    sTable[nSize++] = AI_THREAT_SWITCH_TIMER;
    sTable[nSize++] = AI_TARGET_OVERRIDE_DUR_COUNT;
    sTable[nSize++] = AI_THREAT_TARGET_SWITCH_COUNTER;
    //sTable[nSize++] = AMBIENT_ANIM_STATE;
    //sTable[nSize++] = AMBIENT_MOVE_STATE;
    //sTable[nSize++] = AMBIENT_MOVE_COUNT;
    //sTable[nSize++] = IS_SUMMONED_CREATURE;
    //sTable[nSize++] = STAT_DMG;
    //sTable[nSize++] = STAT_HIT;
    //sTable[nSize++] = STAT_MISS;
    //sTable[nSize++] = STAT_CRIT;
    //sTable[nSize++] = SURR_SURRENDER_ENABLED;
    //sTable[nSize++] = SURR_PLOT_FLAG;
    //sTable[nSize++] = AMBIENT_COMMAND;
    sTable[nSize++] = FOLLOWER_SCALED;
    //sTable[nSize++] = AMBIENT_ANIM_OVERRIDE_COUNT;
    //sTable[nSize++] = AMBIENT_TICK_COUNT;
    //sTable[nSize++] = RUBBER_HOME_ENABLED;
    //sTable[nSize++] = TS_OVERRIDE_CATEGORY;
    //sTable[nSize++] = TS_OVERRIDE_RANK;
    //sTable[nSize++] = TS_OVERRIDE_MONEY;
    //sTable[nSize++] = SURR_INIT_CONVERSATION;
    //sTable[nSize++] = FLAG_STOLEN_FROM;
    sTable[nSize++] = BASE_GROUP;
    sTable[nSize++] = AI_HELP_TEAM_STATUS;
    sTable[nSize++] = AI_FLAG_STATIONARY;
    //sTable[nSize++] = TS_OVERRIDE_SCALING;
    //sTable[nSize++] = TS_OVERRIDE_STEALING;
    sTable[nSize++] = COMBAT_LAST_WEAPON;
    //sTable[nSize++] = PHYSICS_DISABLED;
    //sTable[nSize++] = TS_TREASURE_GENERATED;
    sTable[nSize++] = AI_LIGHT_ACTIVE;
    sTable[nSize++] = GO_HOSTILE_ON_PERCEIVE_PC;
    //sTable[nSize++] = CREATURE_REWARD_FLAGS;
    sTable[nSize++] = AI_WAIT_TIMER;
    //sTable[nSize++] = CLIMAX_ARMY_ID;
    sTable[nSize++] = CREATURE_DAMAGED_THE_HERO;
    //sTable[nSize++] = LOOKAT_DISABLED;
    //sTable[nSize++] = MIN_LEVEL;
    sTable[nSize++] = CREATURE_HAS_TIMER_ATTACK;

    if( idx < 0 )
        return IntToString(nSize);
    else if(idx >= nSize)
        return sTable[nSize-1];
    else
        return sTable[idx];
}

string MK_LogTableObject(int idx)
{
    string[] sTable;
    int nSize = 0;

    sTable[nSize++] = AI_CUSTOM_AI_VAR_OBJECT;
    sTable[nSize++] = AI_REGISTERED_WP;
    sTable[nSize++] = AI_THREAT_TARGET;
    sTable[nSize++] = AI_TARGET_OVERRIDE;
    sTable[nSize++] = AI_PLACEABLE_BEING_USED;

    if( idx < 0 )
        return IntToString(nSize);
    else if(idx >= nSize)
        return sTable[nSize-1];
    else
        return sTable[idx];
}

string MK_LogTableString(int idx)
{
    string[] sTable;
    int nSize = 0;

    sTable[nSize++] = AI_CUSTOM_AI_VAR_STRING;
    //sTable[nSize++] = AMBIENT_MOVE_PREFIX;
    //sTable[nSize++] = SURR_PLOT_NAME;

    if( idx < 0 )
        return IntToString(nSize);
    else if(idx >= nSize)
        return sTable[nSize-1];
    else
        return sTable[idx];

}

#endif