#ifndef AT_SUBCONDITION_USING_ATTACK_TYPE_H
#defsym AT_SUBCONDITION_USING_ATTACK_TYPE_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/*Core*/
#include "ai_main_h_2"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
int _AT_AI_SubCondition_UsingAttackType/*N*/(object oTarget, int nAttackType);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
int _AT_AI_SubCondition_UsingAttackType(object oTarget, int nAttackType)
{
    int nRet = AI_ATTACK_TYPE_INVALID;

    if (IsMagicUser(oTarget) == TRUE)
        nRet |= AI_ATTACK_TYPE_MAGIC;

    object oItem = GetItemInEquipSlot(INVENTORY_SLOT_MAIN, oTarget);

    if (IsObjectValid(oItem) == TRUE)
    {
        int nItemType = GetItemType(oItem);

        if (nItemType == ITEM_TYPE_WEAPON_RANGED)
            nRet |= AI_ATTACK_TYPE_RANGED;
        else if (nItemType == ITEM_TYPE_WEAPON_MELEE)
            nRet |= AI_ATTACK_TYPE_MELEE;
    }
    else if (nRet == AI_ATTACK_TYPE_INVALID)
        nRet |= AI_ATTACK_TYPE_MELEE;

    return ((nRet & nAttackType) != 0);
}

#endif