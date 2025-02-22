#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN961AR)) {
        object oContainer;
        
        // Add DLC item Amulet of the War Mage
        oContainer = GetObjectByTag("den961cr_blood_mage_last");
        if (IsObjectValid(oContainer)) {
            object oItem = CreateItemOnObject(R"prm000im_warmage.uti", oContainer, 1, "", TRUE);
            EquipItem(oContainer, oItem);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN961AR);
    }
}