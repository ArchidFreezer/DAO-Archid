#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_LOT100AR)) {
        object oContainer;

        // Add Feastday Ugly Boots
        oContainer = GetObjectByTag("genip_pile_filth");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_boots.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_LOT100AR);
    }
}