#include "log_commands_h"

const int EVENT_TYPE_CHARGEN_SELECT_SPEC = EVENT_TYPE_CHARGEN_SELECT_LEVELUP_CLASS;
const int EVENT_TYPE_CHARGEN_AUTOLEVEL = 56;
const int EVENT_TYPE_USE_ABILTY_IMMEDIATE = EVENT_TYPE_USE_ABILITY_IMMEDIATE;
const int EVENT_TYPE_ATTACKED = 1001;
const int EVENT_TYPE_ALLY_ATTACKED = 1002;
const int EVENT_TYPE_WORLD_MAP_USED = 1003;
const int EVENT_TYPE_DELAYED_SHOUT = 1004;
const int EVENT_TYPE_SPELLSCRIPT_PENDING = 1005;
const int EVENT_TYPE_SPELLSCRIPT_CAST = 1006;
const int EVENT_TYPE_SPELLSCRIPT_IMPACT = 1007;
const int EVENT_TYPE_SPELLSCRIPT_DEACTIVATE = 1008;
const int EVENT_TYPE_DOT_TICK = 1010;
const int EVENT_TYPE_CAST_AT = 1011;
const int EVENT_TYPE_STAT_REGEN = 1012;
const int EVENT_TYPE_AFTER_DEATH = 1013;
const int EVENT_TYPE_SET_OBJECT_ACTIVE = 1014;
const int EVENT_TYPE_AMBIENT_AI_TIMEOUT = 1015;
const int EVENT_TYPE_HANDLE_CUSTOM_AI = 1016;
const int EVENT_TYPE_OUT_OF_AMMO = 1017;
const int EVENT_TYPE_HEARTBEAT = 1018;
const int EVENT_TYPE_TEAM_DESTROYED = 1019;
const int EVENT_TYPE_CAMPAIGN_ITEM_ACQUIRED = 1020;
const int EVENT_TYPE_SET_GAME_MODE = 1021;
const int EVENT_TYPE_COMBAT_END = 1022;
const int EVENT_TYPE_DYING = 1023;
const int EVENT_TYPE_PLAYER_LEVELUP = 1024;
const int EVENT_TYPE_AMBIENT_PAUSE = 1025;
const int EVENT_TYPE_AMBIENT_CONTINUE = 1026;
const int EVENT_TYPE_MODULE_CHARGEN_DONE = 1027;
const int EVENT_TYPE_PARTY_MEMBER_HIRED = 1028;
const int EVENT_TYPE_SUMMON_DIED = 1029;
const int EVENT_TYPE_CONFUSION_CALLBACK = 1030;
const int EVENT_TYPE_PARTY_MEMBER_FIRED = 1031;
const int EVENT_TYPE_UNIQUE_POWER = 1032;
const int EVENT_TYPE_TRAP_TRIGGER_DISARMED = 1045;
const int EVENT_TYPE_UNLOCK_FAILED = 1046;
const int EVENT_TYPE_OPENED = 1047;
const int EVENT_TYPE_TRAP_RESET = 1048;
const int EVENT_TYPE_TRAP_DISARM = 1049;
const int EVENT_TYPE_TRAP_ARM = 1050;
const int EVENT_TYPE_TRAP_TRIGGER_ENTER = 1051;
const int EVENT_TYPE_TRAP_TRIGGER_EXIT = 1052;
const int EVENT_TYPE_TRAP_TRIGGER_ARMED = 1053;
const int EVENT_TYPE_CUSTOM_COMMAND_COMPLETE = 1054;
const int EVENT_TYPE_MODULE_HANDLE_GIFT = 1055;
const int EVENT_TYPE_MODULE_HANDLE_FOLLOWER_DEATH = 1056;
//const int EVENT_TYPE_DESTROY_OBJECT = 1070;
const int EVENT_TYPE_COMBO_IGNITE = 1080;
const int EVENT_TYPE_DROP_STEALTH = 1090;
const int EVENT_TYPE_CREATURE_SHAPESHIFTED = 1100;
const int EVENT_TYPE_PARTY_MEMBER_RES_TIMER = 1200;
const int EVENT_TYPE_DELAYED_GM_CHANGE = 2000;
const int EVENT_TYPE_ASSERTION = 12001;
const int EVENT_TYPE_WARNING = 12002;
const int EVENT_TYPE_ERROR = 12003;
const int EVENT_TYPE_SET_INTERACTIVE = 1057;
const int EVENT_TYPE_AUTOPAUSE = 2001;
const int EVENT_TYPE_OBJECT_ACTIVE = 1058;
const int EVENT_TYPE_AOE_INDIVIDUAL_IMPACT = 1066;

string MK_EventTypeToString(int nEventType)
{
    switch( nEventType )
    {
        case EVENT_TYPE_INVALID:
            return "EVENT_TYPE_INVALID";
        case EVENT_TYPE_SPELLCASTAT:
            return "EVENT_TYPE_SPELLCASTAT";
        case EVENT_TYPE_DAMAGED:
            return "EVENT_TYPE_DAMAGED";
        case EVENT_TYPE_SPAWN:
            return "EVENT_TYPE_SPAWN";
        case EVENT_TYPE_DEATH:
            return "EVENT_TYPE_DEATH";
        case EVENT_TYPE_MELEE_ATTACK_START:
            return "EVENT_TYPE_MELEE_ATTACK_START";
        case EVENT_TYPE_INVENTORY_ADDED:
            return "EVENT_TYPE_INVENTORY_ADDED";
        case EVENT_TYPE_INVENTORY_REMOVED:
            return "EVENT_TYPE_INVENTORY_REMOVED";
        case EVENT_TYPE_ENTER:
            return "EVENT_TYPE_ENTER";
        case EVENT_TYPE_EXIT:
            return "EVENT_TYPE_EXIT";
        case EVENT_TYPE_BLOCKED:
            return "EVENT_TYPE_BLOCKED";
        case EVENT_TYPE_EQUIP:
            return "EVENT_TYPE_EQUIP";
        case EVENT_TYPE_UNEQUIP:
            return "EVENT_TYPE_UNEQUIP";
        case EVENT_TYPE_FAILTOOPEN:
            return "EVENT_TYPE_FAILTOOPEN";
        case EVENT_TYPE_USE:
            return "EVENT_TYPE_USE";
        case EVENT_TYPE_CLICK:
            return "EVENT_TYPE_CLICK";
        case EVENT_TYPE_TRAP_TRIGGERED:
            return "EVENT_TYPE_TRAP_TRIGGERED";
        case EVENT_TYPE_TRAP_DISARMED:
            return "EVENT_TYPE_TRAP_DISARMED";
        case EVENT_TYPE_DIALOGUE:
            return "EVENT_TYPE_DIALOGUE";
        case EVENT_TYPE_MODULE_START:
            return "EVENT_TYPE_MODULE_START";
        case EVENT_TYPE_MODULE_LOAD:
            return "EVENT_TYPE_MODULE_LOAD";
        case EVENT_TYPE_LISTENER:
            return "EVENT_TYPE_LISTENER";
        case EVENT_TYPE_LOCKED:
            return "EVENT_TYPE_LOCKED";
        case EVENT_TYPE_UNLOCKED:
            return "EVENT_TYPE_UNLOCKED";
        case EVENT_TYPE_PLAYERLEVELUP:
            return "EVENT_TYPE_PLAYERLEVELUP";
        case EVENT_TYPE_PERCEPTION_APPEAR:
            return "EVENT_TYPE_PERCEPTION_APPEAR";
        case EVENT_TYPE_PERCEPTION_DISAPPEAR:
            return "EVENT_TYPE_PERCEPTION_DISAPPEAR";
        case EVENT_TYPE_SET_PLOT:
            return "EVENT_TYPE_SET_PLOT";
        case EVENT_TYPE_GET_PLOT:
            return "EVENT_TYPE_GET_PLOT";
        case EVENT_TYPE_ATTACK_IMPACT:
            return "EVENT_TYPE_ATTACK_IMPACT";
        case EVENT_TYPE_COMBAT_INITIATED:
            return "EVENT_TYPE_COMBAT_INITIATED";
        case EVENT_TYPE_ABILITY_CAST_IMPACT:
            return "EVENT_TYPE_ABILITY_CAST_IMPACT";
        case EVENT_TYPE_ABILITY_CAST_START:
            return "EVENT_TYPE_ABILITY_CAST_START";
        case EVENT_TYPE_APPLY_EFFECT:
            return "EVENT_TYPE_APPLY_EFFECT";
        case EVENT_TYPE_REMOVE_EFFECT:
            return "EVENT_TYPE_REMOVE_EFFECT";
        case EVENT_TYPE_COMMAND_PENDING:
            return "EVENT_TYPE_COMMAND_PENDING";
        case EVENT_TYPE_COMMAND_COMPLETE:
            return "EVENT_TYPE_COMMAND_COMPLETE";
        case EVENT_TYPE_GAMEOBJECTSLOADED:
            return "EVENT_TYPE_GAMEOBJECTSLOADED";
        case EVENT_TYPE_AREALOAD_PRELOADEXIT:
            return "EVENT_TYPE_AREALOAD_PRELOADEXIT";
        case EVENT_TYPE_AREALOAD_POSTLOADEXIT:
            return "EVENT_TYPE_AREALOAD_POSTLOADEXIT";
        case EVENT_TYPE_AREALOAD_SPECIAL:
            return "EVENT_TYPE_AREALOAD_SPECIAL";
        case EVENT_TYPE_AREALOADSAVE_SPECIAL:
            return "EVENT_TYPE_AREALOADSAVE_SPECIAL";
        case EVENT_TYPE_CHARGEN_START:
            return "EVENT_TYPE_CHARGEN_START";
        case EVENT_TYPE_CHARGEN_SCREEN_ENTERED:
            return "EVENT_TYPE_CHARGEN_SCREEN_ENTERED";
        case EVENT_TYPE_CHARGEN_SELECT_RACE:
            return "EVENT_TYPE_CHARGEN_SELECT_RACE";
        case EVENT_TYPE_CHARGEN_SELECT_CLASS:
            return "EVENT_TYPE_CHARGEN_SELECT_CLASS";
        case EVENT_TYPE_CHARGEN_SELECT_SOUNDSET:
            return "EVENT_TYPE_CHARGEN_SELECT_SOUNDSET";
        case EVENT_TYPE_CHARGEN_SELECT_NAME:
            return "EVENT_TYPE_CHARGEN_SELECT_NAME";
        case EVENT_TYPE_CHARGEN_ASSIGN_ATTRIBUTES:
            return "EVENT_TYPE_CHARGEN_ASSIGN_ATTRIBUTES";
        case EVENT_TYPE_CHARGEN_ASSIGN_ABILITIES:
            return "EVENT_TYPE_CHARGEN_ASSIGN_ABILITIES";
        case EVENT_TYPE_CHARGEN_SELECT_SPEC:
            return "EVENT_TYPE_CHARGEN_SELECT_SPEC";
        case EVENT_TYPE_CHARGEN_IMPORT_HERO:
            return "EVENT_TYPE_CHARGEN_IMPORT_HERO";
        case EVENT_TYPE_CHARGEN_SELECT_GENDER:
            return "EVENT_TYPE_CHARGEN_SELECT_GENDER";
        case EVENT_TYPE_CHARGEN_SELECT_BACKGROUND:
            return "EVENT_TYPE_CHARGEN_SELECT_BACKGROUND";
        case EVENT_TYPE_CHARGEN_AUTOLEVEL:
            return "EVENT_TYPE_CHARGEN_AUTOLEVEL";
        case EVENT_TYPE_CHARGEN_END:
            return "EVENT_TYPE_CHARGEN_END";
        case EVENT_TYPE_GAMEMODE_CHANGE:
            return "EVENT_TYPE_GAMEMODE_CHANGE";
        case EVENT_TYPE_DEATH_RES_PARTY:
            return "EVENT_TYPE_DEATH_RES_PARTY";
        case EVENT_TYPE_MODULE_PRESAVE:
            return "EVENT_TYPE_MODULE_PRESAVE";
        case EVENT_TYPE_MANA_STAM_DEPLETED:
            return "EVENT_TYPE_MANA_STAM_DEPLETED";
        case EVENT_TYPE_ITEM_ONHIT:
            return "EVENT_TYPE_ITEM_ONHIT";
        case EVENT_TYPE_PARTYMEMBER_ADDED:
            return "EVENT_TYPE_PARTYMEMBER_ADDED";
        case EVENT_TYPE_PARTYMEMBER_DROPPED:
            return "EVENT_TYPE_PARTYMEMBER_DROPPED";
        case EVENT_TYPE_ABILITY_ACQUIRED:
            return "EVENT_TYPE_ABILITY_ACQUIRED";
        case EVENT_TYPE_AOE_HEARTBEAT:
            return "EVENT_TYPE_AOE_HEARTBEAT";
        case EVENT_TYPE_WORLD_MAP_CLOSED:
            return "EVENT_TYPE_WORLD_MAP_CLOSED";
        case EVENT_TYPE_POPUP_RESULT:
            return "EVENT_TYPE_POPUP_RESULT";
        case EVENT_TYPE_PLACEABLE_COLLISION:
            return "EVENT_TYPE_PLACEABLE_COLLISION";
        case EVENT_TYPE_PLACEABLE_ONCLICK:
            return "EVENT_TYPE_PLACEABLE_ONCLICK";
        case EVENT_TYPE_REACHED_WAYPOINT:
            return "EVENT_TYPE_REACHED_WAYPOINT";
        case EVENT_TYPE_AREALIST_POSTLOAD:
            return "EVENT_TYPE_AREALIST_POSTLOAD";
        case EVENT_TYPE_HEARTBEAT2:
            return "EVENT_TYPE_HEARTBEAT2";
        case EVENT_TYPE_GIFT_ITEM:
            return "EVENT_TYPE_GIFT_ITEM";
        case EVENT_TYPE_LOAD_TACTICS_PRESET:
            return "EVENT_TYPE_LOAD_TACTICS_PRESET";
        case EVENT_TYPE_GUI_OPENED:
            return "EVENT_TYPE_GUI_OPENED";
        case EVENT_TYPE_INVENTORY_FULL:
            return "EVENT_TYPE_INVENTORY_FULL";
        case EVENT_TYPE_CREATURE_ENTERS_DIALOGUE:
            return "EVENT_TYPE_CREATURE_ENTERS_DIALOGUE";
        case EVENT_TYPE_RUBBER_BAND:
            return "EVENT_TYPE_RUBBER_BAND";
        case EVENT_TYPE_GIVE_UP:
            return "EVENT_TYPE_GIVE_UP";
        case EVENT_TYPE_ON_SELECT:
            return "EVENT_TYPE_ON_SELECT";
        case EVENT_TYPE_ON_ORDER_RECEIVED:
            return "EVENT_TYPE_ON_ORDER_RECEIVED";
        case EVENT_TYPE_USE_ABILTY_IMMEDIATE:
            return "EVENT_TYPE_USE_ABILTY_IMMEDIATE";
        case EVENT_TYPE_ATTACKED:
            return "EVENT_TYPE_ATTACKED";
        case EVENT_TYPE_ALLY_ATTACKED:
            return "EVENT_TYPE_ALLY_ATTACKED";
        case EVENT_TYPE_WORLD_MAP_USED:
            return "EVENT_TYPE_WORLD_MAP_USED";
        case EVENT_TYPE_DELAYED_SHOUT:
            return "EVENT_TYPE_DELAYED_SHOUT";
        case EVENT_TYPE_SPELLSCRIPT_PENDING:
            return "EVENT_TYPE_SPELLSCRIPT_PENDING";
        case EVENT_TYPE_SPELLSCRIPT_CAST:
            return "EVENT_TYPE_SPELLSCRIPT_CAST";
        case EVENT_TYPE_SPELLSCRIPT_IMPACT:
            return "EVENT_TYPE_SPELLSCRIPT_IMPACT";
        case EVENT_TYPE_SPELLSCRIPT_DEACTIVATE:
            return "EVENT_TYPE_SPELLSCRIPT_DEACTIVATE";
        case EVENT_TYPE_DOT_TICK:
            return "EVENT_TYPE_DOT_TICK";
        case EVENT_TYPE_CAST_AT:
            return "EVENT_TYPE_CAST_AT";
        case EVENT_TYPE_STAT_REGEN:
            return "EVENT_TYPE_STAT_REGEN";
        case EVENT_TYPE_AFTER_DEATH:
            return "EVENT_TYPE_AFTER_DEATH";
        case EVENT_TYPE_SET_OBJECT_ACTIVE:
            return "EVENT_TYPE_SET_OBJECT_ACTIVE";
        case EVENT_TYPE_AMBIENT_AI_TIMEOUT:
            return "EVENT_TYPE_AMBIENT_AI_TIMEOUT";
        case EVENT_TYPE_HANDLE_CUSTOM_AI:
            return "EVENT_TYPE_HANDLE_CUSTOM_AI";
        case EVENT_TYPE_OUT_OF_AMMO:
            return "EVENT_TYPE_OUT_OF_AMMO";
        case EVENT_TYPE_HEARTBEAT:
            return "EVENT_TYPE_HEARTBEAT";
        case EVENT_TYPE_TEAM_DESTROYED:
            return "EVENT_TYPE_TEAM_DESTROYED";
        case EVENT_TYPE_CAMPAIGN_ITEM_ACQUIRED:
            return "EVENT_TYPE_CAMPAIGN_ITEM_ACQUIRED";
        case EVENT_TYPE_SET_GAME_MODE:
            return "EVENT_TYPE_SET_GAME_MODE";
        case EVENT_TYPE_COMBAT_END:
            return "EVENT_TYPE_COMBAT_END";
        case EVENT_TYPE_DYING:
            return "EVENT_TYPE_DYING";
        case EVENT_TYPE_PLAYER_LEVELUP:
            return "EVENT_TYPE_PLAYER_LEVELUP";
        case EVENT_TYPE_AMBIENT_PAUSE:
            return "EVENT_TYPE_AMBIENT_PAUSE";
        case EVENT_TYPE_AMBIENT_CONTINUE:
            return "EVENT_TYPE_AMBIENT_CONTINUE";
        case EVENT_TYPE_MODULE_CHARGEN_DONE:
            return "EVENT_TYPE_MODULE_CHARGEN_DONE";
        case EVENT_TYPE_PARTY_MEMBER_HIRED:
            return "EVENT_TYPE_PARTY_MEMBER_HIRED";
        case EVENT_TYPE_SUMMON_DIED:
            return "EVENT_TYPE_SUMMON_DIED";
        case EVENT_TYPE_CONFUSION_CALLBACK:
            return "EVENT_TYPE_CONFUSION_CALLBACK";
        case EVENT_TYPE_PARTY_MEMBER_FIRED:
            return "EVENT_TYPE_PARTY_MEMBER_FIRED";
        case EVENT_TYPE_UNIQUE_POWER:
            return "EVENT_TYPE_UNIQUE_POWER";
        case EVENT_TYPE_TRAP_TRIGGER_DISARMED:
            return "EVENT_TYPE_TRAP_TRIGGER_DISARMED";
        case EVENT_TYPE_UNLOCK_FAILED:
            return "EVENT_TYPE_UNLOCK_FAILED";
        case EVENT_TYPE_OPENED:
            return "EVENT_TYPE_OPENED";
        case EVENT_TYPE_TRAP_RESET:
            return "EVENT_TYPE_TRAP_RESET";
        case EVENT_TYPE_TRAP_DISARM:
            return "EVENT_TYPE_TRAP_DISARM";
        case EVENT_TYPE_TRAP_ARM:
            return "EVENT_TYPE_TRAP_ARM";
        case EVENT_TYPE_TRAP_TRIGGER_ENTER:
            return "EVENT_TYPE_TRAP_TRIGGER_ENTER";
        case EVENT_TYPE_TRAP_TRIGGER_EXIT:
            return "EVENT_TYPE_TRAP_TRIGGER_EXIT";
        case EVENT_TYPE_TRAP_TRIGGER_ARMED:
            return "EVENT_TYPE_TRAP_TRIGGER_ARMED";
        case EVENT_TYPE_CUSTOM_COMMAND_COMPLETE:
            return "EVENT_TYPE_CUSTOM_COMMAND_COMPLETE";
        case EVENT_TYPE_MODULE_HANDLE_GIFT:
            return "EVENT_TYPE_MODULE_HANDLE_GIFT";
        case EVENT_TYPE_MODULE_HANDLE_FOLLOWER_DEATH:
            return "EVENT_TYPE_MODULE_HANDLE_FOLLOWER_DEATH";
        //case EVENT_TYPE_DESTROY_OBJECT:
        //    return "EVENT_TYPE_DESTROY_OBJECT";
        case EVENT_TYPE_COMBO_IGNITE:
            return "EVENT_TYPE_COMBO_IGNITE";
        case EVENT_TYPE_DROP_STEALTH:
            return "EVENT_TYPE_DROP_STEALTH";
        case EVENT_TYPE_CREATURE_SHAPESHIFTED:
            return "EVENT_TYPE_CREATURE_SHAPESHIFTED";
        case EVENT_TYPE_PARTY_MEMBER_RES_TIMER:
            return "EVENT_TYPE_PARTY_MEMBER_RES_TIMER";
        case EVENT_TYPE_DELAYED_GM_CHANGE:
            return "EVENT_TYPE_DELAYED_GM_CHANGE";
        case EVENT_TYPE_ASSERTION:
            return "EVENT_TYPE_ASSERTION";
        case EVENT_TYPE_WARNING:
            return "EVENT_TYPE_WARNING";
        case EVENT_TYPE_ERROR:
            return "EVENT_TYPE_ERROR";
        case EVENT_TYPE_SET_INTERACTIVE:
            return "EVENT_TYPE_SET_INTERACTIVE";
        case EVENT_TYPE_AUTOPAUSE:
            return "EVENT_TYPE_AUTOPAUSE";
        case EVENT_TYPE_OBJECT_ACTIVE:
            return "EVENT_TYPE_OBJECT_ACTIVE";
        case EVENT_TYPE_TRAINING_BEGIN:
            return "EVENT_TYPE_TRAINING_BEGIN";
        case EVENT_TYPE_TRAINING_FOLLOWER_SELECTED:
            return "EVENT_TYPE_TRAINING_FOLLOWER_SELECTED";
        case EVENT_TYPE_TRAINING_GUI_TACTICS_OPENED:
            return "EVENT_TYPE_TRAINING_GUI_TACTICS_OPENED";
        case EVENT_TYPE_TRAINING_GUI_LEVLUP_OPENED:
            return "EVENT_TYPE_TRAINING_GUI_LEVLUP_OPENED";
        case EVENT_TYPE_TRAINING_GUI_INVENTORY_OPENED:
            return "EVENT_TYPE_TRAINING_GUI_INVENTORY_OPENED";
        case EVENT_TYPE_TRAINING_QBAR_ITEM_EQUIPPED:
            return "EVENT_TYPE_TRAINING_QBAR_ITEM_EQUIPPED";
        case EVENT_TYPE_TRAINING_MAXIMUM_ZOOM_IN:
            return "EVENT_TYPE_TRAINING_MAXIMUM_ZOOM_IN";
        case EVENT_TYPE_AOE_INDIVIDUAL_IMPACT:
            return "EVENT_TYPE_AOE_INDIVIDUAL_IMPACT";
        case EVENT_TYPE_TRAINING_WEAPON_EQUIPPED:
            return "EVENT_TYPE_TRAINING_WEAPON_EQUIPPED";
        case EVENT_TYPE_TRAINING_DELAYED_NOACTION:
            return "EVENT_TYPE_TRAINING_DELAYED_NOACTION";
        case EVENT_TYPE_TRAINING_UNPAUSE:
            return "EVENT_TYPE_TRAINING_UNPAUSE";
        case EVENT_TYPE_TRAINING_ITEM_UNEQUIPPED:
            return "EVENT_TYPE_TRAINING_ITEM_UNEQUIPPED";
        case EVENT_TYPE_TRAINING_ITEM_EQUIPPED:
            return "EVENT_TYPE_TRAINING_ITEM_EQUIPPED";
        case EVENT_TYPE_TRAINING_TACTIC_PRESET_SELECTED:
            return "EVENT_TYPE_TRAINING_TACTIC_PRESET_SELECTED";
        case EVENT_TYPE_TRAINING_MOVEMENT_COMMAND_ISSUED:
            return "EVENT_TYPE_TRAINING_MOVEMENT_COMMAND_ISSUED";
        default:
            return "UNKNOWN_TYPE";
    }
    return "ERROR";
}

void main()
{
    event ev = GetCurrentEvent();
    int nEventType = GetEventType(ev);

    if( nEventType == EVENT_TYPE_ON_ORDER_RECEIVED )
    {
        object oSourceCreature = GetEventCreator(ev);
        object oTargetObject = GetEventTarget(ev);

        object oCreature = oSourceCreature;

        command cCmdToLog;
        string sLogMsg;

        cCmdToLog = GetPreviousCommand(oCreature);
        sLogMsg = MK_GetCmdLog(cCmdToLog, oCreature, -2);
        PrintToLog(sLogMsg);

        cCmdToLog = GetCurrentCommand(oCreature);
        sLogMsg = MK_GetCmdLog(cCmdToLog, oCreature, -1);
        PrintToLog(sLogMsg);

        int i;
        int nSize = GetCommandQueueSize(oCreature);
        for(i=0; i < nSize; i++)
        {
            cCmdToLog = GetCommandByIndex(oCreature, i);
            sLogMsg = MK_GetCmdLog(cCmdToLog, oCreature, i);
            PrintToLog(sLogMsg);
        }

    }else
    {
        HandleEvent(ev);
        return;
    }
    if( nEventType < 1000 )
        PrintToLog("Engine Event Gray: " + MK_EventTypeToString(nEventType) );
    else  if( nEventType < 1065 )
        PrintToLog("Designer Event Orange: " + MK_EventTypeToString(nEventType) );
    else
        PrintToLog("Designer Event Green: " + MK_EventTypeToString(nEventType) );

    HandleEvent(ev);
}