#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_CIR200AR)) {
        object oContainer;               
        
        // Add DLC item Vestments of the Seer
        oContainer = GetObjectByTag("cir200cr_lt_rea_demon");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prc_im_reward3.uti", oContainer, 1, "", TRUE);
        }
        
        // Add Feastday Amulet of Memories
        oContainer = GetObjectByTag("cir200cr_lt_rea_demon");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_amulet.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_CIR200AR);
    }
}