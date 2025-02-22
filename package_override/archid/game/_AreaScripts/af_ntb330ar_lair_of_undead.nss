#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB330AR)) {
        object oContainer;             
        
        // Add DLC item Sorrows of Arlathan
        oContainer = GetObjectByTag("ntb330ip_codex_coffin");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prc_im_reward2.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB330AR);
    }
}