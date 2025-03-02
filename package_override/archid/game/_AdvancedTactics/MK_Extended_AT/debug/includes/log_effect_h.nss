#ifndef MK_LOG_EFFECT_H
#defsym MK_LOG_EFFECT_H

//==============================================================================
//                              INCLUDES
//==============================================================================
#include "effect_constants_h"
#include "log_name_id_h"    
#include "mk_abilityidtostring_h"

//==============================================================================
//                          CONSTANTS
//==============================================================================
const int MK_NUM_OF_EFFECT_PARAMETERS_TO_PRINT = 10;

//==============================================================================
//                          DECLARATIONS
//==============================================================================
string MK_GetEffectHeader();
string MK_EffectTypeToString(int nCmdType);
string MK_GetEffectLog(effect eEffectToLog, object oOwner);

//==============================================================================
//                          DEFINITIONS
//==============================================================================
string MK_GetEffectHeader()
{
//OwnerName OwnerId EffectType float1 float2 float3 float4 float5 int1 int2 int3 int4 int5 ObjectId1 ObjectId2 ObjectId3 ObjectId4 ObjectId5
    string sHeader;

    sHeader = ";Name;Id;" ;
    sHeader = sHeader + "EffectType;" ;

    int i;
    for(i=0; i<MK_NUM_OF_EFFECT_PARAMETERS_TO_PRINT; i++)
    {
        string sLabel = "float" + IntToString(i);
        sHeader = sHeader + sLabel + ";" ;
    }

    for(i=0; i<MK_NUM_OF_EFFECT_PARAMETERS_TO_PRINT; i++)
    {
        string sLabel = "int" + IntToString(i);
        sHeader = sHeader + sLabel + ";" ;
    }

    for(i=0; i<MK_NUM_OF_EFFECT_PARAMETERS_TO_PRINT; i++)
    {
        string sLabel = "object" + IntToString(i);
        sHeader = sHeader + sLabel + ";" ;
    }
    return sHeader;
}

string MK_EffectTypeToString(int nEffectType)
{
    switch(nEffectType)
    {
        case EFFECT_TYPE_INVALID:
            return "EFFECT_TYPE_INVALID";
        case EFFECT_TYPE_VISUAL_EFFECT:
            return "EFFECT_TYPE_VISUAL_EFFECT";
        case EFFECT_TYPE_AOE:
            return "EFFECT_TYPE_AOE";
        case EFFECT_TYPE_CAMERA_SHAKE:
            return "EFFECT_TYPE_CAMERA_SHAKE";
        case EFFECT_TYPE_DEATH:
            return "EFFECT_TYPE_DEATH";
        case EFFECT_TYPE_PARALYZE:
            return "EFFECT_TYPE_PARALYZE";
        case EFFECT_TYPE_MOVEMENT_RATE:
            return "EFFECT_TYPE_MOVEMENT_RATE";
        case EFFECT_TYPE_ALPHA:
            return "EFFECT_TYPE_ALPHA";
        case EFFECT_TYPE_MOVEMENT_RATE_DEBUFF:
            return "EFFECT_TYPE_MOVEMENT_RATE_DEBUFF";
        case EFFECT_TYPE_HEARTBEAT:
            return "EFFECT_TYPE_HEARTBEAT";
        case EFFECT_TYPE_WALKING_BOMB:
            return "EFFECT_TYPE_WALKING_BOMB";
        case EFFECT_TYPE_ROOT:
            return "EFFECT_TYPE_ROOT";
        case EFFECT_TYPE_SHAPECHANGE:
            return "EFFECT_TYPE_SHAPECHANGE";
        case EFFECT_TYPE_RESURRECTION:
            return "EFFECT_TYPE_RESURRECTION";
        case EFFECT_TYPE_ENCHANTMENT:
            return "EFFECT_TYPE_ENCHANTMENT";
        case EFFECT_TYPE_LOCK_INVENTORY:
            return "EFFECT_TYPE_LOCK_INVENTORY";
        case EFFECT_TYPE_MODIFYMANASTAMINA:
            return "EFFECT_TYPE_MODIFYMANASTAMINA";
        case EFFECT_TYPE_SUMMON:
            return "EFFECT_TYPE_SUMMON";
        case EFFECT_TYPE_HEALHEALTH:
            return "EFFECT_TYPE_HEALHEALTH";
        case EFFECT_TYPE_DISEASE:
            return "EFFECT_TYPE_DISEASE";
        case EFFECT_TYPE_MODIFY_PROPERTY:
            return "EFFECT_TYPE_MODIFY_PROPERTY";
        case EFFECT_TYPE_DAMAGE:
            return "EFFECT_TYPE_DAMAGE";
        case EFFECT_TYPE_KNOCKDOWN:
            return "EFFECT_TYPE_KNOCKDOWN";
        case EFFECT_TYPE_MODIFYATTRIBUTE:
            return "EFFECT_TYPE_MODIFYATTRIBUTE";
        case EFFECT_TYPE_UPKEEP:
            return "EFFECT_TYPE_UPKEEP";
        case EFFECT_TYPE_DOT:
            return "EFFECT_TYPE_DOT";
        case EFFECT_TYPE_DISPEL_MAGIC:
            return "EFFECT_TYPE_DISPEL_MAGIC";
        case EFFECT_TYPE_DAZE:
            return "EFFECT_TYPE_DAZE";
        case EFFECT_TYPE_STEALTH:
            return "EFFECT_TYPE_STEALTH";
        case EFFECT_TYPE_MODIFY_CRITCHANCE:
            return "EFFECT_TYPE_MODIFY_CRITCHANCE";
        case EFFECT_TYPE_AI_MODIFIER:
            return "EFFECT_TYPE_AI_MODIFIER";
        case EFFECT_TYPE_IMPACT:
            return "EFFECT_TYPE_IMPACT";
        case EFFECT_TYPE_REGENERATION:
            return "EFFECT_TYPE_REGENERATION";
        case EFFECT_TYPE_STUN:
            return "EFFECT_TYPE_STUN";
        case EFFECT_TYPE_GRABBED:
            return "EFFECT_TYPE_GRABBED";
        case EFFECT_TYPE_GRABBING:
            return "EFFECT_TYPE_GRABBING";
        case EFFECT_TYPE_CONECASTING:
            return "EFFECT_TYPE_CONECASTING";
        case EFFECT_TYPE_ADDABILITY:
            return "EFFECT_TYPE_ADDABILITY";
        case EFFECT_TYPE_HEAVY_IMPACT:
            return "EFFECT_TYPE_HEAVY_IMPACT";
        case EFFECT_TYPE_SLEEP:
            return "EFFECT_TYPE_SLEEP";
        case EFFECT_TYPE_CHARM:
            return "EFFECT_TYPE_CHARM";
        case EFFECT_TYPE_CONFUSION:
            return "EFFECT_TYPE_CONFUSION";
        case EFFECT_TYPE_FEAR:
            return "EFFECT_TYPE_FEAR";
        case EFFECT_TYPE_SLEEP_PLOT:
            return "EFFECT_TYPE_SLEEP_PLOT";
        case EFFECT_TYPE_LOCK_QUICKBAR:
            return "EFFECT_TYPE_LOCK_QUICKBAR";
        case EFFECT_TYPE_LOCK_CHARACTER:
            return "EFFECT_TYPE_LOCK_CHARACTER";
        case EFFECT_TYPE_LIFE_WARD:
            return "EFFECT_TYPE_LIFE_WARD";
        case EFFECT_TYPE_FEIGN_DEATH:
            return "EFFECT_TYPE_FEIGN_DEATH";
        case EFFECT_TYPE_OVERWHELMED:
            return "EFFECT_TYPE_OVERWHELMED";
        case EFFECT_TYPE_OVERWHELMING:
            return "EFFECT_TYPE_OVERWHELMING";
        case EFFECT_TYPE_MARK_OF_DEATH:
            return "EFFECT_TYPE_MARK_OF_DEATH";
        case EFFECT_TYPE_SIMULATE_DEATH:
            return "EFFECT_TYPE_SIMULATE_DEATH";
        case EFFECT_TYPE_CURSE_OF_MORTALITY:
            return "EFFECT_TYPE_CURSE_OF_MORTALITY";
        case EFFECT_TYPE_ROOTING:
            return "EFFECT_TYPE_ROOTING";
        case EFFECT_TYPE_MISDIRECTION_HEX:
            return "EFFECT_TYPE_MISDIRECTION_HEX";
        case EFFECT_TYPE_DEATH_HEX:
            return "EFFECT_TYPE_DEATH_HEX";
        case EFFECT_TYPE_FLANK_IMMUNITY:
            return "EFFECT_TYPE_FLANK_IMMUNITY";
        case EFFECT_TYPE_SLIP:
            return "EFFECT_TYPE_SLIP";
        case EFFECT_TYPE_PETRIFY:
            return "EFFECT_TYPE_PETRIFY";
        case EFFECT_TYPE_SPELL_WARD:
            return "EFFECT_TYPE_SPELL_WARD";
        case EFFECT_TYPE_DAMAGE_WARD:
            return "EFFECT_TYPE_DAMAGE_WARD";
        case EFFECT_TYPE_WYNNE_REMOVAL:
            return "EFFECT_TYPE_WYNNE_REMOVAL";
        case EFFECT_TYPE_KNOCKBACK:
            return "EFFECT_TYPE_KNOCKBACK";
        case EFFECT_TYPE_DECREASE_PROPERTY:
            return "EFFECT_TYPE_DECREASE_PROPERTY";
        case EFFECT_TYPE_SWARM:
            return "EFFECT_TYPE_SWARM";
        case EFFECT_TYPE_SINGING:
            return "EFFECT_TYPE_SINGING";
        case EFFECT_TYPE_DRAINING:
            return "EFFECT_TYPE_DRAINING";
        case EFFECT_TYPE_RECENTLY_STUNNED:
            return "EFFECT_TYPE_RECENTLY_STUNNED";
        case EFFECT_TYPE_DUMMY:
            return "EFFECT_TYPE_DUMMY";
        case EFFECT_TYPE_LUCK:
            return "EFFECT_TYPE_LUCK";
        case EFFECT_TYPE_REWARD_BONUS:
            return "EFFECT_TYPE_REWARD_BONUS";
        case EFFECT_TYPE_TRAP_DETECTION_BONUS:
            return "EFFECT_TYPE_TRAP_DETECTION_BONUS";
        case EFFECT_TYPE_BLOOD_MAGIC_BONUS:
            return "EFFECT_TYPE_BLOOD_MAGIC_BONUS";
        case EFFECT_TYPE_MABARI_DOMINANCE:
            return "EFFECT_TYPE_MABARI_DOMINANCE";
        case EFFECT_TYPE_MANA_SHIELD:
            return "EFFECT_TYPE_MANA_SHIELD";
        case EFFECT_TYPE_DUMMY_HOSTILE:
            return "EFFECT_TYPE_DUMMY_HOSTILE";
        case EFFECT_TYPE_AUTOCRIT:
            return "EFFECT_TYPE_AUTOCRIT";
        case EFFECT_TYPE_TEST:
            return "EFFECT_TYPE_TEST";
        case EFFECT_TYPE_RECURRING_KNOCKDOWN:
            return "EFFECT_TYPE_RECURRING_KNOCKDOWN";
        case EFFECT_TYPE_NULL:
            return "EFFECT_TYPE_NULL";
    }
    return IntToString(nEffectType);
}

string MK_GetEffectLog(effect eEffectToLog, object oOwner)
{
    int nWidth = 8;
    int nDecimals = 3;

    string sLog;
    int nEffectType = GetEffectType(eEffectToLog);

    sLog = ";";
    sLog = sLog + MK_LogCreatureId(oOwner);
    sLog = sLog + MK_EffectTypeToString( nEffectType ) + ";" ;

    int i;
    for(i=0; i<MK_NUM_OF_EFFECT_PARAMETERS_TO_PRINT; i++)
    {
        float fLocal = GetEffectFloat(eEffectToLog, i);
        sLog = sLog + FloatToString(fLocal, nWidth, nDecimals) + ";" ;
    }

    for(i=0; i<MK_NUM_OF_EFFECT_PARAMETERS_TO_PRINT; i++)
    {
        int nLocal = GetEffectInteger(eEffectToLog, i); 
        if( nEffectType == EFFECT_TYPE_UPKEEP && i == 1)
            sLog = sLog + MK_AbilityIdToString(nLocal) + ";" ;     
        else
            sLog = sLog + IntToString(nLocal) + ";" ;
    }

    for(i=0; i<MK_NUM_OF_EFFECT_PARAMETERS_TO_PRINT; i++)
    {
        object oLocal = GetEffectObject(eEffectToLog, i);
        sLog = sLog + ObjectToString(oLocal) + ";" ;
    }

    return sLog;

}

#endif