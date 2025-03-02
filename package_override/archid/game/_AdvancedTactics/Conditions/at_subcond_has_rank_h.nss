#ifndef AT_SUBCONDITION_HAS_RANK_H
#defsym AT_SUBCONDITION_HAS_RANK_H

//==============================================================================
//                                DECLARATIONS
//==============================================================================
int _AT_AI_SubCondition_HasRank/*N*/(object oEnemy, int nTargetRank);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
int _AT_AI_SubCondition_HasRank(object oEnemy, int nTargetRank)
{
    int nEnemyRank = GetCreatureRank(oEnemy);

    if (nTargetRank > 0)
    {
        if (nEnemyRank == nTargetRank)
            return TRUE;
    }
    else if (nTargetRank < 0)
    {
        switch(nTargetRank)
        {
            case AI_RANK_RANGE_BOSS_OR_HIGHER:
            {
                if ((nEnemyRank == CREATURE_RANK_BOSS)
                || (nEnemyRank == CREATURE_RANK_ELITE_BOSS))
                    return TRUE;

                break;
            }
            case AI_RANK_RANGE_ELITE_OR_HIGER:
            {
                if ((nEnemyRank == CREATURE_RANK_LIEUTENANT)
                || (nEnemyRank == CREATURE_RANK_BOSS)
                || (nEnemyRank == CREATURE_RANK_ELITE_BOSS))
                    return TRUE;

                break;
            }
            case AI_RANK_RANGE_ELITE_OR_LOWER:
            {
                if ((nEnemyRank == CREATURE_RANK_LIEUTENANT)
                || (nEnemyRank == CREATURE_RANK_NORMAL)
                || (nEnemyRank == CREATURE_RANK_CRITTER)
                || (nEnemyRank == CREATURE_RANK_ONE_HIT_KILL)
                || (nEnemyRank == CREATURE_RANK_WEAK_NORMAL))
                    return TRUE;

                break;
            }
            case AI_RANK_RANGE_NORMAL_OR_HIGHER:
            {
                if ((nEnemyRank == CREATURE_RANK_NORMAL)
                || (nEnemyRank == CREATURE_RANK_LIEUTENANT)
                || (nEnemyRank == CREATURE_RANK_BOSS)
                || (nEnemyRank == CREATURE_RANK_ELITE_BOSS))
                    return TRUE;

                break;
            }
            case AI_RANK_RANGE_NORMAL_OR_LOWER:
            {
                if ((nEnemyRank == CREATURE_RANK_NORMAL)
                || (nEnemyRank == CREATURE_RANK_CRITTER)
                || (nEnemyRank == CREATURE_RANK_ONE_HIT_KILL)
                || (nEnemyRank == CREATURE_RANK_WEAK_NORMAL))
                    return TRUE;

                break;
            }
        }
    }

    return FALSE;
}

#endif