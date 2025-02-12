#include "af_utility_h"

void main() {

    // Add DLC item Sorrows of Arlathan
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_SORROWS_OF_ARLATHAN)) {
        object oContainer = GetObjectByTag("ntb330ip_codex_coffin");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prc_im_reward2.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_SORROWS_OF_ARLATHAN);
        }
    }
}