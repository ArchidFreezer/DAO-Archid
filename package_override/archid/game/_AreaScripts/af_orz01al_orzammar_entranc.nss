#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_ORZ01AL)) {
        object oContainer;                     
        
        // Add Feastday Qunari Prayers for the Dead
        oContainer = GetObjectByTag("store_orz100cr_faryn");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_cookie.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_ORZ01AL);
    }
}