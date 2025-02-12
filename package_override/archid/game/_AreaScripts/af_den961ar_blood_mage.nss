#include "af_utility_h"

void main() {

    // Add DLC item Amulet of the War Mage
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_AMULET_OF_THE_WAR_MAGE)) {
        object oContainer = GetObjectByTag("den961cr_blood_mage_last");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_warmage.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_AMULET_OF_THE_WAR_MAGE);
        }
    }
}