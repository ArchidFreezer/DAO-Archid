#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_RAN700AR)) {
        object oContainer;         
        
        // Add Feastday Thoughtful Gift
        oContainer = GetObjectByTag("store_ran700cr_merchant");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_thoughtful.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_RAN700AR);
    }
}