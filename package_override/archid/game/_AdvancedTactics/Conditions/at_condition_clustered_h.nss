#ifndef AT_CONDITION_GET_ENEMY_CLUSTERED_WITH_SAME_GROUP_H
#defsym AT_CONDITION_GET_ENEMY_CLUSTERED_WITH_SAME_GROUP_H

//==============================================================================
//                                INCLUDES
//==============================================================================
#include "af_ability_h"

/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_condition_most_hated_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object _AT_AI_Condition_GetEnemyClusteredWithSameGroup (int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nMinClusterSize);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
object _AT_AI_Condition_GetEnemyClusteredWithSameGroup(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nMinClusterSize)
{
    int nAllyFailChance = 0;

    switch(nTacticSubCommand)
    {
        case AF_ABILITY_INFERNO:
        case AF_ABILITY_GREASE:
        case AF_ABILITY_EARTHQUAKE:
        case AF_ABILITY_BLIZZARD:
        case AF_ABILITY_TEMPEST:
        case AF_ABILITY_STORM_OF_THE_CENTURY:
        case AF_ABILITY_DEATH_CLOUD:
        case AF_ABILITY_ARCHDEMON_VORTEX:
        case AF_ABILITY_FLAME_BLAST:
        case AF_ABILITY_FIREBALL:
        case AF_ABILITY_BLOOD_WOUND:
        case AF_ABILITY_CONE_OF_COLD:
        case AF_ABILITY_SHOCK:
        {
            nAllyFailChance = 100;

            break;
        }
    }

    location lLoc;

    /* Advanced Tactics */
    lLoc = GetClusterCenter(OBJECT_SELF, nTacticSubCommand, nMinClusterSize, nAllyFailChance, FALSE);

    object[] arTargets = GetNearestObjectToLocation(lLoc, OBJECT_TYPE_CREATURE, 1);

    if ((_AT_AI_IsEnemyValid(arTargets[0], TRUE, arTargets[0] != GetAttackTarget(OBJECT_SELF)) == TRUE)
    && (_AT_AI_IsEnemyValidForAbility(arTargets[0], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
    {
        float fDistance = GetDistanceBetweenLocations(lLoc, GetLocation(arTargets[0]));
        if (fDistance > 5.0f)
            return OBJECT_INVALID;

        if ((nTacticSubCommand == ARCHDEMON_VORTEX)
        || (nTacticSubCommand == ARCHDEMON_SMITE))
        {
            float fClusterDistance = GetDistanceBetweenLocations(GetLocation(OBJECT_SELF), lLoc);
            if (fClusterDistance < AI_RANGE_MID_LONG)
                return OBJECT_INVALID;
        }

        return arTargets[0];
    }

    return OBJECT_INVALID;
}
#endif