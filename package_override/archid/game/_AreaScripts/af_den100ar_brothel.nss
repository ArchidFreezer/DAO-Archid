#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN100AR)) {
        object oContainer;       
        
        // Add Feastday Chastity Belt
        oContainer = GetObjectByTag("liteip_rogue_letterchest");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_chastity.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN100AR);
    }
}