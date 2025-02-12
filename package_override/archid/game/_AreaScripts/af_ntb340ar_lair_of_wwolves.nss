#include "af_utility_h"

void main() {

    // Add DLC item Dragonbone Cleaver
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_DRAGONBONE_CLEAVER)) {
        object oContainer = GetObjectByTag("ntb340cr_lt_revenant");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prc_im_reward1.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_DRAGONBONE_CLEAVER);
        }
    }
}