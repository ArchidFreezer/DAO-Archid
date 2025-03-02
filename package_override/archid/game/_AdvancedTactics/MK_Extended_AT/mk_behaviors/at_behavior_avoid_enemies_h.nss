#ifndef AT_AVOID_ENEMIES_H
#defsym AT_AVOID_ENEMIES_H

//==============================================================================
//                              INCLUDES
//==============================================================================
/*Advanced Tactics*/
#include "at_tools_conditions_h" 

/*MkBot*/
#include "mk_constants_ai_h"

//==============================================================================
//                          DECLARATIONS
//==============================================================================
command AT_BehaviorAvoidEnemies(int nLastCommandType);

//==============================================================================
//                          DEFINITIONS
//==============================================================================
command AT_BehaviorAvoidEnemies(int nLastCommandType)
{
//------------------------------------------------------------------------------
//              Advanced Tactics - Avoid Enemies
//------------------------------------------------------------------------------

    if((AI_BehaviorCheck_AvoidNearbyEnemies() == TRUE)
    && (GetLocalInt(OBJECT_SELF, AI_FLAG_STATIONARY) != AI_STATIONARY_STATE_HARD))
    {
        /* Advanced Tactics */
        if ((nLastCommandType == COMMAND_TYPE_MOVE_AWAY_FROM_OBJECT)
        || (nLastCommandType == COMMAND_TYPE_MOVE_TO_OBJECT)
        || (nLastCommandType == COMMAND_TYPE_MOVE_TO_LOCATION))
        {
            // nothing
        }
        else
        {
            /* Advanced Tactics */
            /* The following code try to make followers avoiding enemies
               a little bit cleverly than just CommandMoveAwayFromObject.
            */
            object[] arEnemies = _AT_AI_GetEnemies();
            int nSize = GetArraySize(arEnemies);
            if (nSize > 0)
            {
                object oEnemy = arEnemies[0];
                /* We scale the security distance with the enemy size.
                   0.35 (human) -> AI_MOVE_AWAY_DISTANCE_SHORT - 1 (4)
                   3 (high dragon) -> AI_MOVE_AWAY_DISTANCE_MEDIUM - 1 (12)

                   y = 3 * x + 3
                */
                float fDistance = GetDistanceBetween(OBJECT_SELF, oEnemy);
                int nAppearance = GetAppearanceType(oEnemy);
                float fAppearance = GetM2DAFloat(TABLE_APPEARANCE, "PERSPACE", nAppearance);
                float fMin = 3.0f * fAppearance + 3.0f;
                if (fDistance < fMin)
                {
                    /* We scale the max distance from controlled character
                       with the enemy size.
                       0.35 (human) -> AI_FOLLOWER_ENGAGE_DISTANCE_CLOSE (15)
                       3 (high dragon) -> 20

                       y = 2 * x + 14
                    */
                    float fDistanceToMain = GetDistanceBetween(GetMainControlled(), OBJECT_SELF);
                    float fMax = 2.0f * fAppearance + 14.0f;

                    if (fDistanceToMain > fMax)
                    {
                        vector vPos = GetPosition(OBJECT_SELF);
                        vector vPosMain = GetPosition(GetMainControlled());
                        vector vDir = vPosMain - vPos;
                        vector vDirNorm = vDir / GetVectorMagnitude(vDir);
                        /* The destination point is going to depend on where the enemy comes from.
                           For simplification, we will suppose we are always in the extrem case where
                           the enemy is between me and the main controlled character. I will move through
                           the enemy.
                           We add 1 to the distance to prevent unwanted border side effects.
                        */
                        location lLoc = Location(GetArea(OBJECT_SELF), vPos + vDirNorm * (fDistance + fMin + 1.0f), VectorToAngle(vDirNorm));

                        if (IsLocationSafe(lLoc) == TRUE)
                        {
                            command cMove = CommandMoveToLocation(lLoc);
                            return cMove;
                        }
                    }

                    /* We add 1 to the distance to prevent unwanted border effects. */
                    command cMove = CommandMoveAwayFromObject(oEnemy, fMin + 1.0f, TRUE);
                    return cMove;
                }
            }
        }
    }

    command cInvalid;
    return cInvalid;
}

//void main(){AT_BehaviorAvoidEnemies(0);}
#endif