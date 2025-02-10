#include "af_option_h"
#include "af_utility_h"

void main() {
    event ev = GetCurrentEvent();
    object oItem = GetEventObject(ev, 0);

    // Dain's Rune slots fix
    AF_CheckRuneSlots(oItem);            
                                 
    // Dain's Display received items
    if (IsFollower(OBJECT_SELF) && AF_IsOptionEnabled(AF_OPT_RECEIVED_ITEM_DURATION)) {
        string sMsg = GetName(oItem);
        // Add material if equippable
        if ((GetM2DAInt(6, "EquippableSlots", GetBaseItemType(oItem)) & 243) > 0) {
            int nMaterial = GetM2DAInt(89, "Material", GetItemMaterialType(oItem));
            if (nMaterial > 0) {
                string sName = GetTlkTableString(GetM2DAInt(159, "NameStrRef", nMaterial));
                if (GetStringLength(sName) > 0)
                    sMsg += " (" + sName + ")";
            }
        }
        
        DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, AF_GetOptionValue(AF_OPT_RECEIVED_ITEM_COLOUR), IntToFloat(AF_GetOptionValue(AF_OPT_RECEIVED_ITEM_DURATION)));
    }
    
}