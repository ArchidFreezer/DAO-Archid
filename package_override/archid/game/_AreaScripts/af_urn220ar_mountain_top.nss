#include "af_utility_h"

void main() {

    // Add DLC item Blood Dragon Plate
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_BLOOD_DRAGON_PLATE)) {
        object oContainer = GetObjectByTag("urn220cr_dragon");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_dragon_blood_plate.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_BLOOD_DRAGON_PLATE);
        }
    }
}