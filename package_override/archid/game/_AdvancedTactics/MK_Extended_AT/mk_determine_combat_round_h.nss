#ifndef MK_DETERMINE_COMBAT_ROUND_H
#defsym MK_DETERMINE_COMBAT_ROUND_H
// anakin55: The stuff that started with if(!IsFollower(OBJECT_SELF)) has been
// removed since it is not needed for followers.
// MkBot: It is not needed because EventManager calls vanilla routine for
// non-followers.

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_ai_h"
#include "at_tools_aoe_h"
#include "at_tools_geometry_h"
#include "at_tools_ai_constants_h"
#include "at_tools_log_h"

/* Behaviors */
#include "at_behavior_avoid_aoe_h"
#include "at_behavior_avoid_enemies_h"
#include "at_behavior_avoid_melee_h"
#include "mk_behavior_switch_weapon_h"
#include "mk_behavior_attack_h"
#include "mk_behavior_move_h"

/* MkBot */
//#include "mk_ai_conditions_h"
#include "mk_execute_tactic_h"
#include "mk_add_command_h"

/* Talmud Storage*/
#include "talmud_storage_h"


//==============================================================================
//                                DECLARATIONS
//==============================================================================
void _MK_AI_DetermineCombatRound(object oLastTarget = OBJECT_INVALID, int nLastCommand = 0, int nLastCommandStatus = COMMAND_SUCCESSFUL, int nLastSubCommand = -1);
void _AT_AI_DetermineCombatRound_Partial(object oLastTarget, int nLastCommand, int nLastCommandStatus, int nLastSubCommand);

//==============================================================================
//                                DEFINITIONS
//==============================================================================

/** @brief Checks Behaviors and Tactics to determine next command
*
* This is the heart of "Even More Advanced Tactics" addin.
* We check character's Behavior and Tactic Table here in order to determine
* the next command. This command is added to character's command queue.
*
* @param oLastTarget the target of last executed command
* @param nLastCommand ID of last executed command
* @param nLastCommandStatus result of last executed command
* @author MkBot
*/
void _MK_AI_DetermineCombatRound(object oLastTarget = OBJECT_INVALID, int nLastCommand = 0, int nLastCommandStatus = COMMAND_SUCCESSFUL, int nLastSubCommand = -1)
{
    #ifdef MK_DEBUG
    MK_PrintToLog("[_MK_AI_DetermineCombatRound] MK_DEBUG Started");
    #endif
    if (GetCombatantType(OBJECT_SELF) == CREATURE_TYPE_NON_COMBATANT)
    {
        SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, MK_TACTIC_ID_NOT_COMBATANT);
        return;
    }
    if ((GetGameMode() != GM_COMBAT)
    && (GetGameMode() != GM_EXPLORE))
    {
        /* Advanced Tactics */
        if (AT_IsControlled(OBJECT_SELF) != TRUE)
        {
            command cWait = _AT_AI_DoNothing();
            MK_AddCommand(OBJECT_SELF, cWait);
        }
        SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, MK_TACTIC_ID_GAMEMODE_TEST_FAIL);
        return;
    }

    SetObjectInteractive(OBJECT_SELF, TRUE);

//------------------------------------------------------------------------------
//                      Check Command Queue
//------------------------------------------------------------------------------
    #ifdef MK_DEBUG
    MK_PrintToLog("[_MK_AI_DetermineCombatRound] MK_DEBUG Check Command Queue");
    #endif
    command cCurrent = GetCurrentCommand(OBJECT_SELF);
    int nCurrentType = GetCommandType(cCurrent);
    int nQueueSize = GetCommandQueueSize(OBJECT_SELF);
    if ((nCurrentType != COMMAND_TYPE_INVALID) || (nQueueSize > 0))
    {
        /*
        if( nQueueSize > 0 )
        {

            command cNextCommand = GetCommandByIndex(OBJECT_SELF,0);
            if( GetCommandIsPlayerIssued(cNextCommand) == TRUE )
            {
                int nNextType = GetCommandType(cNextCommand);
                switch(nNextType)
                {
                    case COMMAND_TYPE_USE_ABILITY:
                    {
                        int nAbilityId = GetCommandInt(cNextCommand,0);
                        object oTarget = GetCommandObject(cNextCommand, 0);
                        MK_SetAbilityLock(nAbilityId, oTarget);
                        break;
                    }
                    //case COMMAND_TYPE_SWITCH_WEAPON_SETS:
                    //{
                    //    break;
                    //}
                }

            }
        }
        */
        SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, MK_TACTIC_ID_PROCESSING_COMMAND_QUEUE);
        return;
    }
    else if (GetCreatureFlag(OBJECT_SELF, CREATURE_RULES_FLAG_AI_OFF))
    {
        SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, MK_TACTIC_ID_AI_OFF);
        return;
    }

//------------------------------------------------------------------------------
//              Advanced Tactics - Avoid AOE
//------------------------------------------------------------------------------
    #ifdef MK_DEBUG
    MK_PrintToLog("[_MK_AI_DetermineCombatRound] MK_DEBUG Advanced Tactics - Avoid AOE");
    #endif
    if ( AT_IsControlled(OBJECT_SELF) != TRUE )
    {
        command cBehavior = AT_BehaviorAvoidAOE();
        if( GetCommandType(cBehavior) != COMMAND_TYPE_INVALID )
        {
            MK_AddCommand(OBJECT_SELF, cBehavior);
            SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, MK_TACTIC_ID_BEHAVIOR_AVOID_AOE);
            return;
        }
    }

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
    #ifdef MK_DEBUG
    MK_PrintToLog("[_MK_AI_DetermineCombatRound] MK_DEBUG IsPartyAIEnabled");
    #endif
    if (IsPartyAIEnabled(OBJECT_SELF) != TRUE)
    {
        _AT_AI_DetermineCombatRound_Partial(oLastTarget, nLastCommand, nLastCommandStatus, nLastSubCommand);
        SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, MK_TACTIC_ID_AI_PARTIAL);
        return;
    }

    if (Effects_HasAIModifier(OBJECT_SELF, AI_MODIFIER_IGNORE))
    {
        SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, MK_TACTIC_ID_AI_MODIFIER_IGNORE);
        return;
    }

//------------------------------------------------------------------------------
//              Behavior: MkBot - Switch Weapon
//------------------------------------------------------------------------------
    #ifdef MK_DEBUG
    MK_PrintToLog("[_MK_AI_DetermineCombatRound] MK_DEBUG Behavior: MkBot - Switch Weapon");
    #endif
    command cBehavior = MK_BehaviorSwitchWeapon();
    if (GetCommandType(cBehavior) != COMMAND_TYPE_INVALID)
    {
        MK_AddCommand(OBJECT_SELF, cBehavior);
        SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, MK_TACTIC_ID_BEHAVIOR_SWITCH_WEAPON);
        return;
    }


//------------------------------------------------------------------------------
//              Behavior: Advanced Tactics - Avoid Enemies
//------------------------------------------------------------------------------
    #ifdef MK_DEBUG
    MK_PrintToLog("[_MK_AI_DetermineCombatRound] MK_DEBUG Behavior: Advanced Tactics - Avoid Enemies");
    #endif
    if (AT_IsControlled(OBJECT_SELF) != TRUE)
    {
        command cBehavior = AT_BehaviorAvoidEnemies(nLastCommand);
        if( GetCommandType(cBehavior) != COMMAND_TYPE_INVALID )
        {
            MK_AddCommand(OBJECT_SELF, cBehavior);
            SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, MK_TACTIC_ID_BEHAVIOR_AVOID_ENEMIES);
            return;
        }
    }

//------------------------------------------------------------------------------
//                      Team Help
//------------------------------------------------------------------------------
    #ifdef MK_DEBUG
    MK_PrintToLog("[_MK_AI_DetermineCombatRound] MK_DEBUG Team Help");
    #endif
    int nTeamHelpStatus = GetLocalInt(OBJECT_SELF, AI_HELP_TEAM_STATUS);

    if (nTeamHelpStatus == AI_HELP_TEAM_STATUS_ACTIVE)
    {
        SetLocalInt(OBJECT_SELF, AI_HELP_TEAM_STATUS, AI_HELP_TEAM_STATUS_CALLED_FOR_HELP);
        command cMove = CommandMoveToLocation(GetLocation(OBJECT_SELF));
        int nTeamID = GetTeamId(OBJECT_SELF);
        if (nTeamID > 0)
        {
            object [] arTeam = GetTeam(nTeamID);
            int nSize = GetArraySize(arTeam);
            int i;
            object oCurrent;
            float fHelpDistance;
            for (i = 0; i < nSize; i++)
            {
                oCurrent = arTeam[i];

                if ((GetCombatState(oCurrent) != TRUE)
                &&  (GetLocalInt(oCurrent, AI_HELP_TEAM_STATUS) == AI_HELP_TEAM_STATUS_ACTIVE))
                {
                    #ifdef MK_DEBUG
                    MK_PrintToLog("[_MK_AI_DetermineCombatRound] MK_DEBUG I called for help: " + ObjectToString(oCurrent));
                    #endif
                    SetLocalInt(oCurrent, AI_HELP_TEAM_STATUS, AI_HELP_TEAM_STATUS_HELPING);
                    WR_ClearAllCommands(oCurrent);
                    MK_AddCommand(oCurrent, cMove, FALSE, FALSE, -1, 0.0); // No timeout so they won't stop too soon
                }
            }
        }
    }

//------------------------------------------------------------------------------
//          Advanced Tactics - Limited AI if not Possesed
//------------------------------------------------------------------------------
    #ifdef MK_DEBUG
    MK_PrintToLog("[_MK_AI_DetermineCombatRound] MK_DEBUG Advanced Tactics - Limited AI if not Possesed");
    #endif
    if (AT_IsControlled(OBJECT_SELF) == TRUE)
    {
        SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, MK_TACTIC_ID_CONTROLLED_BY_PLAYER);
        if (GetCombatState(OBJECT_SELF) != TRUE)
            return;
        _AT_AI_DetermineCombatRound_Partial(oLastTarget, nLastCommand, nLastCommandStatus, nLastSubCommand);
        return;
    }

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
    #ifdef MK_DEBUG
    MK_PrintToLog("[_MK_AI_DetermineCombatRound] MK_DEBUG AI_BALLISTA_SHOOTER_STATUS");
    #endif
    if (GetLocalInt(OBJECT_SELF, AI_BALLISTA_SHOOTER_STATUS) > 0)
    {
        if (AI_Ballista_HandleAI() == TRUE)
        {
            SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, MK_TACTIC_ID_BALLISTA_AI);
            return;
        }
    }

//------------------------------------------------------------------------------
//                      Player's Tactics
//------------------------------------------------------------------------------
    #ifdef MK_DEBUG
    MK_PrintToLog("[_MK_AI_DetermineCombatRound] MK_DEBUG Player's Tactics");
    #endif
    int nPackageTable = _AI_GetPackageTable();
    int nTacticsNum;

    int nUseGUITables = _AT_AI_UseGUITables();

    if (nUseGUITables == TRUE)
        nTacticsNum = GetNumTactics(OBJECT_SELF);
    else
        nTacticsNum = _AI_GetTacticsNum(nPackageTable);

//    if (nTacticsNum > AI_MAX_TACTICS) //MkBot: LOL
//    {
//        DisplayFloatyMessage(OBJECT_SELF, "ERROR: nTacticsNum > AI_MAX_TACTICS", FLOATY_MESSAGE, 0xFF0000, 5.0);
//        SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, MK_TACTIC_ID_TOO_MANY_TACTICS);
//        return;
//    }

    int nTacticID = 1;
    int nLastTacticID = GetLocalInt(OBJECT_SELF, AI_LAST_TACTIC);
    int nTablesDisabled = GetLocalInt(GetModule(), AI_DISABLE_TABLES);

    int nIsLastCommandSetAsTarget = nLastCommand == AI_COMMAND_USE_ABILITY &&
                                    nLastSubCommand == MK_COMMAND_SET_AS_TARGET;
    if (nLastTacticID >= 0 &&
        (nLastCommandStatus < 0 || nIsLastCommandSetAsTarget == TRUE))
    {
        nTacticID = nLastTacticID;
        nTacticID++;
    }

    int nExecuteRet;

    if (nTablesDisabled != TRUE)
    {
        while (nTacticID <= nTacticsNum)
        {

            struct TacticRow tTactic = GetTacticRowFromTable(nTacticID, nUseGUITables, nPackageTable);
            if (MK_IsMultiConditionTactic(tTactic))
            {
                nExecuteRet = MK_AI_HandleMultiCondition(tTactic, nTacticsNum, nUseGUITables, nPackageTable);
                if (nExecuteRet > 0)
                {
                    nTacticID += nExecuteRet;
                    continue;
                }
                else //error
                {
                    break;
                }
            }

            #ifdef MK_DEBUG_TACTIC_ROW
            MK_PrintToLog(TacticRowToString(tTactic));
            #endif

            nExecuteRet = _MK_AI_ExecuteTactic(tTactic, oLastTarget, nLastCommand, nLastCommandStatus, nLastSubCommand);

            if (nExecuteRet == FALSE)
                nTacticID++;
            else if (nExecuteRet == TRUE)
                return;
            else if (nExecuteRet == -1)
                break;
            else
            {
                //----------- Advanced Tactics -----------
                // Here was the bug of the [Jump to] command.
                // Index are stored from 0 to X into the tactics screen. But real
                // tactics index are from 1 to X + 1.
                // It means that [Jump to 3] in-game is interpreted as [Jump to 2]
                // in scripts.
                // So we need to increase nExecuteRet by 1 before doing the jump stuff.

                nExecuteRet += 1;
                if ((nExecuteRet > 1)
                && (nExecuteRet > nTacticID))
                {
                    nTacticID = nExecuteRet/* - 1*/; //MkBot: ?? +1 - 1 = 0
                }
            }
        }
    }


//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
    #ifdef MK_DEBUG
    MK_PrintToLog("[_MK_AI_DetermineCombatRound] MK_DEBUG GetObjectActive(OBJECT_SELF) != TRUE");
    #endif
    if (GetObjectActive(OBJECT_SELF) != TRUE)
    {
        SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, MK_TACTIC_ID_OBJECT_NOT_ACITVE);
        return;
    }

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
    #ifdef MK_DEBUG
    MK_PrintToLog("[_MK_AI_DetermineCombatRound] MK_DEBUG GetCombatState(OBJECT_SELF) != TRUE");
    #endif
    if (GetCombatState(OBJECT_SELF) != TRUE)
    {
        SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, MK_TACTIC_ID_OBJECT_NOT_IN_COMBAT);
        return;
    }

//------------------------------------------------------------------------------
//                  Advanced Tactics - Behavior: Avoid Melee
//------------------------------------------------------------------------------
//MkBot: Works only towards selected target :/
    #ifdef MK_DEBUG
    MK_PrintToLog("[_MK_AI_DetermineCombatRound] MK_DEBUG Advanced Tactics - Behavior: Avoid Melee");
    #endif
    if (AT_IsControlled(OBJECT_SELF) != TRUE) //MkBot: added check AT_IsControlled
    {
        command cBehavior = AT_BehaviorAvoidMelee(nLastCommand);
        if( GetCommandType(cBehavior) != COMMAND_TYPE_INVALID )
        {
            MK_AddCommand(OBJECT_SELF, cBehavior);
            SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, MK_TACTIC_ID_BEHAVIOR_AVOID_MELEE);
            return;
        }
    }

//------------------------------------------------------------------------------
//                  Behavior: MkBot - Attack
//------------------------------------------------------------------------------
    cBehavior = MK_BehaviorAttack(oLastTarget, nLastCommand, nLastCommandStatus);
    if (GetCommandType(cBehavior) != COMMAND_TYPE_INVALID)
    {
        MK_AddCommand(OBJECT_SELF, cBehavior);
        SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, MK_TACTIC_ID_BEHAVIOR_ATTACK);
        return;
    }

//------------------------------------------------------------------------------
//                  Behavior: MkBot - Move
//------------------------------------------------------------------------------
    cBehavior = MK_BehaviorMove(oLastTarget, nLastCommand, nLastCommandStatus);
    if (GetCommandType(cBehavior) != COMMAND_TYPE_INVALID)
    {
        MK_AddCommand(OBJECT_SELF, cBehavior);
        SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, MK_TACTIC_ID_BEHAVIOR_MOVE);
        return;
    }

    MK_AddCommand(OBJECT_SELF, CommandWait(0.5));
    SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, MK_TACTIC_ID_WAIT);
} // _MK_AI_DetermineCombatRound
  
#ifndef AT_DETERMINE_COMBAT_ROUND_PARTIAL
#defsym AT_DETERMINE_COMBAT_ROUND_PARTIAL
void _AT_AI_DetermineCombatRound_Partial(object oLastTarget, int nLastCommand, int nLastCommandStatus, int nLastSubCommand)
{
    if (GetCombatState(OBJECT_SELF) != TRUE)
        return;

    command cCommand;

    object oSelectedTarget = GetAttackTarget(OBJECT_SELF);

    object oTarget = oSelectedTarget;
    /* Advanced Tactics */
    if (_AT_AI_IsEnemyValid(oTarget) != TRUE)
        oTarget = oLastTarget;

    if (_AT_AI_IsEnemyValid(oTarget) == TRUE)
    {
        /* Advanced Tactics */
        /* Here is the auto attack fix.
           It just add something that I think bioware missed while writting this
           function :
           - When you are in melee, you can use use ability that may throw your target
             out of the melee range.
           - When you are in melee, the enemy can use ability that mau throw you
             out of melee range with your target.

           In the original script, a melee character stopped auto attack when his
           target goes out of melee range.
           Now, you stick your target while your last action is offensive of if your
           last action is the result of an effect (32).
        */
        if ((nLastCommand == COMMAND_TYPE_ATTACK)
        || (nLastCommand == COMMAND_TYPE_USE_ABILITY)
        || (nLastCommand == 32))
            cCommand = CommandAttack(oTarget);
        else if ((IsUsingMeleeWeapon(OBJECT_SELF) == TRUE)
        && (_AI_IsTargetInMeleeRange(oTarget) == TRUE))
            cCommand = CommandAttack(oTarget);
    }

    if (GetCommandType(cCommand) == COMMAND_TYPE_INVALID)
    {
        /* Advanced Tactics */
        if (AT_IsControlled(OBJECT_SELF) == TRUE)
            return;

        cCommand = _AT_AI_DoNothing(TRUE);
    }

    /* Advanced Tactics */
    if (_AT_AI_IsEnemyValid(oTarget) == TRUE)
        _AT_AI_SetPartyAllowedToAttack(TRUE);

    WR_AddCommand(OBJECT_SELF, cCommand);
} // _AT_AI_DetermineCombatRound_Partial
#endif

#endif

//void main(){_MK_AI_DetermineCombatRound();}