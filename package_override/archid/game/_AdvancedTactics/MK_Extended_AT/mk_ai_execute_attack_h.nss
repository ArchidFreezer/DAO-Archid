#ifndef MK_AI_EXECUTE_ATTACK_H
#defsym MK_AI_EXECUTE_ATTACK_H
//==============================================================================
//                              INCLUDES
//==============================================================================
/*Advanced Tactics*/
#include "at_tools_ai_h"

/*MkBot*/
#include "mk_getenemiespartyradius_h"
#include "mk_condition_lineofsight_h"
#include "mk_condition_x_at_range_h"
#include "mk_other_h"
#include "mk_setcommandtimeout_h"
#include "mk_comm_movetolineofsight_h"
#include "mk_cond_tools_h"
#include "mk_print_to_log_h"

//==============================================================================
//                              DECLARATIONS
//==============================================================================
command _MK_AI_ExecuteAttackSmart(object oTarget, int nLastCommandStatus, int nPerformTargetChecks = TRUE);
command _MK_AI_SubExecuteAttack_Ranged(object oTarget, int nLastCommandStatus, int nPerformTargetChecks = TRUE);
command _MK_AI_SubExecuteAttack_Melee(object oTarget, int nLastCommandStatus, int nPerformTargetChecks);

//==============================================================================
//                              DEFINITIONS
//==============================================================================

command _MK_AI_SubExecuteAttack_Ranged(object oTarget, int nLastCommandStatus, int nPerformTargetChecks)
{    
    float fMsgTime = 5.0;
    int nMsgColor = 0xDF75CF;

    if (nPerformTargetChecks == FALSE)
    {
        command cAttack = CommandAttack(oTarget);
        cAttack = MK_SetCommandTimeout(cAttack, 1.0);
        return cAttack;
    }
     
    if (MK_HasSneakyBastardStatus(oTarget))
    {
        DisplayFloatyMessage(OBJECT_SELF, "Sneaky Bastard!",FLOATY_MESSAGE, nMsgColor, fMsgTime);
        command cInvalid;
        return cInvalid;
    }

    //MkBot: Distance Check
    int nIsRangedCombatDistanceValid = GetDistanceBetween(OBJECT_SELF, oTarget) < MAX_RANGED_COMBAT_DISTANCE;
    if( nIsRangedCombatDistanceValid == FALSE )
    {        
        command cInvalid;
        return cInvalid;
    }
    
    //MkBot: Line of Sight Check
    int nIsInLineOfSight = CheckLineOfSightObject(OBJECT_SELF, oTarget);
    if( nIsInLineOfSight == TRUE )//Attack oTarget
    {
        command cAttack = CommandAttack(oTarget);
        cAttack = MK_SetCommandTimeout(cAttack, 1.0);
        return cAttack;

    }

    //Try to find a new position to attack oTarget
    command cMove = _MK_CommandMoveToLineOfSightPositionKeepDistance(oTarget, 3.0);
    if( GetCommandType(cMove) == COMMAND_TYPE_INVALID )
        cMove = _MK_CommandMoveToLineOfSightPositionKeepDistance(oTarget, 6.0);

    if( GetCommandType(cMove) != COMMAND_TYPE_INVALID )
    {
        DisplayFloatyMessage(OBJECT_SELF, "Going to better position",FLOATY_MESSAGE, nMsgColor, fMsgTime);
        return cMove;
    }

    command cInvalid;
    return cInvalid;
}

command _MK_AI_SubExecuteAttack_Melee(object oTarget, int nLastCommandStatus, int nPerformTargetChecks)
{

    #ifdef MK_DEBUG
    MK_PrintToLog("[_MK_AI_SubExecuteAttack_Melee] Start");
    #endif
    command cRet;

    if( nPerformTargetChecks == TRUE )
    {
        //MkBot: Sleeping/Rooted Check
        int nIsSelectedSleepingOrPinned = _AT_AI_HasAIStatus(oTarget, AI_STATUS_ROOT) || _AT_AI_HasAIStatus(oTarget, AI_STATUS_SLEEP);
        if( nIsSelectedSleepingOrPinned == TRUE )
        {
            #ifdef MK_DEBUG
            MK_PrintToLog("[_MK_AI_SubExecuteAttack_Melee] Sleeping/Rooted Check:Fail -> Cancel Attack Command");
            #endif
            return cRet;
        }
        #ifdef MK_DEBUG
        MK_PrintToLog("[_MK_AI_SubExecuteAttack_Melee] Sleeping/Rooted Check:Succes");
        #endif
    }
    // Advanced Tactics: is Traitor ON?
    int nBitVar = GetLocalInt(GetHero(), "AI_CUSTOM_AI_VAR_INT");
    int nIsTraitorOn = ( (nBitVar & 2) != 0 );

    if( (nIsTraitorOn == TRUE) && (nLastCommandStatus >= 0) )
    {
        #ifdef MK_DEBUG
        MK_PrintToLog("[_MK_AI_SubExecuteAttack_Melee] AT Traitor Check:TRUE -> Send Flank Target Command");
        #endif
        cRet = _AT_CommandFlankingAttack(oTarget);
    }else
    {
        #ifdef MK_DEBUG
        MK_PrintToLog("[_MK_AI_SubExecuteAttack_Melee] AT Traitor Check:FALSE -> Send Attack Target Command");
        #endif
        cRet = CommandAttack(oTarget);
    }
    #ifdef MK_DEBUG
    MK_PrintToLog("[_MK_AI_SubExecuteAttack_Melee] End");
    #endif
    return cRet;


}

/** @brief Brief description of function
*
*   Description of function
*
*
*
* @param Parameter1 - 1st Parameter
* @param Patameter2 - 2nd Parameter
* @param Patameter2 - 2nd Parameter
* @author MkBot
**/
command _MK_AI_ExecuteAttackSmart(object oTarget, int nLastCommandStatus, int nPerformTargetChecks)
{
    if (GetEffectsFlags(OBJECT_SELF) & EFFECT_FLAG_DISABLE_COMBAT)
        return _AT_AI_DoNothing();

    command cTacticCommand;
    int nWeaponSetEquipped = _AI_GetWeaponSetEquipped();

    if (nWeaponSetEquipped == AI_WEAPON_SET_RANGED)
        cTacticCommand = _MK_AI_SubExecuteAttack_Ranged(oTarget, nLastCommandStatus, nPerformTargetChecks);
    else
        cTacticCommand = _MK_AI_SubExecuteAttack_Melee(oTarget, nLastCommandStatus, nPerformTargetChecks);

    return cTacticCommand;
}
#endif