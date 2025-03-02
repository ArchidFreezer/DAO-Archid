#ifndef MK_ABILITY_LOCK_H
#defsym MK_ABILITY_LOCK_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/*Advanced Tactics*/
#include "at_tools_constants_h"
/*MkBot*/
#include "mk_other_h"
/*Talmud Storage*/
#include "talmud_storage_h"

//==============================================================================
//                                CONSTANTS
//==============================================================================
const string MK_MUTEX_TARGET_TABLE = "mkMTT";
const string MK_MUTEX_ABILITY_TABLE = "mkMAT";

const int MK_ABILITY_LOCK_TYPE_INVALID = 0;
const int MK_ABILITY_LOCK_TYPE_MASSIVE_DAMAGE = 1;
const int MK_ABILITY_LOCK_TYPE_CANT_ATTACK = 2;
const int MK_ABILITY_LOCK_TYPE_CANT_ATTACK_AOE = 3;
const int MK_ABILITY_LOCK_TYPE_PENALTY = 4;
const int MK_ABILITY_LOCK_TYPE_BUFF = 5;
const int MK_ABILITY_LOCK_TYPE_DISPELL = 6;
const int MK_ABILITY_LOCK_TYPE_DISPELL_AOE = 7;

//==============================================================================
//                                DECLARATIONS
//==============================================================================
int MK_GetAbilityLockType(int nAbility);

void MK_SetAbilityLock(int nAbility, object oTarget);
void MK_FreeAbilityLock(int nAbility);
int MK_IsAbilityLocked(int nAbility, object oTarget);

int MK_IsAbilityLockable(int nAbility);
int MK_IsAbilityLockableST(int nAbility);//single_target
int MK_IsAbilityLockableAOE(int nAbility);//AOE

int MK_IsAbilityLockableMassiveDamage(int nAbility);
int MK_IsAbilityLockableCantAttack(int nAbility);
int MK_IsAbilityLockableCantAttackAOE(int nAbility);
int MK_IsAbilityLockablePenalty(int nAbility);
int MK_IsAbilityLockableFriendly(int nAbility);
int MK_IsAbilityLockableDispell(int nAbility);
int MK_IsAbilityLockableDispellAOE(int nAbility);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
int MK_GetAbilityLockType(int nAbility)
{
    if( MK_IsAbilityLockableCantAttack(nAbility) )
        return MK_ABILITY_LOCK_TYPE_CANT_ATTACK;

    if( MK_IsAbilityLockableCantAttackAOE(nAbility) )
        return MK_ABILITY_LOCK_TYPE_CANT_ATTACK_AOE;

    if( MK_IsAbilityLockableFriendly(nAbility) )
        return MK_ABILITY_LOCK_TYPE_BUFF;

    if( MK_IsAbilityLockablePenalty(nAbility) )
        return MK_ABILITY_LOCK_TYPE_PENALTY;

    if( MK_IsAbilityLockableMassiveDamage(nAbility) )
        return MK_ABILITY_LOCK_TYPE_MASSIVE_DAMAGE;

    if( MK_IsAbilityLockableDispell(nAbility) )
        return MK_ABILITY_LOCK_TYPE_DISPELL;

    if( MK_IsAbilityLockableDispellAOE(nAbility) )
        return MK_ABILITY_LOCK_TYPE_DISPELL_AOE;

    return MK_ABILITY_LOCK_TYPE_INVALID;
}

void MK_SetAbilityLock(int nAbility, object oTarget)
{
    if( MK_IsAbilityLockable(nAbility) )
    {
        if(GetCreatureRacialType(OBJECT_SELF) == RACE_ANIMAL)
            DisplayFloatyMessage(OBJECT_SELF, "Grrrr...", FLOATY_MESSAGE, 0xDF75CF, 3.0f);
        else
            DisplayFloatyMessage(OBJECT_SELF, "I go first!", FLOATY_MESSAGE, 0xDF75CF, 3.0f);

        int idx = MK_GetPartyMemberIndex();
        StoreObjectInArray(MK_MUTEX_TARGET_TABLE,oTarget,idx);
        StoreIntegerInArray(MK_MUTEX_ABILITY_TABLE,nAbility,idx);
    }
/*
    else if( MK_IsAbilityLockableAOE(nAbility) )
    {
        if(GetCreatureRacialType(OBJECT_SELF) == RACE_ANIMAL)
            DisplayFloatyMessage(OBJECT_SELF, "Grrrr...", FLOATY_MESSAGE, 0xDF75CF, 3.0f);
        else
            DisplayFloatyMessage(OBJECT_SELF, "I go first!", FLOATY_MESSAGE, 0xDF75CF, 3.0f);

        int idx = MK_GetPartyMemberIndex();
        StoreObjectInArray(MK_MUTEX_TARGET_TABLE,OBJECT_SELF,idx);
        StoreIntegerInArray(MK_MUTEX_ABILITY_TABLE,nAbility,idx);
    }
*/
    return;
}

void MK_FreeAbilityLock(int nAbility)
{
    if( MK_IsAbilityLockable(nAbility) )
    {
        if(GetCreatureRacialType(OBJECT_SELF) == RACE_ANIMAL)
            DisplayFloatyMessage(OBJECT_SELF, "Whow, Whow!", FLOATY_MESSAGE, 0xDF75CF, 3.0f);
        else
            DisplayFloatyMessage(OBJECT_SELF, "Free to go!", FLOATY_MESSAGE, 0xDF75CF, 3.0f);

        int idx = MK_GetPartyMemberIndex();
        StoreObjectInArray(MK_MUTEX_TARGET_TABLE, OBJECT_INVALID, idx);
        StoreIntegerInArray(MK_MUTEX_ABILITY_TABLE, ABILITY_INVALID, idx);
    }
    return;
}

int MK_IsAbilityLocked(int nAbility, object oTarget)
{

    object[] arTargets = FetchObjectArray(MK_MUTEX_TARGET_TABLE);
    int[] arAbilities = FetchIntegerArray(MK_MUTEX_ABILITY_TABLE);
    int nSize = GetArraySize(arTargets);

    int nAbilityLockType = MK_GetAbilityLockType(nAbility);
    int nIsSpell = IsSpell(nAbility);

    int i;
    for(i=0; i < nSize; i++)
    {
        int nRegisterdAbilityLockType = MK_GetAbilityLockType(arAbilities[i]);

        switch(nRegisterdAbilityLockType)
        {
            //MkBot: Do not use ability on Target that will be killed by Massive Damage Ability
            case MK_ABILITY_LOCK_TYPE_MASSIVE_DAMAGE:
            {
                if( oTarget == arTargets[i] )
                    return TRUE;
                break;
            }
            //MkBot: Do not use stun/knockdown/fear etc. ability if someone is using such ability already
            case MK_ABILITY_LOCK_TYPE_CANT_ATTACK:
            {
                if( nAbilityLockType == MK_ABILITY_LOCK_TYPE_CANT_ATTACK && oTarget == arTargets[i] )
                    return TRUE;
                break;
            }
            case MK_ABILITY_LOCK_TYPE_CANT_ATTACK_AOE:
            {
                if( nAbilityLockType == MK_ABILITY_LOCK_TYPE_CANT_ATTACK || nAbilityLockType == MK_ABILITY_LOCK_TYPE_CANT_ATTACK_AOE  )
                {
                    if( oTarget == arTargets[i] )
                        return TRUE;

                    float fDistance = GetDistanceBetween(oTarget, arTargets[i]);
                    float fRadius = GetM2DAFloat(TABLE_ABILITIES_SPELLS, "aoe_param1", arAbilities[i]);
                    if( fDistance <= fRadius )
                        return TRUE;
                }
                break;
            }
            //MkBot: Do not use ability that gives not-stacking penalty if someone is using the same ability already
            case MK_ABILITY_LOCK_TYPE_PENALTY:
            {
                if( nAbility == arAbilities[i] && oTarget == arTargets[i] )
                    return TRUE;
                break;
            }
            //MkBot: Do not use ability that give not-stacking buff if someone is using the same ability already
            case MK_ABILITY_LOCK_TYPE_BUFF:
            {
                if( nAbility == arAbilities[i] && oTarget == arTargets[i] )
                    return TRUE;
                break;
            }
            //MkBot: Do not cast spell on Target if Dispell is coming
            case MK_ABILITY_LOCK_TYPE_DISPELL:
            {
                if( nAbilityLockType == MK_ABILITY_LOCK_TYPE_DISPELL_AOE )
                {
                    if( oTarget == arTargets[i] )
                        return TRUE;

                    float fDistance = GetDistanceBetween(oTarget, arTargets[i]);
                    float fRadius = GetM2DAFloat(TABLE_ABILITIES_SPELLS, "aoe_param1", arAbilities[i]);
                    if( fDistance <= fRadius )
                        return TRUE;

                }else if( nIsSpell || nAbilityLockType == MK_ABILITY_LOCK_TYPE_DISPELL )
                {
                    if( oTarget == arTargets[i] )
                        return TRUE;
                }

                break;
            }
            case MK_ABILITY_LOCK_TYPE_DISPELL_AOE:
            {
                if( nAbilityLockType == MK_ABILITY_LOCK_TYPE_DISPELL_AOE )
                {
                    return TRUE;

                }else if( nIsSpell || nAbilityLockType == MK_ABILITY_LOCK_TYPE_DISPELL )
                {
                    if( oTarget == arTargets[i] )
                        return TRUE;

                    float fDistance = GetDistanceBetween(oTarget, arTargets[i]);
                    float fRadius = GetM2DAFloat(TABLE_ABILITIES_SPELLS, "aoe_param1", arAbilities[i]);
                    if( fDistance <= fRadius )
                        return TRUE;
                }
                break;
            }

        }
    }

    return FALSE;

}

int MK_IsAbilityLockable(int nAbility)
{
    if( MK_IsAbilityLockableMassiveDamage(nAbility) )
        return TRUE;
    if( MK_IsAbilityLockableCantAttack(nAbility) )
        return TRUE;
    if( MK_IsAbilityLockableCantAttackAOE(nAbility) )
        return TRUE;
    if( MK_IsAbilityLockablePenalty(nAbility) )
        return TRUE;
    if( MK_IsAbilityLockableFriendly(nAbility) )
        return TRUE;
    if( MK_IsAbilityLockableDispell(nAbility) )
        return TRUE;
    if( MK_IsAbilityLockableDispellAOE(nAbility) )
        return TRUE;
    return FALSE;

}

int MK_IsAbilityLockableST(int nAbility)//Single Target
{
    //if( MK_IsAbilityLockableAOE(nAbility) )
    //    return TRUE;
    if( MK_IsAbilityLockableFriendly(nAbility) )
        return TRUE;
    if( MK_IsAbilityLockableMassiveDamage(nAbility) )
        return TRUE;
    if( MK_IsAbilityLockableCantAttack(nAbility) )
        return TRUE;
    if( MK_IsAbilityLockablePenalty(nAbility) )
        return TRUE;

    return FALSE;

}

int MK_IsAbilityLockableAOE(int nAbility)
{
    int[] arLockableAbilities;
    int nSize = 0;
    //Dog
    arLockableAbilities[nSize++] = AT_ABILITY_DOG_MABARI_HOWL;
    //Shale
    arLockableAbilities[nSize++] = AT_ABILITY_BELLOW;
    arLockableAbilities[nSize++] = AT_ABILITY_HURL_ROCK;
    arLockableAbilities[nSize++] = AT_ABILITY_EARTHEN_GRASP;
    arLockableAbilities[nSize++] = AT_ABILITY_ROCK_BARRAGE;
    //SPELLS
    arLockableAbilities[nSize++] = AT_ABILITY_MASS_PARALYSIS;
    arLockableAbilities[nSize++] = AT_ABILITY_SLEEP;
    arLockableAbilities[nSize++] = AT_ABILITY_WAKING_NIGHTMARE;
    arLockableAbilities[nSize++] = AT_ABILITY_GLYPH_OF_REPULSION;
    arLockableAbilities[nSize++] = AT_ABILITY_GLYPH_OF_PARALYSIS;

    //DAA
    //Pandemonium

    int i;
    for(i=0; i<nSize; i++)
    {
        if(nAbility == arLockableAbilities[i])
            return TRUE;
    }

    //Special Case: Chempion's Warcry with Superiority
    //if( nAbility == AT_ABILITY_WAR_CRY && HasAbility(AT_ABILITY_SUPERIORITY) )
    //    return TRUE;

    return FALSE;
}

int MK_IsAbilityLockableMassiveDamage(int nAbility)
{
    int[] arLockableAbilities;
    int nSize = 0;

    //Rogue
    arLockableAbilities[nSize++] = AT_ABILITY_HEARTSEEKER;
    //Warrior
    arLockableAbilities[nSize++] = AT_ABILITY_PEON_S_PLIGHT;
    //Massacre AOE
    //??
    //Berserker
    arLockableAbilities[nSize++] = AT_ABILITY_FINAL_BLOW;
    //Shale
    arLockableAbilities[nSize++] = AT_ABILITY_KILLING_BLOW;
    //Archery
    arLockableAbilities[nSize++] = AT_ABILITY_ARROW_OF_SLAYING;

    int i;
    for(i=0; i<nSize; i++)
    {
        if(nAbility == arLockableAbilities[i])
            return TRUE;
    }
    return FALSE;

}

int MK_IsAbilityLockableCantAttack(int nAbility)
{
    int[] arLockableAbilities;
    int nSize = 0;

//---------- SINGLE TARGET
    //Rogue
    arLockableAbilities[nSize++] = AT_ABILITY_DIRTY_FIGHTING;
    //Reaver
    arLockableAbilities[nSize++] = AT_ABILITY_FRIGHTENING;
    //Archery
    arLockableAbilities[nSize++] = AT_ABILITY_PINNING_SHOT;
    //Shield
    arLockableAbilities[nSize++] = AT_ABILITY_SHIELD_BASH;
    arLockableAbilities[nSize++] = AT_ABILITY_SHIELD_PUMMEL;
    arLockableAbilities[nSize++] = AT_ABILITY_OVERPOWER;
    //Two-handed fighting
    arLockableAbilities[nSize++] = AT_ABILITY_POMMEL_STRIKE;
    //arLockableAbilities[nSize++] = AT_ABILITY_TWO_HANDED_SWEEP;
    //Dog
    arLockableAbilities[nSize++] = AT_ABILITY_DOG_CHARGE;
    arLockableAbilities[nSize++] = AT_ABILITY_DOG_OVERWHELM;
    //Shale
    arLockableAbilities[nSize++] = AT_ABILITY_SLAM;
    //Spells
    arLockableAbilities[nSize++] = AT_ABILITY_STONEFIST;
    arLockableAbilities[nSize++] = AT_ABILITY_PETRIFY;
    arLockableAbilities[nSize++] = AT_ABILITY_FORCE_FIELD;
    arLockableAbilities[nSize++] = AT_ABILITY_CRUSHING_PRISON;
    arLockableAbilities[nSize++] = AT_ABILITY_PARALYZE;
    arLockableAbilities[nSize++] = AT_ABILITY_HORROR;
    arLockableAbilities[nSize++] = AT_ABILITY_MISDIRECTION_HEX;

    int i;
    for(i=0; i<nSize; i++)
    {
        if(nAbility == arLockableAbilities[i])
            return TRUE;
    }

    return FALSE;
}

int MK_IsAbilityLockableCantAttackAOE(int nAbility)
{
    int[] arLockableAbilities;
    int nSize = 0;

//---------- AOE 
    //Warrior
    arLockableAbilities[nSize++] = AT_ABILITY_WAR_CRY;
    //Dog
    arLockableAbilities[nSize++] = AT_ABILITY_DOG_MABARI_HOWL;
    //Shale
    arLockableAbilities[nSize++] = AT_ABILITY_BELLOW;
    arLockableAbilities[nSize++] = AT_ABILITY_HURL_ROCK;
    arLockableAbilities[nSize++] = AT_ABILITY_EARTHEN_GRASP;
    arLockableAbilities[nSize++] = AT_ABILITY_ROCK_BARRAGE;
    //SPELLS
    arLockableAbilities[nSize++] = AT_ABILITY_MASS_PARALYSIS;
    arLockableAbilities[nSize++] = AT_ABILITY_SLEEP;
    arLockableAbilities[nSize++] = AT_ABILITY_WAKING_NIGHTMARE;
    arLockableAbilities[nSize++] = AT_ABILITY_GLYPH_OF_REPULSION;
    arLockableAbilities[nSize++] = AT_ABILITY_GLYPH_OF_PARALYSIS;

    int i;
    for(i=0; i<nSize; i++)
    {
        if(nAbility == arLockableAbilities[i])
            return TRUE;
    }

    //Special Case: Chempion's Warcry with Superiority
    //if( nAbility == AT_ABILITY_WAR_CRY && HasAbility(AT_ABILITY_SUPERIORITY) )
    //    return TRUE;

    return FALSE;
}

int MK_IsAbilityLockablePenalty(int nAbility)
{
    int[] arLockableAbilities;
    int nSize = 0;

    //Rogue
    arLockableAbilities[nSize++] = AT_ABILITY_BELOW_THE_BELT;
    //Duelist
    arLockableAbilities[nSize++] = AT_ABILITY_UPSET_BALANCE;
    //Dual Weapon
    arLockableAbilities[nSize++] = AT_ABILITY_DUAL_WEAPON_CRIPPLE;
    //Archery
    arLockableAbilities[nSize++] = AT_ABILITY_CRIPPLING_SHOT;

    int i;
    for(i=0; i<nSize; i++)
    {
        if(nAbility == arLockableAbilities[i])
            return TRUE;
    }
    return FALSE;

}

int MK_IsAbilityLockableFriendly(int nAbility)
{
    int[] arLockableAbilities;
    int nSize = 0;

    //SPELLS
    arLockableAbilities[nSize++] = AT_ABILITY_REJUVINATION;
    arLockableAbilities[nSize++] = AT_ABILITY_REGENERATION;
    arLockableAbilities[nSize++] = AT_ABILITY_HEROIC_OFFENSE;
    arLockableAbilities[nSize++] = AT_ABILITY_HEROIC_AURA;
    arLockableAbilities[nSize++] = AT_ABILITY_HEROIC_DEFENSE;
    arLockableAbilities[nSize++] = AT_ABILITY_ANTIMAGIC_WARD;

    int i;
    for(i=0; i<nSize; i++)
    {
        if(nAbility == arLockableAbilities[i])
            return TRUE;
    }
    return FALSE;

}

int MK_IsAbilityLockableDispell(int nAbility)
{
    int[] arLockableAbilities;
    int nSize = 0;

    arLockableAbilities[nSize++] = AT_ABILITY_DISPEL_MAGIC;
    arLockableAbilities[nSize++] = AT_ABILITY_ANTIMAGIC_WARD; //??

    int i;
    for(i=0; i<nSize; i++)
    {
        if(nAbility == arLockableAbilities[i])
            return TRUE;
    }
    return FALSE;
}

int MK_IsAbilityLockableDispellAOE(int nAbility)
{
    int[] arLockableAbilities;
    int nSize = 0;

    arLockableAbilities[nSize++] = AT_ABILITY_CLEANSE_AREA;
    arLockableAbilities[nSize++] = AT_ABILITY_ANTIMAGIC_BURST;

    int i;
    for(i=0; i<nSize; i++)
    {
        if(nAbility == arLockableAbilities[i])
            return TRUE;
    }
    return FALSE;
}
#endif