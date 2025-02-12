#include "af_utility_h"

void main() {

    // Add DLC item Blood Dragon Plate Boots
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_BLOOD_DRAGON_PLATE_BOOTS)) {
        object oContainer = GetObjectByTag("ntb310ip_dragonhorde");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_dragon_blood_boots.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_BLOOD_DRAGON_PLATE_BOOTS);
        }
    }
}