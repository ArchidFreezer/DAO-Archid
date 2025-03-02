#ifndef MK_ADD_COMMAND_H
#defsym MK_ADD_COMMAND_H
//==============================================================================
//                              INCLUDES
//==============================================================================
/* Core */
#include "ai_main_h_2"
#include "mk_cond_tools_h"
/* MkBot*/
#include "mk_ability_mutex_h"
#include "log_commands_h"
#include "mk_abilityidtostring_h"
#include "mk_test_framework_h"

//==============================================================================
//                          CONSTANTS
//==============================================================================
const int MK_WEAPON_STYLE_NONE = 0;
const int MK_WEAPON_STYLE_SINGLE = 1;
const int MK_WEAPON_STYLE_DUAL = 2;
const int MK_WEAPON_STYLE_TWO_HANDED = 3;
const int MK_WEAPON_STYLE_RANGED = 4;
const int MK_WEAPON_STYLE_WAND = 5;
//0 - none, 1 - single (with or without shield), 2 - dual, 3 - two handed)

//==============================================================================
//                          DECLARATIONS
//==============================================================================
int MK_AbilityIsWarriorStance(int nAbilityId);
int MK_AbilityIsShieldReq(int nAbilityId);
int MK_AbilityIsTwoHandWeaponReq(int nAbilityId);
int MK_AbilityIsDualWeaponsReq(int nAbilityId);
int MK_AbilityIsRangedReq(int nAbilityId);

int MK_GetWeaponStyle(object oCreature, int nWeaponSet);
int MK_IsWeaponStyleRanged(int nWeaponStyle);
int MK_IsWeaponStyleMelee(int nWeaponStyle);

void MK_AddCommand(object oObject, command cCommand, int bAddToFront = FALSE, int bStatic = FALSE,
    int nOverrideAddBehavior = -1, float fTimeout = 0.0);

void _MK_FixUpkeepBug(object oCreature, int nWeaponStyle1, int nWeaponStyle2);



//==============================================================================
//                          DEFINITIONS
//==============================================================================


/** @brief Wrapper for AddCommand. Use only for followers
*
* Dedicated function for adding command for followers. It supports fTimeout
* parameter (WR_AddCommand do not, which is not documented) and includes UpkeepBugFix
*
*
* @param Parameter1 - 1st Parameter
* @param Patameter2 - 2nd Parameter
* @returns
* @author MkBot
**/
void MK_AddCommand(object oObject,
                   command cCommand,
                   int bAddToFront,
                   int bStatic,
                   int nOverrideAddBehavior,
                   float fTimeout)
{
    if (!IsObjectValid(oObject))
        return;

    int nCommandType = GetCommandType(cCommand);
    if (nCommandType == COMMAND_TYPE_INVALID)
        return;

    if (fTimeout > 0.0)
        cCommand = SetCommandFloat(cCommand, fTimeout, 5);

    AddCommand(oObject, cCommand, bAddToFront, bStatic, nOverrideAddBehavior);

    if (nCommandType == COMMAND_TYPE_USE_ABILITY)
    {
        int nAbilityId = GetCommandInt(cCommand, 0);
        object oTarget = GetCommandObject(cCommand, 0);
        MK_SetAbilityLock(nAbilityId, oTarget);
    }

    if (nCommandType == COMMAND_TYPE_SWITCH_WEAPON_SETS)
    {
        int nActiveWeaponSet   = GetActiveWeaponSet(oObject);
        int nInactiveWeaponSet = (nActiveWeaponSet == 1)? 0 : 1;

        int nActiveStyle   = MK_GetWeaponStyle(oObject, nActiveWeaponSet);
        int nInactiveStyle = MK_GetWeaponStyle(oObject, nInactiveWeaponSet);

         _MK_FixUpkeepBug(oObject, nActiveStyle, nInactiveStyle);

        // Reset Current Attack Target when switching between ranged and melee
        int bActiveStyleRanged   = MK_IsWeaponStyleRanged(nActiveStyle);
        int bInactiveStyleRanged = MK_IsWeaponStyleRanged(nInactiveStyle);
        int bBothStylesRanged = bActiveStyleRanged && bInactiveStyleRanged;
        int bBothStylesMelee  = !bActiveStyleRanged && !bInactiveStyleRanged;

        int bResetCurrentAttackTarget = !bBothStylesRanged && !bBothStylesMelee;
        if (bResetCurrentAttackTarget)
            AddCommand(oObject, CommandAttack(OBJECT_INVALID), bAddToFront, bStatic, COMMAND_ADDBEHAVIOR_DONTCLEAR);
    }


    return;
}

/** @brief Fix Upkeep Bug when switching weapon. Turns off all modal abilities not supported by your new Wepon Style.
*
* When you have activated modal abilities and you switch to diffrent weapon style
* (e.g. from Sword&Shield to Bow) then your max mana/stamina may not be restored
* properly i.e. it will still be reserved eventhough your modal ability is deactivated.
*
* @param oCreature     -
* @param nWeaponStyle1 - see constants : MK_WEAPON_STYLE_
* @param nWeaponStyle2 - see constants : MK_WEAPON_STYLE_
* @author MkBot
**/
void _MK_FixUpkeepBug(object oCreature, int nWeaponStyle1, int nWeaponStyle2)
{
    if (nWeaponStyle1 == nWeaponStyle2)
        return;

    effect[] arrUpkeeps = GetEffects(oCreature, EFFECT_TYPE_UPKEEP);
    int nSize = GetArraySize(arrUpkeeps);

    int i;
    for(i = 0; i < nSize; i++)
    {
        int nAbilityId = GetEffectInteger(arrUpkeeps[i], 1);
        if( MK_AbilityIsWarriorStance(nAbilityId) )
            Ability_DeactivateModalAbility(oCreature, nAbilityId, ABILITY_TYPE_TALENT);

    }
}

void MK_FixUpkeepBug(object oCreature)
{
    effect[] arrUpkeeps = GetEffects(oCreature, EFFECT_TYPE_UPKEEP);
    int nSize = GetArraySize(arrUpkeeps);

    string sAllUpkeeps;
    string sBugUpkeeps;

    int i;
    for(i = 0; i < nSize; i++)
    {
        int nAbilityId = GetEffectInteger(arrUpkeeps[i], 1);
        if (IsModalAbilityActive(oCreature, nAbilityId) == FALSE)
        {
            sBugUpkeeps += IntToString(nAbilityId) + ";";
            Effects_RemoveUpkeepEffect(oCreature, nAbilityId);
        }
        sAllUpkeeps += IntToString(nAbilityId) + ";";
    }
    MK_PrintToLog(sAllUpkeeps);
    MK_PrintToLog(sBugUpkeeps);
}

/** @brief Checks wheter given Weapon Style uses ranged weapon
*
* @param nWeaponStyle - see constants : MK_WEAPON_STYLE_
* @returns            - True/False
* @author MkBot
**/
int MK_IsWeaponStyleRanged(int nWeaponStyle)
{
    return nWeaponStyle == MK_WEAPON_STYLE_RANGED || nWeaponStyle == MK_WEAPON_STYLE_WAND;
}

/** @brief Checks wheter given Weapon Style uses melee weapon
*
* @param nWeaponStyle - see constants : MK_WEAPON_STYLE_
* @returns            - True/False
* @author MkBot
**/
int MK_IsWeaponStyleMelee(int nWeaponStyle)
{
    return !MK_IsWeaponStyleRanged(nWeaponStyle);
}

int MK_GetWeaponStyle(object oCreature, int nWeaponSet )
{

    object oOffHand = GetItemInEquipSlot(INVENTORY_SLOT_OFFHAND, oCreature, nWeaponSet);
    int nOffHandType = GetItemType(oOffHand);

    if( nOffHandType == ITEM_TYPE_WEAPON_MELEE )
        return MK_WEAPON_STYLE_DUAL;

    object oWeapon = GetItemInEquipSlot(INVENTORY_SLOT_MAIN, oCreature, nWeaponSet);
    int nWeaponType = GetItemType(oWeapon);

    if( nWeaponType == ITEM_TYPE_WEAPON_MELEE )
    {
        if( IsMeleeWeapon2Handed(oWeapon) )
            return MK_WEAPON_STYLE_TWO_HANDED;
        else
            return MK_WEAPON_STYLE_SINGLE;
    }

    if( nWeaponType == ITEM_TYPE_WEAPON_RANGED )
        return MK_WEAPON_STYLE_RANGED;

    if( nWeaponType == ITEM_TYPE_WEAPON_WAND )
        return MK_WEAPON_STYLE_WAND;

    return MK_WEAPON_STYLE_NONE;

}

int MK_AbilityIsWarriorStance(int nAbilityId)
{

    int[] arrWarriorStances;
    int nSize = 0;

    arrWarriorStances[nSize++] = AT_ABILITY_SHIELD_DEFENSE;
    arrWarriorStances[nSize++] = AT_ABILITY_SHIELD_WALL;
    arrWarriorStances[nSize++] = AT_ABILITY_SHIELD_COVER;

    arrWarriorStances[nSize++] = AT_ABILITY_INDOMITABLE;
    arrWarriorStances[nSize++] = AT_ABILITY_POWERFUL_SWINGS;

    arrWarriorStances[nSize++] = AT_ABILITY_DUAL_WEAPON_DOUBLE_STRIKE;
    arrWarriorStances[nSize++] = AT_ABILITY_DUAL_WEAPON_MOMENTUM;

    arrWarriorStances[nSize++] = AT_ABILITY_AIM;
    arrWarriorStances[nSize++] = AT_ABILITY_DEFENSIVE_FIRE;
    arrWarriorStances[nSize++] = AT_ABILITY_RAPIDSHOT;
    arrWarriorStances[nSize++] = AT_ABILITY_SUPPRESSING_FIRE;

    int i;
    for(i=0; i<nSize; i++)
    {
        if( nAbilityId == arrWarriorStances[i] )
            return TRUE;
    }

    return FALSE;
}


int MK_AbilityIsShieldReq(int nAbilityId)
{
    int[] arrAbilitiesShield;
    int nSize = 0;
//MkBot: not very fast but easy to read and modify
    arrAbilitiesShield[nSize++] = AT_ABILITY_SHIELD_DEFENSE;
    arrAbilitiesShield[nSize++] = AT_ABILITY_SHIELD_WALL;
    arrAbilitiesShield[nSize++] = AT_ABILITY_SHIELD_COVER;

    arrAbilitiesShield[nSize++] = AT_ABILITY_SHIELD_BASH;
    arrAbilitiesShield[nSize++] = AT_ABILITY_SHIELD_PUMMEL;
    arrAbilitiesShield[nSize++] = AT_ABILITY_OVERPOWER;
    arrAbilitiesShield[nSize++] = AT_ABILITY_ASSAULT;

    int i;
    for(i=0; i<nSize; i++)
    {
        if( nAbilityId == arrAbilitiesShield[i] )
            return TRUE;
    }

    return FALSE;
}

int MK_AbilityIsTwoHandWeaponReq(int nAbilityId)
{
    int[] arrAbilitiesTwoHanded;
    int nSize = 0;
//MkBot: not very fast but easy to read and modify
    arrAbilitiesTwoHanded[nSize++] = AT_ABILITY_INDOMITABLE;
    arrAbilitiesTwoHanded[nSize++] = AT_ABILITY_POWERFUL_SWINGS;

    arrAbilitiesTwoHanded[nSize++] = AT_ABILITY_POMMEL_STRIKE;
    arrAbilitiesTwoHanded[nSize++] = AT_ABILITY_MIGHTY_BLOW;
    arrAbilitiesTwoHanded[nSize++] = AT_ABILITY_SUNDER_WEAPON;
    arrAbilitiesTwoHanded[nSize++] = AT_ABILITY_SUNDER_ARMOR;
    arrAbilitiesTwoHanded[nSize++] = AT_ABILITY_TWO_HANDED_SWEEP;
    arrAbilitiesTwoHanded[nSize++] = AT_ABILITY_CRITICAL_STRIKE;

    int i;
    for(i=0; i<nSize; i++)
    {
        if( nAbilityId == arrAbilitiesTwoHanded[i] )
            return TRUE;
    }

    return FALSE;

}
int MK_AbilityIsDualWeaponsReq(int nAbilityId)
{
    int[] arrAbilitiesDual;
    int nSize = 0;

    arrAbilitiesDual[nSize++] = AT_ABILITY_DUAL_WEAPON_DOUBLE_STRIKE;
    arrAbilitiesDual[nSize++] = AT_ABILITY_DUAL_WEAPON_MOMENTUM;

    arrAbilitiesDual[nSize++] = AT_ABILITY_DUAL_WEAPON_RIPOSTE;
    arrAbilitiesDual[nSize++] = AT_ABILITY_DUAL_WEAPON_CRIPPLE;
    arrAbilitiesDual[nSize++] = AT_ABILITY_DUAL_WEAPON_PUNISHER;
    arrAbilitiesDual[nSize++] = AT_ABILITY_DUAL_WEAPON_SWEEP;
    arrAbilitiesDual[nSize++] = AT_ABILITY_DUAL_WEAPON_FLURRY;
    arrAbilitiesDual[nSize++] = AT_ABILITY_DUAL_WEAPON_WHIRLWIND;

    int i;
    for(i=0; i<nSize; i++)
    {
        if( nAbilityId == arrAbilitiesDual[i] )
            return TRUE;
    }

    return FALSE;

}
int MK_AbilityIsRangedReq(int nAbilityId)
{
    int[] arrAbilitiesRanged;
    int nSize = 0;

    arrAbilitiesRanged[nSize++] = AT_ABILITY_AIM;
    arrAbilitiesRanged[nSize++] = AT_ABILITY_DEFENSIVE_FIRE;
    arrAbilitiesRanged[nSize++] = AT_ABILITY_RAPIDSHOT;
    arrAbilitiesRanged[nSize++] = AT_ABILITY_SUPPRESSING_FIRE;

    arrAbilitiesRanged[nSize++] = AT_ABILITY_PINNING_SHOT;
    arrAbilitiesRanged[nSize++] = AT_ABILITY_CRIPPLING_SHOT;
    arrAbilitiesRanged[nSize++] = AT_ABILITY_CRITICAL_SHOT;
    arrAbilitiesRanged[nSize++] = AT_ABILITY_ARROW_OF_SLAYING;
    arrAbilitiesRanged[nSize++] = AT_ABILITY_SHATTERING_SHOT;
    arrAbilitiesRanged[nSize++] = AT_ABILITY_SCATTERSHOT;

    int i;
    for(i=0; i<nSize; i++)
    {
        if( nAbilityId == arrAbilitiesRanged[i] )
            return TRUE;
    }

    return FALSE;

}

//==============================================================================
//                            UNIT TESTS
//==============================================================================
int UnitTest_AddCommand_AbilityMutex(int nAbility, object oTarget)
{
    PrintUnitTestHeader("UnitTest_AddCommand_AbilityMutex");

    command cUseAbility = CommandUseAbility(nAbility, oTarget);
    MK_AddCommand(OBJECT_SELF, cUseAbility);
    MK_SetAbilityLock(nAbility, oTarget);

    int nResult = AssertBool(MK_IsAbilityLocked(nAbility, oTarget));

    MK_FreeAbilityLock(nAbility);
    nResult = ResultAnd(nResult, AssertBoolNot(MK_IsAbilityLocked(nAbility, oTarget)));

    return nResult;
}

int TestSuite_AddCommand_AbilityMutex()
{
    string TEST_SUITE_NAME = "TestSuite_AddCommand_AbilityMutex";
    int ABILITY_ID = ABILITY_SPELL_HEROIC_OFFENSE;

    PrintTestSuiteHeader(TEST_SUITE_NAME);
    AddAbility(OBJECT_SELF, ABILITY_ID);


    object[] arFriends = _MK_AI_GetFollowersFromTargetType( MK_TARGET_TYPE_PARTY_MEMBER,
                                                            MK_TACTIC_ID_INVALID,
                                                            TRUE);
    int i;
    int nSize = GetArraySize(arFriends);
    int nResult = TRUE;
    for (i = 0; i < nSize; i++)
    {
        nResult = ResultAnd(nResult, AssertBool(UnitTest_AddCommand_AbilityMutex(ABILITY_ID, arFriends[i])));
    }

    PrintTestSuiteSummary(TEST_SUITE_NAME, nResult);
    return nResult;
}

//void main(){TestSuite_AddCommand_AbilityMutex();}
#endif