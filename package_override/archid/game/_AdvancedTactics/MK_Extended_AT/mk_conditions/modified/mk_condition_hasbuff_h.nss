#ifndef MK_CONDITION_HAS_BUFF_H
#defsym MK_CONDITION_HAS_BUFF_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_condition_hasdebuff_h"

/* MkBot */
#include "mk_constants_h"
#include "mk_constants_ai_h"

#include "mk_get_creatures_h"
#include "mk_cond_tools_h"

#include "mk_print_to_log_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object _MK_Condition_HasBuff(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nRangeID, int nCase);
int _MK_SubCondition_HasBuff(object oTarget, int nCase);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
object _MK_Condition_HasBuff(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nRangeID, int nCase)
{
    float fRange;
    if (nRangeID != AI_RANGE_ID_INVALID)
        fRange = _MK_GetRangeFromID(nRangeID);

    object[] arTargets;
    int nSize;
    int i;

    switch (nTargetType)
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
                int nIsWithinRange = TRUE;
                if (nRangeID != AI_RANGE_ID_INVALID)
                    nIsWithinRange = GetDistanceBetween(OBJECT_SELF, arTargets[i]) <= fRange;

                if (nIsWithinRange == TRUE
                &&  _AT_AI_IsEnemyValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE
                &&  _MK_AI_IsSleepRoot(arTargets[i]) == FALSE
                &&  _MK_SubCondition_HasBuff(arTargets[i], nCase) == TRUE)
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
                int nIsWithinRange = TRUE;
                if (nRangeID != AI_RANGE_ID_INVALID)
                    nIsWithinRange = GetDistanceBetween(OBJECT_SELF, arTargets[i]) <= fRange;

                if (nIsWithinRange == TRUE
                &&  _MK_AI_IsFriendValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE
                &&  _MK_SubCondition_HasBuff(arTargets[i], nCase) == TRUE)
                    return arTargets[i];
            }

            break;
        }
        default:
        {
            string sMsg = "[_MK_Condition_HasBuff] ERROR: Unknown Target Type = " + IntToString(nTargetType);
            DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, 0xFF0000, 5.0);
            MK_PrintToLog(sMsg);

            break;
        }
    }

    return OBJECT_INVALID;
}

#endif

#ifndef MK_SUBCONDITION_HAS_BUFF_H
#defsym MK_SUBCONDITION_HAS_BUFF_H
int _MK_SubCondition_HasBuff(object oTarget, int nCase)
{
    switch(nCase)
    {
        case 0:
        {
            return _AI_HasAnyBuffEffect(oTarget);
            break;
        }
        case 1:  //Has Enchanted Weapon
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_FLAMING_WEAPONS);
            if (GetArraySize(arEffects) > 0)
                return TRUE;

            arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_FROST_WEAPONS);
            if (GetArraySize(arEffects) > 0)
                return TRUE;

            arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_TELEKINETIC_WEAPONS);
            if (GetArraySize(arEffects) > 0)
                return TRUE;

            break;
        }
        case 2:  //Rogue: Feign Death
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_FEIGN_DEATH);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 3:  //Rogue (DAA): Ghost
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_GHOST);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 4:  //Rogue (DAA): Weak Points
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_WEAK_POINTS);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 5:  //Warrior: Threaten
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_THREATEN);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 6:  //Warrior: Precise Striking
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_PRECISE_STRIKING);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 7:  //Warrior: Perfect Striking
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_PERFECT_STRIKE);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 8:  //Shale: Pulverizing Blows
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_PULVERIZING_BLOWS);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 9:  //Shale: Stoneheart
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_STONEHEART);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 10: //Shale: Rock Mastery
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_ROCK_MASTERY);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 11: //Shale: Stone Aura
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_STONE_AURA);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 12: //Dual Weapon: Dual Striking
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_DUAL_WEAPON_DOUBLE_STRIKE);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 13: //Dual Weapon: Momentum
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_DUAL_WEAPON_MOMENTUM);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 14: //Archery: Aim
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_AIM);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 15: //Archery: Defensive Fire
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_DEFENSIVE_FIRE);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 16: //Archery: Rapid Shot
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_RAPIDSHOT);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 17: //Archery: Suppressing Fire
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_SUPPRESSING_FIRE);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 18: //Archery (DAA): Accuracy
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_ACCURACY);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 19: //Archery (DAA): Arrow Time
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_ARROW_TIME);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 20: //Shield: Shield Defense
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_SHIELD_DEFENSE);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 21: //Shield: Shield Wall
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_SHIELD_WALL);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 22: //Shield: Shield Cover
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_SHIELD_COVER);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 23: //Shield (DAA): Juggernaut
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_JUGGERNAUT);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 24: //Shield (DAA): Carapace
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_CARAPACE);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 25: //Shield (DAA): Air of Insolence
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_AIR_OF_INSOLENCE);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 26: //Two-Handed: Indomitable
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_INDOMITABLE);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 27: //Two-Handed: Powerful Swings
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_POWERFUL_SWINGS);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 28: //Two-Handed (DAA): Two-Handed Impact
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_TWO_HANDED_IMPACT);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 29: //Two-Handed (DAA): Reaving Storm
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_REAVING_STORM);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 30: //Arcane: Arcane Shield
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_ARCANE_SHIELD);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 31: //Arcane (DAA): Elemental Mastery
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_ELEMENTAL_MASTERY);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 32: //Arcane (DAA): Repulsion Field
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_REPULSION_FIELD);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 33: //Arcane (DAA): Invigorate
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_INVIGORATE);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 34: //Arcane (DAA): Arcane Field
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_ARCANE_FIELD);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 35: //Arcane (DAA): Mystical Negation
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_MYSTICAL_NEGATION);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 36: //Primal: Rock Armor
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_ROCK_ARMOR);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 37: //Creation: Spell Wisp
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_SPELL_WISP);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 38: //Creation: Spellbloom
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_SPELLBLOOM);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 39: //Spirit: Spell Shield
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_SPELL_SHIELD);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 40: //Spirit: Spell Might
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_SPELL_MIGHT);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 41: //Spirit: Death Syphon
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_DEATH_SYPHON);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 42: //Spirit: Animate Dead
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_ANIMATE_DEAD);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 43: //Entropy: Miasma
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_MIASMA);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 44: //Entropy: Death Magic
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_DEATH_MAGIC);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 45: //Bard: Song of Valor
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_SONG_OF_VALOR);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 46: //Bard: Song of Courage
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_SONG_OF_COURAGE);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 47: //Bard: Captivating Song
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_CAPTIVATE);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 48: //Duelist: Dueling
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_DUELING);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 49: //Legionnaire Scout: Strength of Stone
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_STRENGTH_OF_STONE);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 50: //Legionnaire Scout: Endure Hardship
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_ENDURE_HARDSHIP);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 51: //Shadow: Shadow Form
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_SHADOW_FORM);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 52: //Berserker: Berserk
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_BERSERK);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 53: //Reaver: Aura of Pain
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_PAIN);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 54: //Reaver: Blood Frenzy
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_BLOOD_FRENZY);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 55: //Champion: Rally
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_RALLY);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 56: //Guardian (DAA): Fortifying Presence
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_FORTIFYING_PRESENCE);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 57: //Guardian (DAA): Aura of the Stalwart Defender
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_AURA_OF_THE_STALWART_DEFENDER);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 58: //Spirit Warrior (DAA): Beyond the Veil
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_BEYOND_THE_VEIL);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 59: //Arcane Warrior: Combat Magic
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_COMBAT_MAGIC);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 60: //Arcane Warrior: Shimmering Shield
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_SHIMMERING_SHIELD);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 61: //Blood Mage: Blood Magic
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_BLOOD_MAGIC);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 62: //Battlemage (DAA): Draining Aura
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_DRAINING_AURA);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 63: //Battlemage (DAA): Elemental Chaos
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_ELEMENTALcHAOS);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 64: //Keeper (DAA): One With Nature
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_ONE_WITH_NATURE);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 65: //Power of Blood: Dark Sustenance
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_DARK_SUSTENANCE);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 66: //Power of Blood: Bloody Grasp
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_BLOODY_GRASP);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 67: //Wynne: Vessel of the Spirit
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_WYNNE_SPECIAL);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 68: //Creation: Rejuvenate
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_REJUVINATION);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 69: //Creation: Regeneration
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_REGENERATION);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 70: //Creation: Mass Rejuvenation
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_MASS_REJUVINATE);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 71: //Creation: Heroic Offense
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_HEROIC_OFFENSE);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 72: //Creation: Heroic Aura
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_HEROIC_AURA);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 73: //Creation: Heroic Defense
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_HEROIC_DEFENSE);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 74: //Creation: Haste
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_HASTE);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 75: //Creation: Glyph of Warding
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_GLYPH_OF_WARDING);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 76: //Spirit: Antimagic Ward
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_ANTIMAGIC_WARD);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 77: //Spirit Healer: Lifeward
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_LIFEWARD);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }
        case 78: //Spirit Healer: Cleansing Aura
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_CLEANSING_AURA);
            if (GetArraySize(arEffects) > 0)
                return TRUE;
            break;
        }

    }

    return FALSE;
}

#endif
