#ifndef MK_COMMAND_DEACTIVATE_ALMOST_ALL_MODAL_ABILITIES_H
#defsym MK_COMMAND_DEACTIVATE_ALMOST_ALL_MODAL_ABILITIES_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/*Core*/
#include "ai_main_h_2"
/*Advanced Tactics*/
#include "at_tools_ai_h"
#include "at_tools_constants_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
command _MK_AI_DeactivateAlmostAllModalAbilities(object oTarget = OBJECT_SELF);
int MK_AddToQueueDeactivateStances(object oTarget);

//==============================================================================
//                                DEFINITIONS
//==============================================================================
int MK_AddToQueueDeactivateStances(object oTarget)
{

    //DisplayFloatyMessage(OBJECT_SELF, "_MK_AI_Deactivate", FLOATY_MESSAGE, 0x888888, 5.0f);
    int[] arrModalAbilitiesToDeactivate;
    int size = 0;

    //Warrior
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_THREATEN;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_PRECISE_STRIKING;
    //Dual Weapon
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_DUAL_WEAPON_DOUBLE_STRIKE;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_DUAL_WEAPON_MOMENTUM;
    //Archery
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_AIM;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_DEFENSIVE_FIRE;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_RAPIDSHOT;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_SUPPRESSING_FIRE;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_ACCURACY;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_ARROW_TIME;
    ///Weapon and Shield
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_SHIELD_DEFENSE;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_SHIELD_WALL;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_SHIELD_COVER;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_JUGGERNAUT;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_CARAPACE;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_AIR_OF_INSOLENCE;
    //Two-Handed
    //arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_INDOMITABLE;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_POWERFUL_SWINGS;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_TWO_HANDED_IMPACT;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_REAVING_STORM;
    //Rogue Specializations
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_SONG_OF_VALOR;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_SONG_OF_COURAGE;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_CAPTIVATE;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_DUELING;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_ENDURE_HARDSHIP;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_SHADOW_FORM;
    //Warrior Specializations
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_BERSERK;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_PAIN;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_RALLY;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_AURA_OF_THE_STALWART_DEFENDER;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_BEYOND_THE_VEIL;
    //Shale
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_PULVERIZING_BLOWS;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_STONEHEART;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_ROCK_MASTERY;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_STONE_AURA;
    //Arcane
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_ARCANE_SHIELD;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_ELEMENTAL_MASTERY;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_REPULSION_FIELD;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_INVIGORATE;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_ARCANE_FIELD;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_MYSTICAL_NEGATION;
    //Primal
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_FLAMING_WEAPONS;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_ROCK_ARMOR;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_FROST_WEAPONS;
    //Creation
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_HASTE;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_SPELL_WISP;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_SPELLBLOOM;
    //Spirit
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_SPELL_SHIELD;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_SPELL_MIGHT;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_DEATH_SYPHON;
    //Entropy
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_MIASMA;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_DEATH_MAGIC;
    //Mage Specializations
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_COMBAT_MAGIC;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_SHIMMERING_SHIELD;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_BLOOD_MAGIC;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_DRAINING_AURA;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_ELEMENTALcHAOS;
    arrModalAbilitiesToDeactivate[size++] = AT_ABILITY_ONE_WITH_NATURE;

    int succesFlag = FALSE;
    int i;
    for(i=0; i < size; i++)
    {
        if( IsModalAbilityActive(oTarget, arrModalAbilitiesToDeactivate[i]) )
        {
            command cDeactivate = CommandUseAbility(arrModalAbilitiesToDeactivate[i], oTarget);
            //cDeactivate = SetCommandFloat(cDeactivate, -1.0, 0);

            AddCommand(oTarget, cDeactivate, FALSE, TRUE);
            //AddCommand(oTarget, CommandWait(1.0));
            succesFlag = TRUE;
        }
    }
    return succesFlag;
}

//added by MkBot:Deactivate almost all modal abilities, except summonig (Ranger and Animate Dead)
command _MK_AI_DeactivateAlmostAllModalAbilities(object oTarget)
{
    int nFlagSucces = MK_AddToQueueDeactivateStances(oTarget);

    command cInvalid;
    return cInvalid;

}
#endif