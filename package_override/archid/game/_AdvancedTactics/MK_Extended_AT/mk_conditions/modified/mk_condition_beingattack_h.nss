#ifndef MK_CONDITION_ATTACKED_BY_TYPE_OF_ATTACK_H
#defsym MK_CONDITION_ATTACKED_BY_TYPE_OF_ATTACK_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_subcond_attackedbytype_h"

/* MkBot */
#include "mk_constants_h"
#include "mk_constants_ai_h"

#include "mk_get_creatures_h"
#include "mk_cond_tools_h"

#include "mk_print_to_log_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object[] _MK_AI_Condition_BeingAttackedByAttackType(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nAttackType);

//==============================================================================
//                                DEFINITIONS
//==============================================================================
object[] _MK_AI_Condition_BeingAttackedByAttackType(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nAttackType)
{
    // MkBot: I'm not sure whether summoned should be included so I put
    // nIncludeSummoned variable here. This way I can easily change my mind (and code) later.
    int nIncludeSummoned = FALSE;

    object[] oTarget;
    oTarget[0] = OBJECT_INVALID;
    oTarget[1] = OBJECT_INVALID;

    switch (nTargetType)
    {
        case AI_TARGET_TYPE_ENEMY:
        case AT_TARGET_TYPE_TARGET:
        case MK_TARGET_TYPE_SAVED_ENEMY:
        case AI_TARGET_TYPE_MOST_HATED:
        {
            object[] arEnemies = _MK_AI_GetEnemiesFromTargetType(nTargetType);
            int nEnemiesNum = GetArraySize(arEnemies);

            object[] arAllies = _MK_AI_GetFollowersInParty(TRUE, nIncludeSummoned);
            int nAlliesNum = GetArraySize(arAllies);

            int iEnemy;
            int iAlly;
            //MkBot: arEnemies must be in the outside loop because we prefer current Attack Target
            for (iEnemy = 0; iEnemy < nEnemiesNum; iEnemy++)
            {
                if (_MK_AI_IsSleepRoot(arEnemies[iEnemy]) == TRUE)
                    continue;

                int nIsEnemyValidForAbility = _AT_AI_IsEnemyValidForAbility(arEnemies[iEnemy], nTacticCommand, nTacticSubCommand, nAbilityTargetType);
                for (iAlly = 0; iAlly < nAlliesNum; iAlly++)
                {                                                           
                    int nIsFriendValidForAbility = _MK_AI_IsFriendValidForAbility(arAllies[iAlly], nTacticCommand, nTacticSubCommand, nAbilityTargetType);
                    if (nIsEnemyValidForAbility == FALSE && nIsFriendValidForAbility == FALSE)
                        continue;
                        
                    if (_MK_AI_IsAttackedByAttackType(arAllies[iAlly], arEnemies[iEnemy], nAttackType) == TRUE)
                    {
                        if (nIsEnemyValidForAbility == TRUE)
                            oTarget[0] = arEnemies[iEnemy];
                        if (nIsFriendValidForAbility == TRUE)
                            oTarget[1] = arAllies[iAlly];
                        return oTarget;                        
                    }
                }
            }

            break;
        }
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
            object[] arEnemies = _MK_AI_GetEnemiesAndAttackTarget();
            int nEnemiesNum = GetArraySize(arEnemies);

            object[] arAllies = _MK_AI_GetFollowersFromTargetType(nTargetType, nTacticID);
            int nAlliesNum = GetArraySize(arAllies);

            int iAlly;
            int iEnemy;
            //MkBot: arAllies must be in the outside loop because we prefer Self
            for (iAlly = 0; iAlly < nAlliesNum; iAlly++)
            {
                int nIsFriendValidForAbility = _MK_AI_IsFriendValidForAbility(arAllies[iAlly], nTacticCommand, nTacticSubCommand, nAbilityTargetType);
                for (iEnemy = 0; iEnemy < nEnemiesNum; iEnemy++)
                {
                    int nIsEnemyValidForAbility = _AT_AI_IsEnemyValidForAbility(arEnemies[iEnemy], nTacticCommand, nTacticSubCommand, nAbilityTargetType);
                    if (nIsFriendValidForAbility == FALSE && nIsEnemyValidForAbility == FALSE)
                        continue;
                                                                
                    if (_MK_AI_IsSleepRoot(arEnemies[iEnemy]) == FALSE
                    &&  _MK_AI_IsAttackedByAttackType(arEnemies[iEnemy], arAllies[iAlly], nAttackType) == TRUE)
                    {
                        if (nIsFriendValidForAbility == TRUE)                        
                            oTarget[0] = arAllies[iAlly];
                        if (nIsEnemyValidForAbility == TRUE)
                            oTarget[1] = arEnemies[iEnemy];
                        return oTarget;
                    }
                }
            }

            break;
        }
        default:
        {
            string sMsg = "[_MK_AI_Condition_BeingAttackedByAttackType] ERROR: Unknown Target Type = " + IntToString(nTargetType);
            DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, 0xFF0000, 5.0);
            MK_PrintToLog(sMsg);

            break;
        }
    }

    return oTarget;
}

#endif
