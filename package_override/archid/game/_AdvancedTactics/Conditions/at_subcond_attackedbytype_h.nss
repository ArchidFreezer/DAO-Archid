#ifndef AT_SUBCONDITION_BEING_ATTACKED_BY_ATTACK_TYPE_H
#defsym AT_SUBCONDITION_BEING_ATTACKED_BY_ATTACK_TYPE_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_subcond_useattacktype_h"

/* Talmud Storage*/
#include "talmud_storage_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
int _AT_AI_SubCondition_BeingAttackedByAttackType(object oEnemy, object oAlly, int nAttackType);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
int _AT_AI_SubCondition_BeingAttackedByAttackType(object oEnemy, object oAlly, int nAttackType)
{
    if ((GetAttackTarget(oEnemy) == oAlly)
    && (_AT_AI_SubCondition_UsingAttackType(oEnemy, nAttackType) == TRUE))
    {
        if (nAttackType == AI_ATTACK_TYPE_MELEE)
        {
            if (GetDistanceBetween(oAlly, oEnemy) <= AI_MELEE_RANGE)
                return TRUE;
        }
        else
            return TRUE;
    }

    return FALSE;
}
#endif