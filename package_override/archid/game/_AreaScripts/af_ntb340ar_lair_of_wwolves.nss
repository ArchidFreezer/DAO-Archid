#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB340AR)) {
        object oContainer;            
        
        // Add DLC item Dragonbone Cleaver
        oContainer = GetObjectByTag("ntb340cr_lt_revenant");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prc_im_reward1.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB340AR);
    }
}