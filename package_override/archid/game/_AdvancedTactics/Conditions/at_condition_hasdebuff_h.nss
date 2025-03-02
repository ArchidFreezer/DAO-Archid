#ifndef AT_CONDITION_HAS_DEBUFF_H
#defsym AT_CONDITION_HAS_DEBUFF_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_condition_most_hated_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object AT_Condition_HasDebuff(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nCase);
object _AT_Condition_HasDebuff(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nCase);
int _AT_SubCondition_HasDebuff(object oTarget, int nCase);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
object AT_Condition_HasDebuff(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nCase)
{
    return _AT_Condition_HasDebuff(nTacticCommand, nTacticSubCommand, nTargetType, nTacticID, nAbilityTargetType, nCase);
}

object _AT_Condition_HasDebuff(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nCase)
{
    object[] arTargets;
    int nSize;
    int i;

    switch (nTargetType)
    {
        case AI_TARGET_TYPE_SELF:
        {
            if ((_AT_SubCondition_HasDebuff(OBJECT_SELF, nCase) == TRUE)
            && (_AT_AI_IsSelfValidForAbility(nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                return OBJECT_SELF;

            break;
        }
        case AI_TARGET_TYPE_ALLY:
        {
            /* Advanced Tactics */
            /* Include self in ally if the ability allows it */
            if ((nAbilityTargetType & TARGET_TYPE_SELF) != 0)
            {
                if ((_AT_SubCondition_HasDebuff(OBJECT_SELF, nCase) == TRUE)
                && (_AT_AI_IsSelfValidForAbility(nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                    return OBJECT_SELF;
            }

            arTargets = _AT_AI_GetAlliesInParty(FALSE);
            nSize = GetArraySize(arTargets);

            for (i = 0; i < nSize; i++)
            {
                if ((_AT_SubCondition_HasDebuff(arTargets[i], nCase) == TRUE)
                && (_AT_AI_IsAllyValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                    return arTargets[i];
            }

            break;
        }
        case AI_TARGET_TYPE_ENEMY:
        {
            object oSelectedTarget = GetAttackTarget(OBJECT_SELF);
            if ((_AT_AI_IsEnemyValid(oSelectedTarget) == TRUE)
            && (_AT_SubCondition_HasDebuff(oSelectedTarget, nCase) == TRUE)
            && (_AT_AI_IsEnemyValidForAbility(oSelectedTarget, nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                return oSelectedTarget;

            arTargets = _AT_AI_GetEnemies();
            nSize = GetArraySize(arTargets);

            for (i = 0; i < nSize; i++)
            {
                if ((_AT_SubCondition_HasDebuff(arTargets[i], nCase) == TRUE)
                && (_AT_AI_IsEnemyValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                    return arTargets[i];
            }

            break;
        }
        case AI_TARGET_TYPE_MOST_HATED:
        {
            arTargets[0] = _AT_AI_Condition_GetMostHatedEnemy();

            if ((_AT_AI_IsEnemyValid(arTargets[0]) == TRUE)
            && (_AT_SubCondition_HasDebuff(arTargets[0], nCase) == TRUE)
            && (_AT_AI_IsEnemyValidForAbility(arTargets[0], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                return arTargets[0];

            break;
        }
        case AT_TARGET_TYPE_TARGET:
        {
            arTargets[0] = GetAttackTarget(OBJECT_SELF);

            if ((_AT_AI_IsEnemyValid(arTargets[0]) == TRUE)
            && (_AT_SubCondition_HasDebuff(arTargets[0], nCase) == TRUE)
            && (_AT_AI_IsEnemyValidForAbility(arTargets[0], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                return arTargets[0];

            break;
        }
        case AI_TARGET_TYPE_HERO:
        case AI_TARGET_TYPE_FOLLOWER:
        case AI_TARGET_TYPE_MAIN_CONTROLLED:
        default:
        {
            arTargets[0] = _AT_AI_GetPartyTarget(nTargetType, nTacticID);

            if ((_AT_AI_IsAllyValid(arTargets[0]) == TRUE)
            && (_AT_SubCondition_HasDebuff(arTargets[0], nCase) == TRUE)
            && (_AT_AI_IsAllyValidForAbility(arTargets[0], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                return arTargets[0];

            break;
        }
    }

    return OBJECT_INVALID;
}
#endif

#ifndef AT_SUBCONDITION_HAS_DEBUFF_H
#defsym AT_SUBCONDITION_HAS_DEBUFF_H
int _AT_SubCondition_HasDebuff(object oTarget, int nCase)
{
    switch(nCase)
    {
        case 0:
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_WEAKNESS);

            if (GetArraySize(arEffects) > 0)
                return TRUE;

            break;
        }
        case 1:
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_AFFLICTION_HEX);

            if (GetArraySize(arEffects) > 0)
                return TRUE;

            arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_VULNERABILITY_HEX);

            if (GetArraySize(arEffects) > 0)
                return TRUE;

            break;
        }
        case 2:
        {
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_DEATH_HEX);

            if (GetArraySize(arEffects) > 0)
                return TRUE;

            break;
        }
        case 3:
        {
            /* Using it for enemies is not a problem */
            if (_AT_AI_IsTargetValidForBeneficialAbility(oTarget, AT_ABILITY_DISPEL_MAGIC) == TRUE)
                return TRUE;

            break;
        }
    }

    return FALSE;
}
#endif