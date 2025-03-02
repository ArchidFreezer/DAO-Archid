#ifndef MK_COMMAND_USE_ABILITY_H
#defsym MK_COMMAND_USE_ABILITY_H
//==============================================================================
//                              INCLUDES
//==============================================================================
//#include "mk_comm_movetolineofsight_h"
#include "mk_cmd_move_fire_position_h"
#include "mk_setcommandtimeout_h"
#include "mk_ability_mutex_h"

//=======================================================================
//                          DECLARATIONS
//=======================================================================
command _MK_CommandUseAbility(int nAbilityId, object oTarget);
void DisplayMsgAbilityBlockedByMutex();

command _MK_CommandUseAbilityMelee(int nAbilityId, object oTarget);
command _MK_CommandUseAbilityRanged(int nAbilityId, object oTarget);
//=======================================================================
//                          DECLARATIONS
//=======================================================================
/** @brief Brief description of function
*
* @param Parameter1 -
* @param Patameter2 -
* @returns - CommandUseAbility if oTarget at range and in line of sight
*          - MoveToLocation if Self can change position so to have oTarget in line of sight
* @author MkBot
**/
command _MK_CommandUseAbility(int nAbilityId, object oTarget)
{
    //-------------- Check Ability Mutex
    if (MK_IsAbilityLocked(nAbilityId, oTarget) == TRUE)
    {
        //Side Effect!!!
        DisplayMsgAbilityBlockedByMutex();
        return MK_CommandInvalid();
    }

    return CommandUseAbility(nAbilityId, oTarget);
    
    
    
// MkBot: Disabled for release. LineOfSight bug causes this feature to be annoying for users.
//          Users are more willing to accept trouble they know (ie. Vanillia archer suicide)
//          than new trouble (ie. Sneaky Bastards)
/*
    command cResult;
    //TABLE_ABILITIES_TALENTS = TABLE_ABILITIES_SPELLS = 1;
    int nIsMeleeAbility = GetM2DAInt(TABLE_ABILITIES_SPELLS, "range", nAbilityId) == 0;
    if (nIsMeleeAbility == TRUE)
        cResult = _MK_CommandUseAbilityMelee(nAbilityId, oTarget);
    else
        cResult = _MK_CommandUseAbilityRanged(nAbilityId, oTarget);
    return cResult;
*/
}
/*
command _MK_CommandUseAbilityMelee(int nAbilityId, object oTarget)
{
    command cResult;
    cResult = CommandUseAbility(nAbilityId, oTarget);
    cResult = MK_SetCommandTimeout(cResult, MK_TIMEOUT_ABILITY);
    return cResult;
}

command _MK_CommandUseAbilityRanged(int nAbilityId, object oTarget)
{
    int nRangeId = GetM2DAInt(TABLE_ABILITIES_SPELLS, "range", nAbilityId);
    float fRange = GetM2DAFloat(TABLE_RANGES, "PrimaryRange", nRangeId);
    int nIsLineOfSightRequired = GetM2DAInt(TABLE_ABILITIES_SPELLS, "projectile", nAbilityId) != 0;

    command cResult = MK_CommandMoveToFirePosition(oTarget, fRange, nIsLineOfSightRequired);
    if (MK_IsCommandValid(cResult) == TRUE)
        return cResult;

    cResult = CommandUseAbility(nAbilityId, oTarget);
    cResult = MK_SetCommandTimeout(cResult, MK_TIMEOUT_ABILITY);
    return cResult;
}
*/
void DisplayMsgAbilityBlockedByMutex()
{
    int nRace = GetCreatureRacialType(OBJECT_SELF);
    if(nRace == RACE_ANIMAL || nRace == RACE_BEAST)
        DisplayFloatyMessage(OBJECT_SELF, "(Awaits impatiently)", FLOATY_MESSAGE, 0xDF75CF, 3.0f);
    else
        DisplayFloatyMessage(OBJECT_SELF, "After you", FLOATY_MESSAGE, 0xDF75CF, 3.0f);
}

//void main(){_MK_CommandUseAbility(0, OBJECT_SELF);}
#endif