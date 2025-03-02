#ifndef MK_COMMAND_ATTACK_H
#defsym MK_COMMAND_ATTACK_H
//==============================================================================
//                              INCLUDES
//==============================================================================
/*Advanced Tactics*/
#include "at_tools_ai_h"

/*MkBot*/
#include "mk_cond_tools_h"
#include "mk_cmd_move_fire_position_h"

//==============================================================================
//                              DECLARATIONS
//==============================================================================
command MK_CommandAttack(object oTarget, object nLastTarget, int nLastCommandType, int nLastCommandStatus);

command _MK_CommandAttackRanged(object oTarget, object nLastTarget, int nLastCommandType);
command _MK_CommandAttackMelee(object oTarget, object nLastTarget, int nLastCommandType, int nLastCommandStatus);
int _MK_IsTraitorOn();

//==============================================================================
//                              DEFINITIONS
//==============================================================================

/** @brief This function is Attack Command constructor
*
* @param oTarget - hostile creature to be attacked
* @param nLastCommandStatus - see COMMAND_SUCCESSFUL/COMMAND_FAILED_ constants
* @returns Attack Command
* @author MkBot
**/
command MK_CommandAttack(object oTarget, object oLastTarget, int nLastCommandType, int nLastCommandStatus)
{
    command cResult = MK_CommandInvalid();

    if (GetEffectsFlags(OBJECT_SELF) & EFFECT_FLAG_DISABLE_COMBAT)
        return _AT_AI_DoNothing();

    if (_AI_GetWeaponSetEquipped(OBJECT_SELF) == AI_WEAPON_SET_RANGED)
        cResult = _MK_CommandAttackRanged(oTarget, oLastTarget,  nLastCommandType);
    else
        cResult = _MK_CommandAttackMelee(oTarget, oLastTarget, nLastCommandType, nLastCommandStatus);

    return cResult;
}

/** @brief ***INTERNAL***
**/
command _MK_CommandAttackRanged(object oTarget, object oLastTarget, int nLastCommandType)
{
    command cResult;

    int nHasAlreadyChangedPosition = oLastTarget == oTarget &&
                                     nLastCommandType == COMMAND_TYPE_MOVE_TO_LOCATION;
    if (nHasAlreadyChangedPosition == FALSE)
    {
        cResult = MK_CommandMoveToFirePosition(oTarget);
        int nIsBetterFirePositionFound = MK_IsCommandValid(cResult);
        if (nIsBetterFirePositionFound == TRUE)
            return cResult;
    }

    cResult = CommandAttack(oTarget);
    return cResult;
}

/** @brief ***INTERNAL***
**/
command _MK_CommandAttackMelee(object oTarget, object oLastTarget, int nLastCommandType, int nLastCommandStatus)
{
    command cResult;
    
    int nWasLastCmdFlankingAttack = oLastTarget == oTarget && 
                                    nLastCommandType == COMMAND_TYPE_MOVE_TO_LOCATION;   
    int nWasFlankingAttackSuccessful = nWasLastCmdFlankingAttack == TRUE &&
                                       nLastCommandStatus == COMMAND_SUCCESSFUL;
                                            
    if (_MK_IsTraitorOn() && (nWasFlankingAttackSuccessful || !nWasLastCmdFlankingAttack))
        cResult = _AT_CommandFlankingAttack(oTarget);
    else
        cResult = CommandAttack(oTarget);
    return cResult;
}

/** @brief ***INTERNAL***
**/
int _MK_IsTraitorOn()
{
    int nBitVar = GetLocalInt(GetHero(), "AI_CUSTOM_AI_VAR_INT");
    int nIsTraitorOn = ( (nBitVar & 2) != 0 );
    return (nIsTraitorOn != 0);
}

//void main(){MK_CommandAttack(OBJECT_SELF, OBJECT_SELF, 0, 0);}
#endif