#include "af_utility_h"

void main() {

    // Add DLC item Memory Band
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_MEMORY_BAND_OSTAGAR)) {
        object oContainer = GetObjectByTag("pre100ip_wizards_chest");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"gen_im_acc_rng_exp.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_MEMORY_BAND_OSTAGAR);
        }
    }
}