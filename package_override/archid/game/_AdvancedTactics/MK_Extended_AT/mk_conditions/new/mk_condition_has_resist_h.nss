#ifndef MK_CONDITION_HAS_RESISTANCE_H
#defsym MK_CONDITION_HAS_RESISTANCE_H

//==============================================================================
//                                INCLUDES
//==============================================================================
#include "core_h"

/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_condition_hasarmortype_h"

/* MkBot */
#include "mk_constants_h"
#include "mk_constants_ai_h"

#include "mk_get_creatures_h"
#include "mk_cond_tools_h"

#include "mk_print_to_log_h"

//==============================================================================
//                                CONSTANTS
//==============================================================================
const int MK_RESISTANCE_FIRE        = PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_FIRE;
const int MK_RESISTANCE_COLD        = PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_COLD;
const int MK_RESISTANCE_ELECTRICITY = PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_ELEC;
const int MK_RESISTANCE_NATURE      = PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_NATURE;
const int MK_RESISTANCE_SPIRIT      = PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_SPIRIT;
const int MK_RESISTANCE_MAGIC       = PROPERTY_ATTRIBUTE_SPELLRESISTANCE;

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object _MK_Condition_HasResistance(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nResistanceLevel, int nResistanceType);
int _MK_AI_HasResistance(object oTarget, int nResistanceLevel, int nResistanceType);

int EffectTypeFromResistanceType(int nResistanceType);
int DamageTypeFromResistanceType(int nResistanceType);
int PropertyFromResistanceType(int nResistanceType);

//==============================================================================
//                                DEFINITIONS
//==============================================================================
object _MK_Condition_HasResistance(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nResistanceLevel, int nResistanceType)
{
    object[] arTargets;
    int nSize;
    int i;

    switch( nTargetType )
    {
        case AI_TARGET_TYPE_ENEMY:
        case AT_TARGET_TYPE_TARGET:
        case MK_TARGET_TYPE_SAVED_ENEMY:
        case AI_TARGET_TYPE_MOST_HATED:
        {
            arTargets = _MK_AI_GetEnemiesFromTargetType(nTargetType);
            nSize = GetArraySize(arTargets);

            for (i = 0; i < nSize; i++)
            {
                if (_AT_AI_IsEnemyValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE
                &&  _MK_AI_IsSleepRoot(arTargets[i]) == FALSE
                &&  _MK_AI_HasResistance(arTargets[i], nResistanceLevel, nResistanceType))
                    return arTargets[i];
            }

            break;
        }
        case MK_TARGET_TYPE_PARTY_MEMBER:
        case AI_TARGET_TYPE_ALLY:
        case MK_TARGET_TYPE_TEAMMATE:
        case MK_TARGET_TYPE_TEAM_MEMBER:
        case AI_TARGET_TYPE_SELF:
        case AI_TARGET_TYPE_HERO:
        case AI_TARGET_TYPE_FOLLOWER:
        case AI_TARGET_TYPE_MAIN_CONTROLLED:
        case MK_TARGET_TYPE_SAVED_FRIEND:
        {
            arTargets = _MK_AI_GetFollowersFromTargetType(nTargetType, nTacticID);
            nSize = GetArraySize(arTargets);

            for (i = 0; i < nSize; i++)
            {
                if (_MK_AI_IsFriendValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE
                &&  _MK_AI_HasResistance(arTargets[i], nResistanceLevel, nResistanceType) == TRUE)
                    return arTargets[i];
            }

            break;
        }
        default:
        {
            string sMsg = "[_MK_Condition_HasResistance] ERROR: Unknown Target Type = " + IntToString(nTargetType);
            DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, 0xFF0000, 5.0);
            MK_PrintToLog(sMsg);

            break;
        }
    }

    return OBJECT_INVALID;
}

/** @brief Checks whether creature has a given level of resistance.
 * It allows to check a creature immunity to certain effect too.
 * If nResistanceType is not a valid MK_RESITANCE_TYPE then EFFECT_TYPE_INVALID is returned.
 * @param oTarget - creature to check
 * @param nResistanceLevel - negative value means:  CreatureResistance < nResistanceLevel or NOT(for Effects); positive: CreatureResistance >= nResistanceLevel
 * @param nResistanceType - resistance type to check, see MK_RESISTANCE_TYPE_
 * @param return - TRUE or FALSE
 * @author MkBot
*/
int _MK_AI_HasResistance(object oTarget, int nResistanceLevel, int nResistanceType)
{
    //-------- Effect Immunities
    int nEffectType = EffectTypeFromResistanceType(nResistanceType);
    if (nEffectType != EFFECT_TYPE_INVALID)
    {
        int nHasEffectImmunity = IsImmuneToEffectType(oTarget, nEffectType);
        if (nResistanceLevel > 0)
            return nHasEffectImmunity;
        else
            return !nHasEffectImmunity;
    }

    //-------- Damage/Magic Immunities
    int nIsImmune = FALSE;
    if( nResistanceType != MK_RESISTANCE_MAGIC) // Fire/Cold/Electricity/Nature/Spirit Immunity
    {
        int nDamageType = DamageTypeFromResistanceType(nResistanceType);
        nIsImmune = DamageIsImmuneToType(oTarget, nDamageType);
    }
    else // Magic Immunity
    {
        nIsImmune  = GetHasEffects(oTarget, EFFECT_TYPE_INVALID, AF_ABILITY_ANTIMAGIC_WARD);
        nIsImmune |= GetHasEffects(oTarget, AF_ABILITY_STRENGTH_OF_STONE);
    }

    //-------- Damage/Magic Resistances
    int nProperty = PropertyFromResistanceType(nResistanceType);
    float fResTotal = GetCreatureProperty(oTarget,nProperty);
    float fDiffMod = Diff_GetDRMod(oTarget);
    fResTotal += fDiffMod;

    if( nResistanceLevel < 0) // TargetResistance < ResistanceLevel
    {
        return (nIsImmune == FALSE && fResTotal < IntToFloat(abs(nResistanceLevel)));
    }
    else // TargetResistance >= ResistanceLevel
    {
        return (nIsImmune == TRUE || fResTotal >= IntToFloat(nResistanceLevel));
    }
}

/** @brief Converts MK_RESITANCE_TYPE into associated EFFECT_TYPE
 * If nResistanceType is not a valid MK_RESITANCE_TYPE then EFFECT_TYPE_INVALID is returned.
 * @author MkBot
*/
int EffectTypeFromResistanceType(int nResistanceType)
{
    switch(nResistanceType)
    {
        case 20:
            return 1014;//1014: Knockdown
        case 21:
            return 1027;//1027: Stun
        case 22:
            return 1011;//1011: Disease
        case 23:
            return 1020;//1020: Daze
        case 24:
            return 1033;//1033: Sleep
        case 25:
            return 1034;//1034: Charm
        case 26:
            return 1035;//1035: Confusion (Waking Nightmare)
        case 27:
            return 1036;//1036: Fear
        case 28:
            return 1003;//1003: Root
        case 29:
            return 1051;//1051: Slip
    }

    return EFFECT_TYPE_INVALID;;
}

/** @brief Converts MK_RESITANCE_TYPE into associated DAMAGE_TYPE
 * If nResistanceType is not a valid MK_RESITANCE_TYPE then DAMAGE_TYPE_INVALID is returned.
 * @author MkBot
*/
int DamageTypeFromResistanceType(int nResistanceType)
{
    switch(nResistanceType)
    {
        case MK_RESISTANCE_FIRE:
            return DAMAGE_TYPE_FIRE;
        case MK_RESISTANCE_COLD:
            return DAMAGE_TYPE_COLD;
        case MK_RESISTANCE_ELECTRICITY:
            return DAMAGE_TYPE_ELECTRICITY;
        case MK_RESISTANCE_NATURE:
            return DAMAGE_TYPE_NATURE;
        case MK_RESISTANCE_SPIRIT:
            return DAMAGE_TYPE_SPIRIT;
        case MK_RESISTANCE_MAGIC:
            return DAMAGE_TYPE_INVALID;
    }

    return PROPERTY_TYPE_INVALID;
}

/** @brief Converts MK_RESITANCE_TYPE into associated PROPERTY_ATTRTIBUTE
 * If nResistanceType is not a valid MK_RESITANCE_TYPE then PROPERTY_TYPE_INVALID is returned.
 * @author MkBot
*/
int PropertyFromResistanceType(int nResistanceType)
{
    return nResistanceType;
    /*
    switch(nResistanceType)
    {
        case MK_RESISTANCE_FIRE:
            return PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_FIRE;
        case MK_RESISTANCE_COLD:
            return PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_COLD;
        case MK_RESISTANCE_ELECTRICITY:
            return PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_ELEC;
        case MK_RESISTANCE_NATURE:
            return PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_NATURE;
        case MK_RESISTANCE_SPIRIT:
            return PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_SPIRIT;
        case MK_RESISTANCE_MAGIC:
            return PROPERTY_ATTRIBUTE_SPELLRESISTANCE;
    }

    return PROPERTY_TYPE_INVALID;
    */
}

#endif