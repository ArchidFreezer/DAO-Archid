#ifndef MK_BEHAVIOR_SWITCH_WEAPON_H
#defsym MK_BEHAVIOR_SWITCH_WEAPON_H

//==============================================================================
//                              INCLUDES
//==============================================================================
/* MkBot */
#include "mk_constants_h"
#include "mk_constants_ai_h"
#include "mk_cmd_invalid_h"
#include "mk_range_h"
#include "mk_behavior_check_h"   
#include "mk_logger_h"

//==============================================================================
//                          DECLARATIONS
//==============================================================================
command MK_BehaviorSwitchWeapon();
command MK_SwitchToMelee(struct PartyRange partyRange);
command MK_SwitchToRanged(struct PartyRange partyRange);

//==============================================================================
//                          DEFINITIONS
//==============================================================================
//******************************************************************************
command MK_BehaviorSwitchWeapon()
{
    if(AT_IsControlled(OBJECT_SELF) == TRUE)
        return MK_CommandInvalid();
    
    MK_PushToCallStackTrace("MK_BehaviorSwitchWeapon");
    command cResult = MK_CommandInvalid();
    
    int nWeponSetEquipped = _AI_GetWeaponSetEquipped();
    int bCanSwitchToMelee  = nWeponSetEquipped == AI_WEAPON_SET_RANGED && _AI_HasWeaponSet(AI_WEAPON_SET_MELEE);
    int bCanSwitchToRanged = nWeponSetEquipped == AI_WEAPON_SET_MELEE && _AI_HasWeaponSet(AI_WEAPON_SET_RANGED);

    if (bCanSwitchToMelee)
    {
        struct PartyRange partyRange = MK_BehaviorCheck_SwitchMelee();
        cResult = MK_SwitchToMelee(partyRange);
    }
    else if (bCanSwitchToRanged)
    {
        struct PartyRange partyRange = MK_BehaviorCheck_SwitchRanged();
        cResult = MK_SwitchToRanged(partyRange);
    }
    
    MK_RemoveLastFromCallStackTrace();
    return cResult;
}

//******************************************************************************
command MK_SwitchToMelee(struct PartyRange partyRange)
{
    if (MK_IsPartyRangeValid(partyRange) == FALSE)
        return MK_CommandInvalid();
    
    MK_PushToCallStackTrace("MK_SwitchToMelee");
    command cResult = MK_CommandInvalid();
    
    float fRange = _MK_GetRangeFromID(partyRange.nRangeId);
    if (MK_IsAnyEnemyAtRange(fRange, partyRange.nTargetType) == TRUE)
        cResult = _AI_SwitchWeaponSet(AI_WEAPON_SET_MELEE);

    MK_RemoveLastFromCallStackTrace();
    return cResult;
}

//******************************************************************************
command MK_SwitchToRanged(struct PartyRange partyRange)
{ 
    if (MK_IsPartyRangeValid(partyRange) == FALSE)
        return MK_CommandInvalid();
        
    MK_PushToCallStackTrace("MK_SwitchToRanged");
    command cResult = MK_CommandInvalid();
    
    float fRange = _MK_GetRangeFromID(partyRange.nRangeId);
    if (MK_IsAnyEnemyAtRange(fRange, partyRange.nTargetType) == FALSE)
        cResult = _AI_SwitchWeaponSet(AI_WEAPON_SET_RANGED);

    MK_RemoveLastFromCallStackTrace();
    return cResult;
}

//******************************************************************************
//void main(){MK_BehaviorSwitchWeapon();}
#endif