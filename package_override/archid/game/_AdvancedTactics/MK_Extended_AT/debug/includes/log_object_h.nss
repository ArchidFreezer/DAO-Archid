#ifndef MK_LOG_OBJECT_H
#defsym MK_LOG_OBJECT_H

//==============================================================================
//                              INCLUDES
//==============================================================================
#include "ai_main_h_2"

//==============================================================================
//                          DECLARATIONS
//==============================================================================
void MK_LogObject(object oObjectToLog);
void MK_LogObjectHeader();
float MK_GetCreaturePropertyTotal(object oCreature, int nProperty);
string MK_ObjectTypeToString(int nType);
string MK_RankToString(int nRank);
string MK_FollowerStateToString(int nState);

//==============================================================================
//                          DEFINITIONS
//==============================================================================
void MK_LogObject(object oObjectToLog)
{
 string sHeader = "---------------------- LogMe ----------------------";
 string sMsg;

 int nNameStrref = GetNameStrref(oObjectToLog);
 string sResRef = GetResRef(oObjectToLog);
 string sTag = GetTag(oObjectToLog);
 int nType = GetObjectType(oObjectToLog);

 sMsg = ";" ;
 sMsg = sMsg + GetTlkTableString(nNameStrref) + ";"; // oObjectToLog name
 sMsg = sMsg + ObjectToString(oObjectToLog) + ";" ; // oObjectToLog id
 sMsg = sMsg + MK_RankToString(GetCreatureRank(oObjectToLog)) + ";" ; // party leader id
 sMsg = sMsg + ObjectToString(GetMainControlled()) + ";" ; // main controlled id
 sMsg = sMsg + ObjectToString(GetHero()) + ";" ; // hero id

 //Object functions
 sMsg = sMsg + MK_ObjectTypeToString(nType) + ";" ; //http://dalexicon.net/index.php?title=Object_type_constant
 sMsg = sMsg + IntToString(IsObjectValid(oObjectToLog)) + ";" ;
 sMsg = sMsg + IntToString(IsDestroyable(oObjectToLog)) + ";" ;
 sMsg = sMsg + IntToString(IsImmortal(oObjectToLog)) + ";" ;
 //sMsg = sMsg + IntToString(IsPlot(oObjectToLog)) + ";" ;

 sMsg = sMsg + IntToString(GetAILevel(oObjectToLog)) + ";" ;
 sMsg = sMsg + IntToString(IsConjuring(oObjectToLog)) + ";" ;

 //Player
 //sMsg = sMsg + IntToString(IsHero(oObjectToLog)) + ";" ;
 //Party
 //sMsg = sMsg + IntToString(IsControlled(oObjectToLog)) + ";" ;
 sMsg = sMsg + IntToString(IsFollower(oObjectToLog)) + ";" ;
 sMsg = sMsg + IntToString(IsFollowerLocked(oObjectToLog)) + ";" ;
 sMsg = sMsg + IntToString(IsPartyAIEnabled(oObjectToLog)) + ";" ;
 sMsg = sMsg + IntToString(IsPartyPerceivingHostiles(oObjectToLog)) + ";" ;

 sMsg = sMsg + MK_FollowerStateToString(GetFollowerState(oObjectToLog)) + ";" ;//http://dalexicon.net/index.php?title=Follower_state_constant
 sMsg = sMsg + MK_FollowerStateToString(GetFollowerSubState(oObjectToLog)) + ";" ;

 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_SIMPLE_CURRENT_CLASS)) + ";" ;

 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_STRENGTH)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_DEXTERITY)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_WILLPOWER)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_MAGIC)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_INTELLIGENCE)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_CONSTITUTION)) + ";" ;

 sMsg = sMsg + FloatToString(GetCreatureProperty(oObjectToLog, PROPERTY_ATTRIBUTE_SPELLPOWER)) + ";" ;//MKBot: Bug

 sMsg = sMsg + FloatToString(GetCreatureProperty(oObjectToLog, PROPERTY_ATTRIBUTE_ATTACK)) + ";" ;
 sMsg = sMsg + FloatToString(GetCreatureProperty(oObjectToLog, PROPERTY_ATTRIBUTE_DEFENSE)) + ";" ;
 sMsg = sMsg + FloatToString(GetCreatureProperty(oObjectToLog, PROPERTY_ATTRIBUTE_MISSILE_SHIELD)) + ";" ;
 sMsg = sMsg + FloatToString(GetCreatureProperty(oObjectToLog, PROPERTY_ATTRIBUTE_ARMOR)) + ";" ;

 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_AP)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_DAMAGE_BONUS)) + ";" ;

 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_ATTACK_SPEED_MODIFIER)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_RANGED_AIM_SPEED)) + ";" ;

 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_MELEE_CRIT_MODIFIER)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_MAGIC_CRIT_MODIFIER)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_RANGED_CRIT_MODIFIER)) + ";" ;

 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_DAMAGE_SCALE)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_DAMAGE_SHIELD_STRENGTH)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_DAMAGE_SHIELD_POINTS)) + ";" ;

 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_DEPLETABLE_HEALTH)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_DEPLETABLE_MANA_STAMINA)) + ";" ;

 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_REGENERATION_HEALTH)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_REGENERATION_STAMINA)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_REGENERATION_HEALTH_COMBAT)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_REGENERATION_STAMINA_COMBAT)) + ";" ;

 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_ELECTRICITY_DAMAGE_BONUS)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_NATURE_DAMAGE_BONUS)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_COLD_DAMAGE_BONUS)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_SPIRIT_DAMAGE_BONUS)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_FIRE_DAMAGE_BONUS)) + ";" ;

 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_SPIRIT)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_NATURE)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_ELEC)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_COLD)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_FIRE)) + ";" ;

 sMsg = sMsg + FloatToString(GetCreatureProperty(oObjectToLog, PROPERTY_ATTRIBUTE_RESISTANCE_PHYSICAL)) + ";" ;//MKBot: Bug
 sMsg = sMsg + FloatToString(GetCreatureProperty(oObjectToLog, PROPERTY_ATTRIBUTE_RESISTANCE_MENTAL)) + ";" ;//MKBot: Bug

 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_SIMPLE_LEVEL)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_DISPLACEMENT)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_MOVEMENT_SPEED_MODIFIER)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_ATTRIBUTE_FLANKING_ANGLE)) + ";" ;
 sMsg = sMsg + FloatToString(MK_GetCreaturePropertyTotal(oObjectToLog, PROPERTY_SIMPLE_THREAT_DECREASE_RATE)) + ";" ;

 //PrintToLog( sHeader );
 //PrintToLog( MK_LogObjectTitle() );
 PrintToLog( sMsg );

}

void MK_LogObjectHeader()
{
 string sTitle;

 sTitle = ";" ;

 sTitle = sTitle + "Name" + ";" ;
 sTitle = sTitle + "Id" + ";" ;
 sTitle = sTitle + "Rank" + ";" ;
 sTitle = sTitle + "ControlledId" + ";" ;
 sTitle = sTitle + "HeroId" + ";" ;

 sTitle = sTitle + "nType" + ";" ;
 sTitle = sTitle + "IsValid" + ";" ;
 sTitle = sTitle + "IsDestroyable" + ";" ;
 sTitle = sTitle + "IsImmortal" + ";" ;

 sTitle = sTitle + "AILevel" + ";" ;
 sTitle = sTitle + "IsConjuring" + ";" ;

 sTitle = sTitle + "IsFollower" + ";" ;
 sTitle = sTitle + "IsFollowerLocked" + ";" ;
 sTitle = sTitle + "IsPartyAIEnabled" + ";" ;
 sTitle = sTitle + "IsPartyPerceivingHostiles" + ";" ;

 sTitle = sTitle + "FollowerState" + ";" ;
 sTitle = sTitle + "FollowerSubState" + ";" ;

 sTitle = sTitle + "CURRENT_CLASS" + ";" ;

 sTitle = sTitle + "STRENGTH" + ";" ;
 sTitle = sTitle + "DEXTERITY" + ";" ;
 sTitle = sTitle + "WILLPOWER" + ";" ;
 sTitle = sTitle + "MAGIC" + ";" ;
 sTitle = sTitle + "INTELLIGENCE" + ";" ;
 sTitle = sTitle + "CONSTITUTION" + ";" ;

 sTitle = sTitle + "SPELLPOWER" + ";" ;

 sTitle = sTitle + "ATTACK" + ";" ;
 sTitle = sTitle + "DEFENSE" + ";" ;
 sTitle = sTitle + "MISSILE_SHIELD" + ";" ;
 sTitle = sTitle + "ARMOR" + ";" ;

 sTitle = sTitle + "AP" + ";" ;
 sTitle = sTitle + "DAMAGE_BONUS" + ";" ;

 sTitle = sTitle + "ATTACK_SPEED_MODIFIER" + ";" ;
 sTitle = sTitle + "RANGED_AIM_SPEED" + ";" ;

 sTitle = sTitle + "MELEE_CRIT_MODIFIER" + ";" ;
 sTitle = sTitle + "MAGIC_CRIT_MODIFIER" + ";" ;
 sTitle = sTitle + "RANGED_CRIT_MODIFIER" + ";" ;

 sTitle = sTitle + "DAMAGE_SCALE" + ";" ;
 sTitle = sTitle + "DAMAGE_SHIELD_STRENGTH" + ";" ;
 sTitle = sTitle + "DAMAGE_SHIELD_POINTS" + ";" ;

 sTitle = sTitle + "HEALTH" + ";" ;
 sTitle = sTitle + "MANA_STAMINA" + ";" ;

 sTitle = sTitle + "REGENERATION_HEALTH" + ";" ;
 sTitle = sTitle + "REGENERATION_STAMINA" + ";" ;
 sTitle = sTitle + "REGENERATION_HEALTH_COMBAT" + ";" ;
 sTitle = sTitle + "REGENERATION_STAMINA_COMBAT" + ";" ;

 sTitle = sTitle + "ELECTRICITY_DAMAGE_BONUS" + ";" ;
 sTitle = sTitle + "NATURE_DAMAGE_BONUS" + ";" ;
 sTitle = sTitle + "COLD_DAMAGE_BONUS" + ";" ;
 sTitle = sTitle + "SPIRIT_DAMAGE_BONUS" + ";" ;
 sTitle = sTitle + "FIRE_DAMAGE_BONUS" + ";" ;

 sTitle = sTitle + "DAMAGE_RESISTANCE_SPIRIT" + ";" ;
 sTitle = sTitle + "DAMAGE_RESISTANCE_NATURE" + ";" ;
 sTitle = sTitle + "DAMAGE_RESISTANCE_ELEC" + ";" ;
 sTitle = sTitle + "DAMAGE_RESISTANCE_COLD" + ";" ;
 sTitle = sTitle + "DAMAGE_RESISTANCE_FIRE" + ";" ;

 sTitle = sTitle + "RESISTANCE_PHYSICAL" + ";" ;
 sTitle = sTitle + "RESISTANCE_MENTAL" + ";" ;

 sTitle = sTitle + "LEVEL" + ";" ;
 sTitle = sTitle + "DISPLACEMENT" + ";" ;
 sTitle = sTitle + "MOVEMENT_SPEED_MODIFIER" + ";" ;
 sTitle = sTitle + "FLANKING_ANGLE" + ";" ;
 sTitle = sTitle + "THREAT_DECREASE_RATE" + ";" ;

 PrintToLog(sTitle);

}

float MK_GetCreaturePropertyTotal(object oCreature, int nProperty)
{
     int nPropertyType = GetCreaturePropertyType(oCreature,nProperty);

     if( nPropertyType == PROPERTY_TYPE_SIMPLE || nPropertyType == PROPERTY_TYPE_DERIVED )
        return GetCreatureProperty(oCreature, nProperty, PROPERTY_VALUE_TOTAL);
     if( nPropertyType == PROPERTY_TYPE_ATTRIBUTE || PROPERTY_TYPE_DEPLETABLE)
     {
        float fBase = GetCreatureProperty(oCreature, nProperty, PROPERTY_VALUE_BASE);
        float fModifier = GetCreatureProperty(oCreature, nProperty, PROPERTY_VALUE_MODIFIER);
        float fTotal = fBase + fModifier;
        return fTotal;
     }
     return -1.0;
}

string MK_ObjectTypeToString(int nType)
{
    switch(nType)
    {
        case OBJECT_TYPE_ALL:
        {
            return "OBJECT_TYPE_ALL";
            break;
        }
        case OBJECT_TYPE_AREA:
        {
            return "OBJECT_TYPE_AREA";
            break;
        }
        case OBJECT_TYPE_AREAOFEFFECTOBJECT:
        {
            return "OBJECT_TYPE_AREAOFEFFECTOBJECT";
            break;
        }
        case OBJECT_TYPE_CREATURE:
        {
            return "OBJECT_TYPE_CREATURE";
            break;
        }
        case OBJECT_TYPE_GUI:
        {
            return "OBJECT_TYPE_GUI";
            break;
        }
        case OBJECT_TYPE_INVALID:
        {
            return "OBJECT_TYPE_INVALID";
            break;
        }
        case OBJECT_TYPE_ITEM:
        {
            return "OBJECT_TYPE_ITEM";
            break;
        }
        case OBJECT_TYPE_MAP:
        {
            return "OBJECT_TYPE_MAP";
            break;
        }
        case OBJECT_TYPE_MAPPATCH:
        {
            return "OBJECT_TYPE_MAPPATCH";
            break;
        }
        case OBJECT_TYPE_MODULE:
        {
            return "OBJECT_TYPE_MODULE";
            break;
        }
        case OBJECT_TYPE_PARTY:
        {
            return "OBJECT_TYPE_PARTY";
            break;
        }
        case OBJECT_TYPE_PLACEABLE:
        {
            return "OBJECT_TYPE_PLACEABLE";
            break;
        }
        case OBJECT_TYPE_PROJECTILE:
        {
            return "OBJECT_TYPE_PROJECTILE";
            break;
        }
        case OBJECT_TYPE_SOUND:
        {
            return "OBJECT_TYPE_SOUND";
            break;
        }
        case OBJECT_TYPE_STORE:
        {
            return "OBJECT_TYPE_STORE";
            break;
        }
        case OBJECT_TYPE_TILE:
        {
            return "OBJECT_TYPE_TILE";
            break;
        }
        case OBJECT_TYPE_TRIGGER:
        {
            return "OBJECT_TYPE_TRIGGER";
            break;
        }
        case OBJECT_TYPE_VFX:
        {
            return "OBJECT_TYPE_VFX";
            break;
        }
        case OBJECT_TYPE_WAYPOINT:
        {
            return "OBJECT_TYPE_WAYPOINT";
            break;
        }
        default:
        {
            return "UNKNOWN";
            break;
        }

    }
    return "ERROR";
}
string MK_RankToString(int nRank)
{
    switch(nRank)
    {
        case CREATURE_RANK_INVALID:
            return "CREATURE_RANK_INVALID";
        case CREATURE_RANK_CRITTER:
            return "CREATURE_RANK_CRITTER";
        case CREATURE_RANK_NORMAL:
            return "CREATURE_RANK_NORMAL";
        case CREATURE_RANK_LIEUTENANT:
            return "CREATURE_RANK_LIEUTENANT";
        case CREATURE_RANK_BOSS:
            return "CREATURE_RANK_BOSS";
        case CREATURE_RANK_ELITE_BOSS:
            return "CREATURE_RANK_ELITE_BOSS";
        case CREATURE_RANK_PLAYER:
            return "CREATURE_RANK_PLAYER";
        case CREATURE_RANK_WEAK_NORMAL:
            return "CREATURE_RANK_WEAK_NORMAL";
        case CREATURE_RANK_ONE_HIT_KILL:
            return "CREATURE_RANK_ONE_HIT_KILL";
    }
    return "UNKNOWN";

}

string MK_FollowerStateToString(int nState)
{
    switch(nState)
    {
        case FOLLOWER_STATE_INVALID://Remove follower from party pool and active party
        {
            return "FOLLOWER_STATE_INVALID";
            break;
        }
        case FOLLOWER_STATE_ACTIVE://   Add follower to party pool and to active party
        {
            return "FOLLOWER_STATE_ACTIVE";
            break;
        }
        case FOLLOWER_STATE_AVAILABLE://Add follower to party pool but remove from active party
        {
            return "FOLLOWER_STATE_AVAILABLE";
            break;
        }
        case FOLLOWER_STATE_UNAVAILABLE://Remove follower from active party and do not allow adding it to active party again
        {
            return "FOLLOWER_STATE_UNAVAILABLE";
            break;
        }
        case FOLLOWER_STATE_SUSPENDED://Remove follower from active party and store for returning to the party later
        {
            return "FOLLOWER_STATE_SUSPENDED";
            break;
        }
        case FOLLOWER_STATE_LOADING:
        {
            return "FOLLOWER_STATE_LOADING";
            break;
        }
        case FOLLOWER_STATE_LOCKEDACTIVE:
        {
            return "FOLLOWER_STATE_LOCKEDACTIVE";
            break;
        }
    }
    return "ERROR";
}

#endif