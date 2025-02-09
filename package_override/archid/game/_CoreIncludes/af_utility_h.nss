/**
* Contains functions that are called forom more than one script
*
* These are functions that typically too small to warrant a script file of their own
*/
#include "2da_constants_h"

/** 
* @brief Adds rune slots to items that should have them but don't
*
* @param oItem  Item to check
*/
void AF_CheckRuneSlots(object oItem) {
    int nBaseType = GetBaseItemType(oItem);
    if (nBaseType > 0 && GetLocalInt(oItem, "ITEM_RUNE_ENABLED") == 0 && (GetM2DAInt(TABLE_ITEMS, "EquippableSlots", nBaseType) & 243) > 0 && GetM2DAInt(TABLE_ITEMS, "RuneCount", nBaseType) > -100) {
        SetLocalInt(oItem, "ITEM_RUNE_ENABLED", 1);
        // # of slots depends on material, so change it to force game engine to update item
        int nMat = GetItemMaterialType(oItem);
        SetItemMaterialType(oItem, 0);
        SetItemMaterialType(oItem, nMat);
    }
}

