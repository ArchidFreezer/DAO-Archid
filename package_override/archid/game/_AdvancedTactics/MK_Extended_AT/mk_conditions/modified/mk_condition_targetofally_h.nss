#ifndef MK_CONDITION_GET_PARTY_MEMBER_TARGET_H
#defsym MK_CONDITION_GET_PARTY_MEMBER_TARGET_H

/* Advanced Tactics */
#include "at_tools_conditions_h"

/* MkBot */
#include "mk_constants_h"
#include "mk_constants_ai_h"

#include "mk_get_creatures_h"
#include "mk_cond_tools_h"

#include "mk_print_to_log_h"

//==============================================================================
//                          DECLARATIONS
//==============================================================================
object   _MK_AI_Condition_GetPartyMemberTarget(int nTacticCommand, int nTacticSubCommand, int nTacticID, int nAbilityTargetType, int nPartyMemberType);

//==============================================================================
//                          DEFINITIONS
//==============================================================================
object _MK_AI_Condition_GetPartyMemberTarget(int nTacticCommand, int nTacticSubCommand, int nTacticID, int nAbilityTargetType, int nPartyMemberType)
{
    switch(nPartyMemberType)
    {
        case MK_TARGET_TYPE_PARTY_MEMBER:
        case AI_TARGET_TYPE_ALLY:
        case MK_TARGET_TYPE_TEAMMATE:
        case MK_TARGET_TYPE_TEAM_MEMBER:
        case AI_TARGET_TYPE_SELF:
        case AI_TARGET_TYPE_HERO:
        case AI_TARGET_TYPE_FOLLOWER:
        case AI_TARGET_TYPE_MAIN_CONTROLLED:
        case MK_TARGET_TYPE_SAVED_FRIEND:
        {
            object[] arParty = _MK_AI_GetFollowersFromTargetType(nPartyMemberType, nTacticID, TRUE, MK_GET_PER_FOLLOWER_FROM_CONDITION_OBJECT);
            int nSize = GetArraySize(arParty);

            object oNearestTarget = OBJECT_INVALID;
            float fNearestDistance = -1.0;

            int i;
            for(i = 0; i < nSize; i++)
            {
                object oTarget = GetAttackTarget(arParty[i]);
                if (_AT_AI_IsEnemyValid(oTarget) == TRUE
                &&  _AT_AI_IsEnemyValidForAbility(oTarget, nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE)
                {
                    float fDistance = GetDistanceBetween(OBJECT_SELF, oTarget);
                    if (fNearestDistance < 0.0 || fDistance < fNearestDistance)
                    {
                        oNearestTarget = oTarget;
                        fNearestDistance = fDistance;
                    }
                }
            }

            return oNearestTarget;
        }
        default:
        {
            string sMsg = "[_MK_AI_Condition_GetPartyMemberTarget] ERROR: Unknown Target Type = " + IntToString(nPartyMemberType);
            DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, 0xFF0000, 5.0);
            MK_PrintToLog(sMsg);

            break;
        }
    }

    return OBJECT_INVALID;
}
#endif