#include "af_utility_h"

void main() {

    // Add DLC item Vestments of the Seer
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG2, AF_DLC2_VESTMENTS_OF_THE_SEER)) {
        object oContainer = GetObjectByTag("cir200cr_lt_rea_demon");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prc_im_reward3.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG2, AF_DLC2_VESTMENTS_OF_THE_SEER);
        }
    }

     // Add Feastday Amulet of Memories
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_AMUILET_OF_MEMORIES)) {
        object oContainer = GetObjectByTag("cir200cr_lt_rea_demon");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_amulet.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_AMUILET_OF_MEMORIES);
        }
    }
}