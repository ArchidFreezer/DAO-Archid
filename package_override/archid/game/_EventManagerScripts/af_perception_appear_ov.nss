                                                             /*
    Advanced Tactics event script

    Override EVENT_TYPE_PERCEPTION_APPEAR for followers

    You can search for "Advanced Tactics" comments to find changes.
    If you need comments on bioware's stuff, read rules_core.
    Comments here are only about Advanced Tactics.

    These event are managed prety much the same way as original scripts.
    - IsControlled is replaced with AT_IsControlled for EnableCPAI implementation.
    - _AI_DetermineCombatRound is replaced with _AT_AI_DetermineCombatRound for followers AI implementation.
*/

#include "var_constants_h"
#include "events_h"
#include "sys_ambient_h"
#include "sys_soundset_h"
#include "sys_stealth_h"
#include "wrappers_h"
#include "combat_h"

/* EventManager */
#include "af_eventmanager_h"

/* Advanced Tactics */
#include "at_tools_ai_h"
#include "at_tools_log_h"

/* EMAT */
#include "mk_determine_combat_round_h"

void main()
{
    if (!IsFollower(OBJECT_SELF)) {
        EventManager_ReleaseLock();
        return;
    }

    event ev = GetCurrentEvent();

    object oAppear = GetEventObject(ev, 0);
    int nHostile = GetEventInteger(ev, 0);
    int bStealthed = GetEventInteger(ev, 1);
    int nHostilityChanged = GetEventInteger(ev, 2);

    if (GetLocalInt(OBJECT_SELF, SPAWN_HOSTILE_LYING_ON_GROUND) == 1 && GetGroupId(OBJECT_SELF) == GROUP_HOSTILE_ON_GROUND) {
        if (GetGroupId(oAppear) == GROUP_PC) {
            UT_CombatStart(OBJECT_SELF, oAppear);
            SetLocalInt(OBJECT_SELF, SPAWN_HOSTILE_LYING_ON_GROUND, 0);
        }
    }

    if (GetLocalInt(OBJECT_SELF, GO_HOSTILE_ON_PERCEIVE_PC) == 1) {
        if (GetGroupId(oAppear) == GROUP_PC) {
            SetLocalInt(OBJECT_SELF, GO_HOSTILE_ON_PERCEIVE_PC, 0);
            UT_CombatStart(OBJECT_SELF, oAppear);
        }

    }

    if (bStealthed) {
        if (IsFollower(oAppear) && !Stealth_CheckSuccess(oAppear, OBJECT_SELF))
            DropStealth(oAppear);

        return;
    }

    if (nHostilityChanged) {
        if (IsObjectHostile(OBJECT_SELF, oAppear) == TRUE)
            nHostile = TRUE;
        else
            nHostile = FALSE;
    }

    if (nHostilityChanged && !nHostile != TRUE)
        Combat_HandleCreatureDisappear(OBJECT_SELF, oAppear);

    if (IsFollower(oAppear) && UT_GetShoutsFlag(OBJECT_SELF))
         SendEventOnDelayedShout(OBJECT_SELF);

    if (nHostile) {
        if (!GetCombatState(OBJECT_SELF)) {
            /* Advanced Tactics */
            /* Calling DetermineCombatRound here does nothing. Because we are
               not in combat, the default action cannot be performed and thus,
               character with non offensive tactics but offensive behavior will
               not enter combat in time.
            */
            if (!AT_IsControlled(OBJECT_SELF)) {
                _MK_AI_DetermineCombatRound();
                _AT_InitCombat(OBJECT_SELF);
            }

            if (GetLocalInt(OBJECT_SELF, AI_LIGHT_ACTIVE) == 1) {
                return;
            }

            // ---------------------------------------------------------
            // Force all allies into combat
            // ---------------------------------------------------------
            object[]  arAllies = _AT_AI_GetAllies();
            int nSize = GetArraySize(arAllies);
            command cMove;
            
            int i;
            for (i = 0; i < nSize; i++) {
                object oAlly = arAllies[i];
                if (!GetCombatState(oAlly)) {
                    if (IsFollower(oAlly) && !IsStealthy(OBJECT_SELF)) {
                        /* Advanced Tactics */
                        /* The bug here is that we want to call DetermineCombatRound
                           for the ally. Not for self as it is done.
                           So we send an init command.
                        */
                        //if (WR_TriggerPerception(oAlly, oAppear) == FALSE)

                        WR_TriggerPerception(oAlly, oAppear);
                        _AT_InitCombat(oAlly);
                    } else if (!IsFollower(oAlly)) {
                        if (GetLocalInt(oAlly, AI_FLAG_STATIONARY) == 0 && GetLocalInt(oAlly, CLIMAX_ARMY_ID) == 0) {
                            if (GetLocalInt(OBJECT_SELF, AI_HELP_TEAM_STATUS) <= 1) {
                                SetLocalInt(OBJECT_SELF, AI_HELP_TEAM_STATUS, AI_HELP_TEAM_STATUS_NORMAL_ALLY_HELP_ACTIVE);
                                cMove = CommandMoveToObject(oAppear, TRUE);
                                SetCreatureIsStatue(oAlly, FALSE);
                                WR_ClearAllCommands(oAlly, TRUE);
                                Ambient_Stop(oAlly);
                                WR_AddCommand(oAlly, cMove, TRUE, FALSE);
                            }
                        }
                    }
                }
            }
        } else {
            command cCurrent = GetCurrentCommand(OBJECT_SELF);
            int nQSize = GetCommandQueueSize(OBJECT_SELF);
            /* Advanced Tactics */
            if (!AT_IsControlled(OBJECT_SELF)) {
                if (nQSize == 0 && GetCommandType(cCurrent) == COMMAND_TYPE_INVALID) {
                    /* Advanced Tactics */
                    _MK_AI_DetermineCombatRound();
                }
            }
        }

        if (IsPartyMember(OBJECT_SELF)) {
            int nMode = GetGameMode();

            if (nMode == GM_EXPLORE || nMode == GM_DEAD) {
                if (IsObjectHostile(OBJECT_SELF, oAppear)) {
                    /* Advanced Tactics */
                    if (AT_IsControlled(OBJECT_SELF)) {
                        SSPlaySituationalSound(OBJECT_SELF, SOUND_SITUATION_ENEMY_SIGHTED, oAppear);
                    }

                    /* Advanced Tactics */
                    /* Fast auto pause */
                    //WR_SetGameMode(GM_COMBAT);
                    SetGameMode(GM_COMBAT);

                    if (nMode == GM_EXPLORE) {
                        if (ConfigIsAutoPauseEnabled())
                            ToggleGamePause();
                    }
                }
            } else if (nMode == GM_COMBAT && !GetCombatState(OBJECT_SELF))
                SetCombatState(OBJECT_SELF, TRUE);
        }
    }

    if (GetPackageAI(OBJECT_SELF) == 10130)
        AI_HandleCowardFollower(oAppear);

}