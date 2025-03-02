#ifndef AT_BEHAVIOR_AVOID_MELEE_H
#defsym AT_BEHAVIOR_AVOID_MELEE_H

//==============================================================================
//                              INCLUDES
//==============================================================================
/*Advanced Tactics*/
#include "at_tools_conditions_h"

//==============================================================================
//                          DECLARATIONS
//==============================================================================
command AT_BehaviorAvoidMelee(int nLastCommand);

//==============================================================================
//                          DEFINITIONS
//==============================================================================
command AT_BehaviorAvoidMelee(int nLastCommand)
{
//------------------------------------------------------------------------------
//              Advanced Tactics - Avoid Melee
//------------------------------------------------------------------------------

    command cRet;

    if((AI_BehaviorCheck_AvoidMelee() == TRUE)
    && (_AI_GetWeaponSetEquipped() != AI_WEAPON_SET_MELEE)
    && (GetLocalInt(OBJECT_SELF, AI_FLAG_STATIONARY) != AI_STATIONARY_STATE_HARD))
    {
        /* Advanced Tactics */
        if ((nLastCommand == COMMAND_TYPE_MOVE_AWAY_FROM_OBJECT)
        || (nLastCommand == COMMAND_TYPE_MOVE_TO_OBJECT)
        || (nLastCommand == COMMAND_TYPE_MOVE_TO_LOCATION))
        {
            return cRet;// nothing
        }
        else
        {
            /* Advanced Tactics */
            /* The following code try to make followers avoiding melee
               a little bit cleverly than just CommandMoveAwayFromObject.
            */
            object oEnemy = GetAttackTarget(OBJECT_SELF);
            if (_AT_AI_IsEnemyValid(oEnemy) == TRUE)
            {
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
                            cRet = CommandMoveToLocation(lLoc);
                            return cRet;
                        }
                    }

                    /* We add 1 to the distance to prevent unwanted border effects. */
                    cRet = CommandMoveAwayFromObject(oEnemy, fMin + 1.0f, TRUE);
                    return cRet;
                }
            }
        }
    }

    return cRet;
}
#endif

//void main(){AT_BehaviorAvoidMelee(0);}