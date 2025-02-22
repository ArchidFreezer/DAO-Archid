#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN03AL)) {
        object oContainer;                 
        
        // Add Feastday Cat Lady's Hobblestick
        oContainer = GetObjectByTag("den960cr_rabid_wardog", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_stick.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN03AL);
    }
}