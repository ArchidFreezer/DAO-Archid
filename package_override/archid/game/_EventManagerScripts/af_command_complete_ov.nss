/*
    Advanced Tactics event script

    Override EVENT_TYPE_COMMAND_COMPLETE for followers

    You can search for "Advanced Tactics" comments to find changes.
    If you need comments on bioware's stuff, read rules_core.
    Comments here are only about Advanced Tactics.

    These event are managed prety much the same way as original scripts.
    - IsControlled is replaced with AT_IsControlled for EnableCPAI implementation.
    - _AI_DetermineCombatRound is replaced with _AT_AI_DetermineCombatRound for
      followers AI implementation.
*/

//#defsym MK_DEBUG
//#defsym MK_DEBUG_CONDITIONS
//#defsym MK_DEBUG_OBJECT_SELF
//#defsym MK_DEBUG_TACTIC_ROW
//#defsym MK_DEBUG_MULTI_CONDITIONS

//==============================================================================
//                              INCLUDES
//==============================================================================
/* Core */
#include "ai_main_h_2"
#include "sys_soundset_h"
#include "var_constants_h"

#include "af_ability_h"

/* EventManager */
#include "af_eventmanager_h"

/* Advanced Tactics */
#include "at_ai_conditions_nochange_h"
#include "at_tools_aoe_h"

/* MkBot */
#include "mk_determine_combat_round_h"
#include "mk_ability_mutex_h"
#include "mk_constants_h"
#include "mk_print_to_log_h"
#include "log_commands_h"
#include "mk_logcreaturevar_h"

/* Talmud Storage*/
#include "talmud_storage_h"


//==============================================================================
//                                DECLARATIONS
//==============================================================================
void _MK_AddSkills();

//==============================================================================
//                            DEFINITIONS
//==============================================================================
void main()
{
    MK_PrintToLog("[Command Complete] : Event Start ");
    #ifdef MK_DEBUG_OBJECT_SELF
    MK_LogCommandQueue(OBJECT_SELF);
    MK_LogCreatureVar(OBJECT_SELF);
    #endif

    event ev = GetCurrentEvent();

    int nLastCommandType = GetEventInteger(ev, 0);
    int nCommandStatus   = GetEventInteger(ev, 1);
    int nLastSubCommand  = GetEventInteger(ev, 2);
    object oLastTarget   = GetEventObject(ev, 1);
    object oBlockingObject = GetEventObject(ev, 2);

//------------------------------------------------------------------------------
//          Advanced Tactics: AOE system
//------------------------------------------------------------------------------
    #ifdef MK_DEBUG
    MK_PrintToLog("[Command Complete] Section: AOE system");
    #endif
    if (nLastCommandType == COMMAND_TYPE_USE_ABILITY && _AT_IsHostileAOE(nLastSubCommand)) {
        if (nCommandStatus == COMMAND_SUCCESSFUL)
            _AT_SwapAOE(OBJECT_SELF);
        else
            _AT_RemoveAOE(AT_ARRAY_INCOMING_AOE, OBJECT_SELF);
    }

//------------------------------------------------------------------------------
//          Advanced Tactics: Execute Core Script if not Follower
//------------------------------------------------------------------------------

    if (!IsFollower(OBJECT_SELF)) {
        #ifdef MK_DEBUG
        MK_PrintToLog("[Command Complete] EventManager_ReleaseLock");
        #endif
        EventManager_ReleaseLock();
        return;
    }

//------------------------------------------------------------------------------
//  MkBot:
//  Set global variable AI_LAST_TACTIC to indicate timeout. When script ends
//  normally then AI_LAST_TACTIC is changed to other value. When script is
//  terminated by the engine then value of variable AI_LAST_TACTIC remains
//  unchanged and indicates that timout occured. It is crucial to detect and
//  report timeouts because they may easy be confused with bug in source code or
//  error in user's tactics. We do it only for followers because Creatues use
//  Core Script which does not change value of AI_LAST_TACTIC variable.
//------------------------------------------------------------------------------
    if (GetGameMode() == GM_COMBAT && GetLocalInt(OBJECT_SELF, AI_LAST_TACTIC) == MK_TACTIC_ID_TIMEOUT) {
        MK_Error(MK_TACTIC_ID_TIMEOUT, "mk_command_complete", "Script Timeout");
    }
    SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, MK_TACTIC_ID_TIMEOUT);

//------------------------------------------------------------------------------
//          Advanced Tactics: Fix Invisible Wall
//------------------------------------------------------------------------------
    #ifdef MK_DEBUG
    MK_PrintToLog("[Command Complete] Section: Fix Invisible Wall");
    #endif
    if (IsHero(OBJECT_SELF)) {
        MK_FixInvisibleWall();
    }

//------------------------------------------------------------------------------
//          MkBot: Get your index to load/save Talmud Tables
//------------------------------------------------------------------------------
    /*
    #ifdef MK_DEBUG
    MK_PrintToLog("[Command Complete] Section: MK_GetPartyMemberIndex");
    #endif
    int idx = MK_GetPartyMemberIndex();
    */
//------------------------------------------------------------------------------
//          MkBot: FreeMutex
//------------------------------------------------------------------------------
    #ifdef MK_DEBUG
    MK_PrintToLog("[Command Complete] Section: FreeMutex");
    #endif
    if( nLastCommandType == COMMAND_TYPE_USE_ABILITY )
        MK_FreeAbilityLock(nLastSubCommand);

//------------------------------------------------------------------------------
//          MkBot: Clear Combat Start Table if in Exploration
//------------------------------------------------------------------------------
    /*
    #ifdef MK_DEBUG
    MK_PrintToLog("[Command Complete] Section: Clear Combat Start Table if in Exploration");
    #endif
    if( GetGameMode() == GM_EXPLORE )
        StoreIntegerInArray(MK_COMBAT_START_TABLE, FALSE,idx);
    */
//------------------------------------------------------------------------------
//          MkBot: Add Skills
//------------------------------------------------------------------------------
    _MK_AddSkills();

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
    if (nLastCommandType == 0) {
        #ifdef MK_DEBUG
        MK_PrintToLog("[Command Complete] : nLastCommandType == 0 -> return");
        #endif

        return;
    }
    if (nLastCommandType == COMMAND_TYPE_USE_ABILITY) {
        EnableWeaponTrail(OBJECT_SELF, FALSE);
    }

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
    if (IsDisabled() || IsDead() || IsDying()) {
        #ifdef MK_DEBUG
        MK_PrintToLog("[Command Complete] : Disabled, Dead or Dying  -> return");
        #endif
        // MkBot:
        // Change AI_LAST_TACTIC variable to indicate that creature has died.
        // we must override default value MK_TACTIC_ID_TIMEOUT in order to signal
        // that no timeout occured. Otherwise creture would report timeout once
        // it wakes up or is resurrected.
        SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, MK_TACTIC_ID_DEAD);
        return;
    }
    SSPlaySituationalSound(OBJECT_SELF, SOUND_SITUATION_COMMAND_COMPLETE);

//------------------------------------------------------------------------------
//          Advanced Tactics: Determine Patch Blocked Action
//------------------------------------------------------------------------------
    #ifdef MK_DEBUG
    MK_PrintToLog("[Command Complete] Section: AI_DeterminePathBlockedAction");
    #endif
    if (nCommandStatus == COMMAND_FAILED_PATH_ACTION_REQUIRED) {
        /* Advanced Tactics */
        if (AT_IsControlled(OBJECT_SELF) && !GetLocalInt(OBJECT_SELF, AI_DISABLE_PATH_BLOCKED_ACTION)){
            if (AI_DeterminePathBlockedAction(oBlockingObject)){
                if(GetCreatureRacialType(OBJECT_SELF) == RACE_ANIMAL)
                    DisplayFloatyMessage(OBJECT_SELF, "(Your dog is confused a little. He cannot reach the opponent.)", FLOATY_MESSAGE, 0xDF75CF, 3.0f);
                else
                    DisplayFloatyMessage(OBJECT_SELF, "Path blocked. I cannot reach the opponent.", FLOATY_MESSAGE, 0xDF75CF, 3.0f);
                #ifdef MK_DEBUG
                MK_PrintToLog("[Command Complete] Path blocked -> return");
                #endif
                return;
            }
        }
    }


//------------------------------------------------------------------------------
//          MkBot: Set Sneaky Bastard Status
//------------------------------------------------------------------------------
/*
    if ((nLastCommandType == COMMAND_TYPE_ATTACK) ||
        (nLastCommandType == COMMAND_TYPE_USE_ABILITY))
    {
        oLastTarget = GetEventObject(ev, 1);
    }

    if (IsObjectValid(oLastTarget) &&
        IsObjectHostile(OBJECT_SELF, oLastTarget))
    {
        if (nCommandStatus == COMMAND_SUCCESSFUL)
        {
            MK_SetSneakyBastardStatus(FALSE, oLastTarget);
        }
        else if(nCommandStatus == COMMAND_FAILED_TIMEOUT)
        {
            DisplayFloatyMessage(OBJECT_SELF, "I give up! He's Sneaky Bastard ",FLOATY_MESSAGE, 0xDF75CF, 5.0);
            MK_SetSneakyBastardStatus(TRUE, oLastTarget);
        }
    }
*/
//------------------------------------------------------------------------------
//          MkBot: Determine Combat Round
//------------------------------------------------------------------------------
    #ifdef MK_DEBUG
    MK_PrintToLog("[Command Complete] Section: Determine Combat Round");
    #endif

    _MK_AI_DetermineCombatRound(oLastTarget, nLastCommandType, nCommandStatus, nLastSubCommand);
    MK_PrintToLog("[Command Complete] : Event End");

    #ifdef MK_DEBUG_OBJECT_SELF
    MK_LogCommandQueue(OBJECT_SELF);
    MK_LogCreatureVar(OBJECT_SELF);
    MK_LogCreatureVar(oLastTarget);
    #endif

}

 /** @brief ***INTERNAL***
* Give the optional abilities to the group.
* I give it to whole group to be sure the player can access it with all party members.

* I put that here because it remove the need to have a starting script for the mod, or
* override other events. Getting the abilities on the first command is not perfect but ok
* until I find a better solution.
**/
void _MK_AddSkills() {
    #ifdef MK_DEBUG
    MK_PrintToLog("[Command Complete] Section: Add Skills");
    #endif

    if (!HasAbility(OBJECT_SELF, AF_AT_ABILITY_POSSESSED))
        AddAbility(OBJECT_SELF, AF_AT_ABILITY_POSSESSED);

    if (!HasAbility(OBJECT_SELF, AF_AT_ABILITY_TRAITORS))
        AddAbility(OBJECT_SELF, AF_AT_ABILITY_TRAITORS);
}