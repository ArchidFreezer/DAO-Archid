#ifndef MK_CONDITION_ATTACKING_PARTY_MEMEBR_H
#defsym MK_CONDITION_ATTACKING_PARTY_MEMEBR_H

//==============================================================================
//                              INCLUDES
//==============================================================================
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
object[] _MK_AI_Condition_AttackingPartyMember(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nPartyMemberType);

//==============================================================================
//                          DEFINITIONS
//==============================================================================
object[] _MK_AI_Condition_AttackingPartyMember(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nPartyMemberType)
{
    object[] arTargets;
    arTargets[0] = OBJECT_INVALID;
    arTargets[1] = OBJECT_INVALID;

    // MkBot : If Ally is Invalid then there is no point in checking whether he is attacked.
    object oAlly = _AT_AI_GetRelatedPartyTarget(nPartyMemberType, nTacticID);
    if (_AT_AI_IsAllyValid(oAlly) == FALSE)
        return arTargets;
    arTargets[1] = oAlly;

    int nIsFriendValidForAbility = _MK_AI_IsFriendValidForAbility(arTargets[1], nTacticCommand, nTacticSubCommand, nAbilityTargetType);
    switch(nTargetType)
    {
        case AI_TARGET_TYPE_ENEMY:
        case AT_TARGET_TYPE_TARGET:
        case MK_TARGET_TYPE_SAVED_ENEMY:
        case AI_TARGET_TYPE_MOST_HATED:
        {
            object[] arEnemies = _MK_AI_GetEnemiesFromTargetType(nTargetType);
            int nSize = GetArraySize(arEnemies);

            int i;
            for (i = 0; i < nSize; i++)
            {
                int nIsEnemyValidForAbility = _AT_AI_IsEnemyValidForAbility(arEnemies[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType);
                int nIsTargetValidForAbility = nIsFriendValidForAbility || nIsEnemyValidForAbility;

                if (nIsTargetValidForAbility == TRUE
                &&  _MK_AI_IsSleepRoot(arEnemies[i]) == FALSE
                &&  GetAttackTarget(arEnemies[i]) == arTargets[1])
                {
                    arTargets[0] = arEnemies[i];
                    return arTargets;
                }
            }

            break;
        }
        default:
        {
            string sMsg = "[_MK_AI_Condition_AttackingPartyMember] ERROR: Unknown Target Type = " + IntToString(nTargetType);
            DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, 0xFF0000, 5.0);
            MK_PrintToLog(sMsg);

            break;
        }
    }

    return arTargets;
}
#endif