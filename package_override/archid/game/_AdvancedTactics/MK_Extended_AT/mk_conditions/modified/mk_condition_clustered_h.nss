#ifndef TIN_CONDITION_GET_ENEMY_CLUSTERED_WITH_SAME_GROUP_H
#defsym TIN_CONDITION_GET_ENEMY_CLUSTERED_WITH_SAME_GROUP_H

//==============================================================================
//                                INCLUDES
//==============================================================================
#include "af_ability_h"

/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_condition_most_hated_h"
#include "tin_cluster_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object _MK_AI_Condition_GetEnemyClusteredWithSameGroup (int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nMinClusterSize);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
object _MK_AI_Condition_GetEnemyClusteredWithSameGroup(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nMinClusterSize)
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

    object[] arTargets = tin_GetClusterCenter(OBJECT_SELF,      // Tinman : The creature who's tactic is being processed
                                              nTacticSubCommand,// Tinman : The ability ID
                                              nMinClusterSize,  // Tinman : The minimum # of enemies in the cluster, including the target
                                              nAllyFailChance,  // Tinman : The probability of failing the condition if an ally is in the cluster area
                                              FALSE);           // Tinman : This parameter is ignored in my function

    if ((_AT_AI_IsEnemyValid(arTargets[0], TRUE, arTargets[0] != GetAttackTarget(OBJECT_SELF)) == TRUE)
    && (_AT_AI_IsEnemyValidForAbility(arTargets[0], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
    {
        return arTargets[0];
    }

    return OBJECT_INVALID;
}
#endif