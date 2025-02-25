//////////////////////////////////////////////////////////////////
//
// Description: Utility functions for AF_RESPEC
// Owner: Peter 'weriK' Kovacs
// Date: 11/10/2009 @ 4:31 AM
//
/////////////////////////////////////////////////////////////////
#include "ability_h"
#include "attributes_h"
#include "af_ability_h"
#include "af_log_h"
#include "af_utility_h"

const int AF_LOGGROUP_RESPEC = 3;

////
//  Module variables
////

const string AF_VAR_CHAR_RESPEC = "AF_RESPEC_CHAR";

////
//  Respec resouces
////
const string AF_ITM_RESPEC_POTION = "af_respec_potion";
const resource AF_ITR_RESPEC_POTION = R"af_respec_potion.uti";

const string AF_CRE_RESPEC_RAVEN = "af_respec_raven";
const resource AF_CRR_RESPEC_RAVEN = R"af_respec_raven.utc";

////
//  Dialog script parameters
////
const int DLG_PARAM_POTION = 1;
const int DLG_PARAM_ASSASSIN = 2;
const int DLG_PARAM_BARD = 3;
const int DLG_PARAM_BERSERKER = 4;
const int DLG_PARAM_RANGER = 5;
const int DLG_PARAM_SHAPESHIFTER = 6;
const int DLG_PARAM_SPIRITHEALER = 7;
const int DLG_PARAM_TEMPLAR = 8;
const int DLG_PARAM_MAGE = 9;
const int DLG_PARAM_ROGUE = 10;
const int DLG_PARAM_WARRIOR = 11;
const int DLG_PARAM_ANY = 12;

////
//  Starting attributes
////

const float AF_START_ATTR_SUM_HUMANOID = 74.0f;
const float AF_START_ATTR_SUM_QUNARI   = 70.0f;
const float AF_START_ATTR_SUM_DOG      = 70.0f;
const float AF_START_ATTR_SUM_SHALE    = 70.0f;

// Human Warrior
const float AF_HW_STR = 15.0f;
const float AF_HW_DEX = 14.0f;
const float AF_HW_WIL = 10.0f;
const float AF_HW_MAG = 11.0f;
const float AF_HW_INT = 11.0f;
const float AF_HW_CON = 13.0f;

// Human Mage
const float AF_HM_STR = 11.0f;
const float AF_HM_DEX = 11.0f;
const float AF_HM_WIL = 14.0f;
const float AF_HM_MAG = 16.0f;
const float AF_HM_INT = 12.0f;
const float AF_HM_CON = 10.0f;

// Human Rogue
const float AF_HR_STR = 11.0f;
const float AF_HR_DEX = 15.0f;
const float AF_HR_WIL = 12.0f;
const float AF_HR_MAG = 11.0f;
const float AF_HR_INT = 15.0f;
const float AF_HR_CON = 10.0f;

// Elf Warrior
const float AF_EW_STR = 14.0f;
const float AF_EW_DEX = 13.0f;
const float AF_EW_WIL = 12.0f;
const float AF_EW_MAG = 12.0f;
const float AF_EW_INT = 10.0f;
const float AF_EW_CON = 13.0f;

// Elf Mage
const float AF_EM_STR = 10.0f;
const float AF_EM_DEX = 10.0f;
const float AF_EM_WIL = 16.0f;
const float AF_EM_MAG = 17.0f;
const float AF_EM_INT = 11.0f;
const float AF_EM_CON = 10.0f;

// Elf Rogue
const float AF_ER_STR = 10.0f;
const float AF_ER_DEX = 14.0f;
const float AF_ER_WIL = 14.0f;
const float AF_ER_MAG = 12.0f;
const float AF_ER_INT = 14.0f;
const float AF_ER_CON = 10.0f;

// Dwarf Warrior
const float AF_DW_STR = 15.0f;
const float AF_DW_DEX = 14.0f;
const float AF_DW_WIL = 10.0f;
const float AF_DW_MAG = 10.0f;
const float AF_DW_INT = 10.0f;
const float AF_DW_CON = 15.0f;

// Dwarf Rogue
const float AF_DR_STR = 11.0f;
const float AF_DR_DEX = 15.0f;
const float AF_DR_WIL = 12.0f;
const float AF_DR_MAG = 10.0f;
const float AF_DR_INT = 14.0f;
const float AF_DR_CON = 12.0f;

// Qunari Warrior
const float AF_QN_STR = 14.0f;
const float AF_QN_DEX = 13.0f;
const float AF_QN_WIL = 10.0f;
const float AF_QN_MAG = 10.0f;
const float AF_QN_INT = 10.0f;
const float AF_QN_CON = 13.0f;

// Mabari Warhound
const float AF_DG_STR = 12.0f;
const float AF_DG_DEX = 12.0f;
const float AF_DG_WIL = 10.0f;
const float AF_DG_MAG = 10.0f;
const float AF_DG_INT = 10.0f;
const float AF_DG_CON = 16.0f;

// Shale DLC extra character
const float AF_SH_STR = 14.0f;
const float AF_SH_DEX = 13.0f;
const float AF_SH_WIL = 10.0f;
const float AF_SH_MAG = 10.0f;
const float AF_SH_INT = 10.0f;
const float AF_SH_CON = 13.0f;


////
// Helper functions to retrieve attributes
////

/** @brief Retrieves the base strength of a creature
* @param oCreature - The creature
* @author weriK
**/
float AF_GetStr(object oCreature)
{
    return IntToFloat(GetCreatureAttribute(oCreature, PROPERTY_ATTRIBUTE_STRENGTH, PROPERTY_VALUE_BASE));
}

/** @brief Retrieves the base dexterity of a creature
* @param oCreature - The creature
* @author weriK
**/
float AF_GetDex(object oCreature)
{
    return IntToFloat(GetCreatureAttribute(oCreature, PROPERTY_ATTRIBUTE_DEXTERITY, PROPERTY_VALUE_BASE));
}

/** @brief Retrieves the base willpower of a creature
* @param oCreature - The creature
* @author weriK
**/
float AF_GetWil(object oCreature)
{
    return IntToFloat(GetCreatureAttribute(oCreature, PROPERTY_ATTRIBUTE_WILLPOWER, PROPERTY_VALUE_BASE));
}

/** @brief Retrieves the base magic of a creature
* @param oCreature - The creature
* @author weriK
**/
float AF_GetMag(object oCreature)
{
    return IntToFloat(GetCreatureAttribute(oCreature, PROPERTY_ATTRIBUTE_MAGIC, PROPERTY_VALUE_BASE));
}

/** @brief Retrieves the base intellect/cunning of a creature
* @param oCreature - The creature
* @author weriK
**/
float AF_GetInt(object oCreature)
{
    return IntToFloat(GetCreatureAttribute(oCreature, PROPERTY_ATTRIBUTE_INTELLIGENCE, PROPERTY_VALUE_BASE));
}

/** @brief Retrieves the base constitution of a creature
* @param oCreature - The creature
* @author weriK
**/
float AF_GetCon(object oCreature)
{
    return IntToFloat(GetCreatureAttribute(oCreature, PROPERTY_ATTRIBUTE_CONSTITUTION, PROPERTY_VALUE_BASE));
}

/** @brief Sets all 6 attributes to the specified value
* @param oCreature - The creature
* @param fStr    - Specifies the strength attribute's value, 1.0f by default.
* @param fDex    - Specifies the dexterity attribute's value, 1.0f by default.
* @param fWil    - Specifies the willpower attribute's value, 1.0f by default.
* @param fMag    - Specifies the magic attribute's value, 1.0f by default.
* @param fInt    - Specifies the intelligence(cunning) attribute's value, 1.0f by default.
* @param fCon    - Specifies the constitution attribute's value, 1.0f by default.
* @author weriK
**/
void AF_SetAllBaseAttributes(object oCreature,
                              float fStr = 1.0f,
                              float fDex = 1.0f,
                              float fWil = 1.0f,
                              float fMag = 1.0f,
                              float fInt = 1.0f,
                              float fCon = 1.0f)
{
    SetCreatureProperty( oCreature, PROPERTY_ATTRIBUTE_STRENGTH, fStr, PROPERTY_VALUE_BASE);
    SetCreatureProperty( oCreature, PROPERTY_ATTRIBUTE_DEXTERITY, fDex, PROPERTY_VALUE_BASE);
    SetCreatureProperty( oCreature, PROPERTY_ATTRIBUTE_WILLPOWER, fWil, PROPERTY_VALUE_BASE);
    SetCreatureProperty( oCreature, PROPERTY_ATTRIBUTE_MAGIC, fMag, PROPERTY_VALUE_BASE);
    SetCreatureProperty( oCreature, PROPERTY_ATTRIBUTE_INTELLIGENCE, fInt, PROPERTY_VALUE_BASE);
    SetCreatureProperty( oCreature, PROPERTY_ATTRIBUTE_CONSTITUTION, fCon, PROPERTY_VALUE_BASE);
}

/** @brief Sets an attribute to the specified value
* @param oCreature - The creature
* @param nProp     - The ID of the attribute we wish to change
* @param fValue    - Specifies the attribute value, 1.0f by default.
* @author weriK
**/
void AF_SetBaseAttribute(object oCreature, int nProp, float fValue = 1.0f)
{
    SetCreatureProperty( oCreature, nProp, fValue, PROPERTY_VALUE_BASE);
}

/** @brief Gives a specified amount of attribute points to the creature
* @param oCreature - The creature
* @param fValue    - Specifies the amount, 1.0f by default.
* @author weriK
**/
void AF_GiveAttributePoints(object oCreature, float fValue = 1.0f)
{
    // First check if the character has unassigned attribute points
    float fUnassigned = IntToFloat(GetCreatureAttribute(oCreature, PROPERTY_SIMPLE_ATTRIBUTE_POINTS, PROPERTY_VALUE_TOTAL));

    // Now we can give attribute points to the character
    SetCreatureProperty(oCreature, PROPERTY_SIMPLE_ATTRIBUTE_POINTS, fValue+fUnassigned);
}

/** @brief Gives a specified amount of skill points to the creature
* @param oCreature - The creature
* @param fValue    - Specifies the amount, 1.0f by default.
* @author weriK
**/
void AF_GiveSkillPoints(object oCreature, float fValue = 1.0f)
{
    float fUnassigned = IntToFloat(GetCreatureAttribute(oCreature, PROPERTY_SIMPLE_SKILL_POINTS, PROPERTY_VALUE_TOTAL));
    SetCreatureProperty(oCreature, PROPERTY_SIMPLE_SKILL_POINTS, fValue+fUnassigned);
}

/** @brief Gives a specified amount of spell/talent points to the creature
* @param oCreature - The creature
* @param fValue    - Specifies the amount, 1.0f by default.
* @author weriK
**/
void AF_GiveTalentPoints(object oCreature, float fValue = 1.0f)
{
    float fUnassigned = IntToFloat(GetCreatureAttribute(oCreature, PROPERTY_SIMPLE_TALENT_POINTS, PROPERTY_VALUE_TOTAL));
    SetCreatureProperty(oCreature, PROPERTY_SIMPLE_TALENT_POINTS, fValue+fUnassigned);
}

/** @brief Gives a specified amount of specialization points to the creature
* @param oCreature - The creature
* @param fValue    - Specifies the amount, 1.0f by default.
* @author weriK
**/
void AF_GiveSpecPoints(object oCreature, float fValue = 1.0f)
{
    float fUnassigned = IntToFloat(GetCreatureAttribute(oCreature, 38, PROPERTY_VALUE_TOTAL));
    SetCreatureProperty(oCreature, 38, fValue+fUnassigned);  // 38 is the spec point ID

}

/** @brief Resets the specified specialization if the creature has it and returns a specialization point
* @param oCreature - The creature
* @param iSpec     - Property ID of the specialization
* @author weriK
**/
void AF_FreeSpecialization(object oCreature, int iSpec)
{
    // Check whether the creature currently has the specialization learned
    // if it does, we remove it and give one spec point in return
    if ( HasAbility(oCreature, iSpec) )
    {
        RemoveAbility(oCreature, iSpec);
        AF_GiveSpecPoints(oCreature);
    }
}

/** @brief Clears all abilities in the creatures quickslots
* @param oCreature - The creature
* @author weriK
**/
void AF_ClearQuickslots(object oCreature)
{
    int i;
    for ( i = 0; i< 256; i++ )
        SetQuickslot(oCreature, i, 0);
}

/** @brief Loops through an ability array and resets spells and talents
*
*   Looping through a given array that
*   contains the id's of every spell and talent ability a character
*   can have. If the character has an abbility, it removes that,
*   and in return grants an extra /talent point.
*
* @param arAbilityID - Array of ability IDs we want to test against
* @param oCharacter  - The character
* @author weriK
**/
void _AF_RespecLoopAbility(int[] arAbilityID, object oCharacter) {
    int iCount = GetArraySize(arAbilityID);
    AF_LogInfo("Number of skills: " + IntToString(iCount), AF_LOGGROUP_RESPEC);

    int i;
    for (i = 0; i < iCount; i++) {
        AF_LogDebug("   Checking ability: " + IntToString(arAbilityID[i]), AF_LOGGROUP_RESPEC);
        // Check whether the character has the talent
        if ( HasAbility(oCharacter, arAbilityID[i]) ) {
            AF_LogInfo("   Ability on char: " + IntToString(arAbilityID[i]), AF_LOGGROUP_RESPEC);
           // Check whether it's a modal ability
            // If it is true, then disable it prior to removing
            if (Ability_IsModalAbility(arAbilityID[i]))
                Ability_DeactivateModalAbility(oCharacter, arAbilityID[i], GetAbilityType(arAbilityID[i]));

            // Unlearn the talent
            RemoveAbility(oCharacter, arAbilityID[i]);
            AF_GiveTalentPoints(oCharacter, 1.0f);
        } // ! if
    } // ! for
}


/** @brief Loops through an ability array and resets skills
*
*   Looping through a given array that
*   contains the id's of every skill Ability a character
*   can have. If the character has an ability, it removes it,
*   and in return grants an extra skill point.
*
* @param arAbilityID - Array of ability IDs we want to test against
* @param oCharacter  - The character
* @author weriK
**/
void _AF_RespecLoopSkill(int[] arAbilityID, object oCharacter){
    int iCount = GetArraySize(arAbilityID);
    AF_LogInfo("Number of skills: " + IntToString(iCount), AF_LOGGROUP_RESPEC);

    int i;
    for (i = 0; i < iCount; i++) {
        AF_LogDebug("   Checking skill: " + IntToString(arAbilityID[i]), AF_LOGGROUP_RESPEC);
        // Check whether the character has the talent
        if ( HasAbility(oCharacter, arAbilityID[i]) ) {
            AF_LogInfo("   Skill on char: " + IntToString(arAbilityID[i]), AF_LOGGROUP_RESPEC);
            // Unlearn the talent
            RemoveAbility(oCharacter, arAbilityID[i]);
            AF_GiveSkillPoints(oCharacter, 1.0f);
        }
    }
}


/** @brief Resets the spell & talent points on a character
*
*   This is the main function for resetting all spell & talent points
*   on a character. It contains arrays with all the ability
*   ID's it is testing against. More elements can be added to the
*   array every time to extend the list of abilities it checks
*
* @param oCharacter - The character
* @author weriK
**/
void AF_RespecAbilities(object oCharacter) {
    // Ok this part is well *cough* not very fun
    // *wave* to bioware for a GetLearnedAbilitiesArray() function

    ////
    // WARRIOR TALENTS master table
    ////

    int[] AF_ABILITIES_WARRIOR;
    int iWarr = 0;

    // Champion
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_SUPERIORITY;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_MOTIVATE;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_RALLY;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_WAR_CRY;

    // Berserker
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_FINAL_BLOW;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_CONSTRAINT;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_RESILIENCE;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_BERSERK;

    // Templar
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_HOLY_SMITE;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_MENTAL_FORTRESS;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_CLEANSE_AREA;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_RIGHTEOUS_STRIKE;

    // Reaver
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_BLOOD_FRENZY;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_PAIN;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_FRIGHTENING;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_DEVOUR;

    // Warrior
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_DEATH_BLOW;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_BRAVERY;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_THREATEN;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_POWERFUL;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_PERFECT_STRIKE;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_DISENGAGE;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_TAUNT;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_PRECISE_STRIKING;

    // Dual Weapon
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_DUAL_WEAPON_MASTER;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_DUAL_WEAPON_EXPERT;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_DUAL_WEAPON_FINESSE;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_DUAL_WEAPON_TRAINING;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_DUAL_WEAPON_PUNISHER;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_DUAL_WEAPON_CRIPPLE;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_DUAL_WEAPON_RIPOSTE;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_DUAL_WEAPON_DOUBLE_STRIKE ;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_DUAL_WEAPON_WHIRLWIND;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_DUAL_WEAPON_MOMENTUM;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_DUAL_WEAPON_FLURRY;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_DUAL_WEAPON_SWEEP;

    // Archery
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_MASTER_ARCHER;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_DEFENSIVE_FIRE;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_AIM;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_MELEE_ARCHER;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_ARROW_OF_SLAYING;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_CRITICAL_SHOT;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_CRIPPLING_SHOT;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_PINNING_SHOT;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_SCATTERSHOT;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_SUPPRESSING_FIRE;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_SHATTERING_SHOT;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_RAPIDSHOT;

    // Weapon and Shield
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_ASSAULT;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_OVERPOWER;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_SHIELD_PUMMEL;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_SHIELD_BASH;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_SHIELD_EXPERTISE;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_SHIELD_WALL;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_SHIELD_BALANCE;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_SHIELD_DEFENSE;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_SHIELD_MASTERY;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_SHIELD_TACTICS;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_SHIELD_COVER;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_SHIELD_BLOCK;

    // Two-Handed
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_CRITICAL_STRIKE;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_STUNNING_BLOWS;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_INDOMITABLE;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_POMMEL_STRIKE;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_DESTROYER;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_SUNDER_ARMOR;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_SHATTERING_BLOWS;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_SUNDER_ARMS;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_TWO_HANDED_SWEEP;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_TWO_HANDED_STRENGTH;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_POWERFUL_SWINGS;
    AF_ABILITIES_WARRIOR[iWarr++] = AF_ABILITY_MIGHTY_BLOW;

    ////
    // ROGUE TALENTS master table
    ////

    int[] AF_ABILITIES_ROGUE;
    int iRogue = 0;

    // Assassin
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_FEAST_OF_THE_FALLEN;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_LACERATE;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_EXPLOIT_WEAKNESS;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_MARK_OF_DEATH;

    // Bard
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_CAPTIVATING_SONG;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_SONG_OF_COURAGE;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_DISTRACTION;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_SONG_OF_VALOR;

    // Ranger
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_MASTER_RANGER;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_SUMMON_SPIDER;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_SUMMON_BEAR;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_SUMMON_WOLF;

    // Duelist
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_PINPOINT_STRIKE;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_KEEN_DEFENSE;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_UPSET_BALANCE;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_DUELING;

    // Rogue Part 1
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_FEIGN_DEATH;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_COUP_DE_GRACE;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_COMBAT_MOVEMENT;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_DIRTY_FIGHTING;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_EVASION;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_LETHALITY;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_DEADLY_STRIKE;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_BELOW_THE_BELT;


    // Dual Weapon
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_DUAL_WEAPON_MASTER;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_DUAL_WEAPON_EXPERT;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_DUAL_WEAPON_FINESSE;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_DUAL_WEAPON_TRAINING;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_DUAL_WEAPON_PUNISHER;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_DUAL_WEAPON_CRIPPLE;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_DUAL_WEAPON_RIPOSTE;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_DUAL_WEAPON_DOUBLE_STRIKE ;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_DUAL_WEAPON_WHIRLWIND;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_DUAL_WEAPON_MOMENTUM;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_DUAL_WEAPON_FLURRY;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_DUAL_WEAPON_SWEEP;

    // Archery
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_MASTER_ARCHER;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_DEFENSIVE_FIRE;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_AIM;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_MELEE_ARCHER;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_ARROW_OF_SLAYING;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_CRITICAL_SHOT;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_CRIPPLING_SHOT;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_PINNING_SHOT;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_SCATTERSHOT;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_SUPPRESSING_FIRE;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_SHATTERING_SHOT;
    AF_ABILITIES_ROGUE[iRogue++] = AF_ABILITY_RAPIDSHOT;

    // Rogue - Part 2
    AF_ABILITIES_ROGUE[iRogue++] = ABILITY_SKILL_LOCKPICKING_4;    // THis is Device Mastery
    AF_ABILITIES_ROGUE[iRogue++] = ABILITY_SKILL_LOCKPICKING_3;    // Mechanical Expertise
    AF_ABILITIES_ROGUE[iRogue++] = ABILITY_SKILL_LOCKPICKING_2;    // Improved Tools
    AF_ABILITIES_ROGUE[iRogue++] = ABILITY_SKILL_LOCKPICKING_1;    // Deft Hands
    AF_ABILITIES_ROGUE[iRogue++] = ABILITY_SKILL_STEALTH_4;        // Master Stealth
    AF_ABILITIES_ROGUE[iRogue++] = ABILITY_SKILL_STEALTH_3;        // Combat Stealth
    AF_ABILITIES_ROGUE[iRogue++] = ABILITY_SKILL_STEALTH_2;        // Stealthy Item Use
    AF_ABILITIES_ROGUE[iRogue++] = ABILITY_SKILL_STEALTH_1;        // Stealth

    ////
    // MAGE TALENTS master table
    ////

    int[] AF_ABILITIES_MAGE;
    int iMage = 0;

    // Arcane Warrior
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_FADE_SHROUD;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_SHIMMERING_SHIELD;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_AURA_OF_MIGHT;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_COMBAT_MAGIC;


    // Blood Mage
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_BLOOD_CONTROL;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_BLOOD_WOUND;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_BLOOD_SACRIFICE;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_BLOOD_MAGIC;


    // Shapeshifter
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_SHAPESHIFTER;   // Master Shapeshifter
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_FLYING_SWARM;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_BEAR;          // Bear Shape
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_SPIDER_SHAPE;

    // Spirit Healer
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_CLEANSING_AURA; // Cleansing Aura
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_LIFEWARD;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_REVIVAL;
    AF_ABILITIES_MAGE[iMage++] = 10509;          // Group Heal

    // Mage
    AF_ABILITIES_MAGE[iMage++] = 200257;                      // Arcane Mastery
    AF_ABILITIES_MAGE[iMage++] = 200256;                      // Staff Focus
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_ARCANE_SHIELD;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_ARCANE_BOLT;

    // Primal
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_INFERNO;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_FIREBALL;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_FLAMING_WEAPONS;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_FLAME_BLAST;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_PETRIFY;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_EARTHQUAKE;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_STONEFIST;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_WALL_OF_STONE; // Rock Armor
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_BLIZZARD;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_CONE_OF_COLD;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_FROSTWALL;     // Frost Weapons
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_WINTERS_GRASP;
    AF_ABILITIES_MAGE[iMage++] = 10211;                       // Chain Lightning
// ---------- TEMPEST (14002) CRASHES WHEN CALLING RemoveAbility() -------------
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_TEMPEST;
// -----------------------------------------------------------------------------
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_SHOCK;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_LIGHTNING;

    // Creation
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_PURIFY;        // Mass Rejuvination
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_REGENERATION;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_CURE;          // Rejuvenate
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_HEAL;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_ARCANE_MIGHT;  // Haste
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_HEROIC_DEFENSE;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_HEROS_ARMOR;   // Heroic Defense
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_HEROIC_OFFENSE;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_GLYPH_OF_NEUTRALIZATION;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_GLYPH_OF_REPULSION;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_GLYPH_OF_WARDING;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_GLYPH_OF_PARALYSIS;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_STINGING_SWARM;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_SPELLBLOOM;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_GREASE;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_SPELL_WISP;

    // Spirit
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_ANTIMAGIC_BURST;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_ANTIMAGIC_WARD;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_SHIELD_PARTY;  // Dispell Magic
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_SPELL_SHIELD;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_MANA_CLASH;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_SPELL_MIGHT;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_MANA_CLEANSE;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_WYNNES_SEAL_PORTAL;// Mana Drain 10704
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_ANIMATE_DEAD;
// ----- VIRULENT WALKING BOMB (12011) CRASHES WHEN CALLING RemoveAbility() ----
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_MASS_CORPSE_DETONATION;    // Virulent Walking Boms 12011
// -----------------------------------------------------------------------------
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_REANIMATE;         // Death Syphon 10500
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_WALKING_BOMB;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_CRUSHING_PRISON;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_MIND_FOCUS;        // Telekinetic Weapons 10209
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_WALL_OF_FORCE;     // Force Field 17019
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_MIND_BLAST;

    // Entropy
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_MASS_PARALYSIS;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_TBD_WAS_DANCE_OF_MADNESS;  // Miasma 11122
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_PARALYZE;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_WEAKNESS;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_IMMOBILIZE;                // Death Hex 11100
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_ROOT;                      // Misdirection hex 11114
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_SLOW;                      // Affliction Hex 11111
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_MASS_SLOW;                 // Vulnerability Hex 11112
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_MIND_ROT;                  // Waking Nightmare 11109
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_SLEEP;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_HORROR;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_DAZE;                      // Disorient 11115
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_DEATH_CLOUD;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_SHARED_FATE;               // Curse of Mortality 11101
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_DEATH_MAGIC;
    AF_ABILITIES_MAGE[iMage++] = ABILITY_SPELL_DRAIN_LIFE;
      
    // Unlock spell
    AF_ABILITIES_MAGE[iMage++] = AF_ABILITY_SPELL_UNLOCK_1;
    AF_ABILITIES_MAGE[iMage++] = AF_ABILITY_SPELL_UNLOCK_2;
    AF_ABILITIES_MAGE[iMage++] = AF_ABILITY_SPELL_UNLOCK_3;

    ////
    // DOG TALENTS master table
    ////

    int[] AF_ABILITIES_DOG;
    int iDog = 0;

    AF_ABILITIES_DOG[iDog++] = AF_ABILITY_DOG_OVERWHELM;
    AF_ABILITIES_DOG[iDog++] = AF_ABILITY_DOG_COMBAT_TRAINING;
    AF_ABILITIES_DOG[iDog++] = AF_ABILITY_DOG_DREAD_HOWL;
    AF_ABILITIES_DOG[iDog++] = AF_ABILITY_DOG_GROWL;
    AF_ABILITIES_DOG[iDog++] = AF_ABILITY_DOG_NEMESIS;
    AF_ABILITIES_DOG[iDog++] = AF_ABILITY_DOG_SHRED;
    AF_ABILITIES_DOG[iDog++] = AF_ABILITY_DOG_CHARGE;
    AF_ABILITIES_DOG[iDog++] = AF_ABILITY_DOG_FORTITUDE;

    ////
    // SHALE TALENTS master table
    // Shale has both the generic warrior and his own set of talents
    ////

    int[] AF_ABILITIES_SHALE;
    int iShale = 0;

    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_KILLING_BLOW;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_QUAKE;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_SLAM;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_PULVERIZING_BLOWS;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_REGENERATING_BURST;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_STONE_ROAR;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_BELLOW;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_STONEHEART;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_ROCK_BARRAGE;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_EARTHEN_GRASP;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_HURL_ROCK;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_ROCK_MASTERY;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_SUPERNATURAL_RESILIENCE;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_RENEWED_ASSAULT;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_INNER_RESERVES;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_STONE_AURA;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_DEATH_BLOW;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_BRAVERY;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_THREATEN;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_POWERFUL;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_PERFECT_STRIKE;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_DISENGAGE;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_TAUNT;
    AF_ABILITIES_SHALE[iShale++] = AF_ABILITY_PRECISE_STRIKING;

    ////
    //  SPECIALIZATION
    ////

    // Remove all the effects so they won't get stuck on
    // the character due to an activated ability that gets
    // removed. Injuries should remain.
    RemoveAllEffects(oCharacter);

    if ( GetCreatureCoreClass(oCharacter) == CLASS_WIZARD ) {
        // Free up the mage talents
        _AF_RespecLoopAbility(AF_ABILITIES_MAGE, oCharacter);

        // Specializations
        AF_FreeSpecialization(oCharacter, AF_ABILITY_ARCANE_WARRIOR);
        AF_FreeSpecialization(oCharacter, AF_ABILITY_BLOOD_MAGE);
        AF_FreeSpecialization(oCharacter, AF_ABILITY_SHAPE_SHIFTER);
        AF_FreeSpecialization(oCharacter, AF_ABILITY_SPIRIT_HEALER);
    } else if ( GetCreatureCoreClass(oCharacter) == CLASS_ROGUE ) {
        // Free up the rogue talents
        _AF_RespecLoopAbility(AF_ABILITIES_ROGUE, oCharacter);

        // Specializations
        AF_FreeSpecialization(oCharacter, AF_ABILITY_ASSASSIN);
        AF_FreeSpecialization(oCharacter, AF_ABILITY_BARD);
        AF_FreeSpecialization(oCharacter, AF_ABILITY_DUELIST);
        AF_FreeSpecialization(oCharacter, AF_ABILITY_RANGER);

        // Let's make sure we are not stuck in stealth
        if (IsStealthy(oCharacter) == TRUE)
            DropStealth(oCharacter);
    } else if ( GetCreatureCoreClass(oCharacter) == CLASS_WARRIOR ) {
        // Shale is a warrior too, could check for race too,
        // but this is more specific. Shale has no specialization
        if ( GetName(oCharacter) == "Shale" ) {
            _AF_RespecLoopAbility(AF_ABILITIES_SHALE, oCharacter);
        } else {
            // Free up the warrior talents
            _AF_RespecLoopAbility(AF_ABILITIES_WARRIOR, oCharacter);

            // Specializations
            AF_FreeSpecialization(oCharacter, AF_ABILITY_CHAMPION);
            AF_FreeSpecialization(oCharacter, AF_ABILITY_TEMPLAR);
            AF_FreeSpecialization(oCharacter, AF_ABILITY_BERSERKER);
            AF_FreeSpecialization(oCharacter, AF_ABILITY_REAVER);
        }
    } else if ( GetCreatureCoreClass(oCharacter) == CLASS_DOG ) {
        // Free up the dog talents
        _AF_RespecLoopAbility(AF_ABILITIES_DOG, oCharacter);
    } else if ( GetCreatureCoreClass(oCharacter) == CLASS_SHALE ) {
        // Free up shale's talents
        _AF_RespecLoopAbility(AF_ABILITIES_SHALE, oCharacter);
    }

} // ! AF_RespecAbilities


/** @brief Resets the attribute points
*
*   This function frees the previous allocated attribute
*   points. It sets every attribute to fValue ( must be between 1.0f
*   and SumOfAllAttributePoints/6) and allows the player to reassign
*   the rest of the points.
*
* @param oCharacter - Character
* @param fValue     - Starting value of every attribute after reset
* @author weriK
**/
void AF_RespecAttributes(object oCharacter, float fValue = 1.0f)
{
    // Retrieve the base attribute values and
    // calculate the total amount we will have to give back to the player.
    float fStr = AF_GetStr(oCharacter);
    float fDex = AF_GetDex(oCharacter);
    float fWil = AF_GetWil(oCharacter);
    float fMag = AF_GetMag(oCharacter);
    float fInt = AF_GetInt(oCharacter);
    float fCon = AF_GetCon(oCharacter);
    float fSum = fStr+fDex+fWil+fMag+fInt+fCon;

    // Retrieve the character's race and core class
    int iRace  = GetCreatureRacialType(oCharacter);

    // Retrieve the character's core class
    int iClass = GetCreatureCurrentClass(oCharacter);

    ////
    //  HUMANOIDS
    ////
    switch (iRace) {
        // Humans
        case RACE_HUMAN: {
            switch (iClass) {
                case CLASS_ROGUE: {
                    AF_SetAllBaseAttributes(oCharacter, AF_HR_STR, AF_HR_DEX, AF_HR_WIL, AF_HR_MAG, AF_HR_INT, AF_HR_CON);
                    // Return the rest of the attribute points to the characters.
                    // Every character has AF_START_ATTR_SUM points spent by default
                    // at character generation (excluding the extra 5 you can choose)
                    AF_GiveAttributePoints(oCharacter, fSum-AF_START_ATTR_SUM_HUMANOID);
                    break;
                }
                case CLASS_WARRIOR: {
                    AF_SetAllBaseAttributes(oCharacter, AF_HW_STR, AF_HW_DEX, AF_HW_WIL, AF_HW_MAG, AF_HW_INT, AF_HW_CON);
                    AF_GiveAttributePoints(oCharacter, fSum-AF_START_ATTR_SUM_HUMANOID);
                    break;
                }
                case CLASS_WIZARD: {
                    AF_SetAllBaseAttributes(oCharacter, AF_HM_STR, AF_HM_DEX, AF_HM_WIL, AF_HM_MAG, AF_HM_INT, AF_HM_CON);
                    AF_GiveAttributePoints(oCharacter, fSum-AF_START_ATTR_SUM_HUMANOID);
                    break;
                }
            } // ! switch class
            break;
        } // ! case human

        // Elves
        case RACE_ELF: {
            switch (iClass) {
                case CLASS_ROGUE: {
                    AF_SetAllBaseAttributes(oCharacter, AF_ER_STR, AF_ER_DEX, AF_ER_WIL, AF_ER_MAG, AF_ER_INT, AF_ER_CON);
                    AF_GiveAttributePoints(oCharacter, fSum-AF_START_ATTR_SUM_HUMANOID);
                    break;
                }
                case CLASS_WARRIOR: {
                    AF_SetAllBaseAttributes(oCharacter, AF_EW_STR, AF_EW_DEX, AF_EW_WIL, AF_EW_MAG, AF_EW_INT, AF_EW_CON);
                    AF_GiveAttributePoints(oCharacter, fSum-AF_START_ATTR_SUM_HUMANOID);
                    break;
                }
                case CLASS_WIZARD: {
                    AF_SetAllBaseAttributes(oCharacter, AF_EM_STR, AF_EM_DEX, AF_EM_WIL, AF_EM_MAG, AF_EM_INT, AF_EM_CON);
                    AF_GiveAttributePoints(oCharacter, fSum-AF_START_ATTR_SUM_HUMANOID);
                    break;
                }
            } // ! switch class
            break;
        } // ! case elf

        // Dwarves
        case RACE_DWARF: {
            switch (iClass) {
                case CLASS_ROGUE: {
                    AF_SetAllBaseAttributes(oCharacter, AF_DR_STR, AF_DR_DEX, AF_DR_WIL, AF_DR_MAG, AF_DR_INT, AF_DR_CON);
                    AF_GiveAttributePoints(oCharacter, fSum-AF_START_ATTR_SUM_HUMANOID);
                    break;
                }
                case CLASS_WARRIOR: {
                    AF_SetAllBaseAttributes(oCharacter, AF_DW_STR, AF_DW_DEX, AF_DW_WIL, AF_DW_MAG, AF_DW_INT, AF_DW_CON);
                    AF_GiveAttributePoints(oCharacter, fSum-AF_START_ATTR_SUM_HUMANOID);
                    break;
                }
            } // ! switch class
            break;
        } // ! case dwarf

        // Qunari (Sten)
        case RACE_QUNARI: {
            if (iClass == CLASS_WARRIOR) {
                // Only one class here, Sten is a warrior
                AF_SetAllBaseAttributes(oCharacter, AF_QN_STR, AF_QN_DEX, AF_QN_WIL, AF_QN_MAG, AF_QN_INT, AF_QN_CON);
                AF_GiveAttributePoints(oCharacter, fSum-AF_START_ATTR_SUM_QUNARI);
            }
            break;
        } // ! case qunari

        // Animal
        case RACE_ANIMAL: {
            if (iClass == CLASS_DOG) {
                AF_SetAllBaseAttributes(oCharacter, AF_DG_STR, AF_DG_DEX, AF_DG_WIL, AF_DG_MAG, AF_DG_INT, AF_DG_CON);
                AF_GiveAttributePoints(oCharacter, fSum-AF_START_ATTR_SUM_DOG);
            }
            break;
        } // ! case animal

        // Golem (Shale)
        case RACE_GOLEM: {
            // NOTE: CLASS_SHALE (16) is not the correct class
            if (iClass == CLASS_WARRIOR && GetName(oCharacter) == "Shale") {
                AF_SetAllBaseAttributes(oCharacter, AF_SH_STR, AF_SH_DEX, AF_SH_WIL, AF_SH_MAG, AF_SH_INT, AF_SH_CON);
                AF_GiveAttributePoints(oCharacter, fSum-AF_START_ATTR_SUM_SHALE);
            }
            break;
        } // ! case golem

        break;

    } // ! switch race
}

/** @brief Resets the skill points on a character
*
*   This is the main function for resetting all skill points
*   on a character. It contains an Array with all the ability
*   ID's it is testing against. More elements can be added to the
*   array every time to extend the list of abilities it checks
*
* @param oCharacter - The character
* @author weriK
**/
void AF_RespecSkills(object oCharacter) {
    // Master list of all available skills ( 8 rows, 4 ranks, 32 skill points max )
    int[] aSkillList;
    int iSkill =0;

    // Coercion (Only the hero has this)
    aSkillList[iSkill++] = AF_ABILITY_MASTER_COERCION;
    aSkillList[iSkill++] = AF_ABILITY_EXPERT_COERCION;
    aSkillList[iSkill++] = AF_ABILITY_IMPROVED_COERCION;
    aSkillList[iSkill++] = AF_ABILITY_COERCION;

    aSkillList[iSkill++] = AF_ABILITY_MASTER_STEALING;
    aSkillList[iSkill++] = AF_ABILITY_EXPERT_STEALING;
    aSkillList[iSkill++] = AF_ABILITY_IMPROVED_STEALING;
    aSkillList[iSkill++] = AF_ABILITY_STEALING;

    aSkillList[iSkill++] = AF_ABILITY_MASTER_TRAP_MAKING;
    aSkillList[iSkill++] = AF_ABILITY_EXPERT_TRAP_MAKING;
    aSkillList[iSkill++] = AF_ABILITY_IMPROVED_TRAP_MAKING;
    aSkillList[iSkill++] = AF_ABILITY_TRAP_MAKING;

    aSkillList[iSkill++] = AF_ABILITY_MASTER_SURVIVAL;
    aSkillList[iSkill++] = AF_ABILITY_EXPERT_SURVIVAL;
    aSkillList[iSkill++] = AF_ABILITY_IMPROVED_SURVIVAL;
    aSkillList[iSkill++] = AF_ABILITY_SURVIVAL;

    aSkillList[iSkill++] = AF_ABILITY_MASTER_HERBALISM;
    aSkillList[iSkill++] = AF_ABILITY_EXPERT_HERBALISM;
    aSkillList[iSkill++] = AF_ABILITY_IMPROVED_HERBALISM;
    aSkillList[iSkill++] = AF_ABILITY_HERBALISM;

    aSkillList[iSkill++] = AF_ABILITY_MASTER_POISON_MAKING;
    aSkillList[iSkill++] = AF_ABILITY_EXPERT_POISON_MAKING;
    aSkillList[iSkill++] = AF_ABILITY_IMPROVED_POISON_MAKING;
    aSkillList[iSkill++] = AF_ABILITY_POISON_MAKING;

    aSkillList[iSkill++] = AF_ABILITY_MASTER_COMBAT_TRAINING;
    aSkillList[iSkill++] = AF_ABILITY_EXPERT_COMBAT_TRAINING;
    aSkillList[iSkill++] = AF_ABILITY_IMPROVED_COMBAT_TRAINING;
    aSkillList[iSkill++] = AF_ABILITY_COMBAT_TRAINING;

    aSkillList[iSkill++] = AF_ABILITY_MASTER_COMBAT_TACTICS;
    aSkillList[iSkill++] = AF_ABILITY_EXPERT_COMBAT_TACTICS;
    aSkillList[iSkill++] = AF_ABILITY_IMPROVED_COMBAT_TACTICS;
    aSkillList[iSkill++] = AF_ABILITY_COMBAT_TACTICS;


    // From the SpellShaping mod
    aSkillList[iSkill++] = AF_ABILITY_SPELLSHAPING;
    aSkillList[iSkill++] = AF_ABILITY_IMPROVED_SPELLSHAPING;
    aSkillList[iSkill++] = AF_ABILITY_EXPERT_SPELLSHAPING;
    aSkillList[iSkill++] = AF_ABILITY_MASTER_SPELLSHAPING;

    // This will loop through the whole skill list array and free up any skill
    // point that is taken. Shale has no assignable skills even though she does have
    // COMBAT_TACTICS_1 hidden. Because of this we want to skip her.
    if ( GetName(oCharacter) != "Shale"  ) {
        _AF_RespecLoopSkill(aSkillList, oCharacter);

        // Recalculate the amount of available tactics due to the loss of Combat Tactics
        Chargen_SetNumTactics(oCharacter);
    }
}

void _AF_RespecCharacter(object oCharacter)
{
    // Before anything we must to clear the quickslots
    // This was the cause of mage and Morrigan crashes
    AF_ClearQuickslots(oCharacter);

    // Respec the spells
    AF_RespecAbilities(oCharacter);

    // Respec the skills
    AF_RespecSkills(oCharacter);

    // Respec the attributes
    AF_RespecAttributes(oCharacter);

    // Notify the GUI that we have free points to spend and
    // play the level up animation
    SetCanLevelUp(oCharacter, Chargen_HasPointsToSpend(oCharacter));
    ApplyEffectVisualEffect(oCharacter, oCharacter, 30023, EFFECT_DURATION_TYPE_INSTANT, 0.0f, 0);

    // Add a bit of random RP
    string[] sRPText;
    sRPText[0] = GetStringByStringId(6610078);
    sRPText[1] = GetStringByStringId(6610079);
    sRPText[2] = GetStringByStringId(6610080);
    sRPText[3] = GetStringByStringId(6610081);
    sRPText[4] = GetStringByStringId(6610082);
    sRPText[5] = GetStringByStringId(6610083);
    DisplayFloatyMessage(oCharacter, sRPText[Random(6)], FLOATY_MESSAGE, 16777215, 5.0f);

    // Remove a potion from the shared inventory every time we use one.
    UT_RemoveItemFromInventory(AF_ITR_RESPEC_POTION, 1, GetHero());

} // ! AF_RespecCharacter


/**
* @brief Handle the respec potion popup event
*
* @return TRUE if the event is handled; FALSE otherwise
*/
int AF_RespecPopupEventHandler(event ev) {

    int nPopupID  = GetEventInteger(ev, 0);  // popup ID (references a row in popups 2da)

    // Check that this is our popup
    if (nPopupID != AF_POPUP_RESPEC_CHAR)
        return FALSE;

    // Only proceed if we want to use the potion now
    // Every other case we ignore
    if (!AF_IsModuleFlagSet(AF_GENERAL_FLAG, AF_GENERAL_RESPEC_USE))
        return FALSE;

    // Retrieve the object which fired the potion ability
    // We stored this party member in MODULE_COUNTER_1
    object[] aPartyList = GetPartyList();
    int nPartyMember = GetLocalInt(GetModule(), AF_VAR_CHAR_RESPEC);

    // Retrieve the result of the dialog box
    int nResult = GetEventInteger(ev, 1);

    // If the user pressed yes (Button ID: 1) we respec this character
    if ( nResult == 1 )
        _AF_RespecCharacter(aPartyList[nPartyMember]);

    // Either way, we want to reset the flag
    AF_SetModuleFlag(AF_GENERAL_FLAG, AF_GENERAL_RESPEC_USE, FALSE);

    return TRUE;
}