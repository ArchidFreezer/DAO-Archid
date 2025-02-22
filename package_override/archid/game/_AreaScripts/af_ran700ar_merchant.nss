#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_RAN700AR)) {
        object oContainer = GetObjectByTag("store_ran700cr_merchant");
        if (IsObjectValid(oContainer)) {
            // Add Feastday Thoughtful Gift
            CreateItemOnObject(R"val_im_gift_thoughtful.uti", oContainer, 1, "", TRUE);
            // The Unobtainables
            CreateItemOnObject(R"gen_im_gift_map4.uti", oContainer, 1, "", TRUE);
            CreateItemOnObject(R"gen_im_gift_armband.uti", oContainer, 1, "", TRUE);
            CreateItemOnObject(R"gen_im_gift_ring4.uti", oContainer, 1, "", TRUE);
            CreateItemOnObject(R"gen_im_gift_earring.uti", oContainer, 1, "", TRUE);
            CreateItemOnObject(R"gen_im_gift_ring3.uti", oContainer, 1, "", TRUE);
            CreateItemOnObject(R"gen_im_acc_amu_am8.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_RAN700AR);
    }
}