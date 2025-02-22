#include "af_utility_h"

void main() {
    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_ORZ02AL)) {
        object oContainer;
      
        // The Unobtainables
        oContainer = GetObjectByTag("store_orz200cr_garin");
        if (IsObjectValid(oContainer))
        {
            CreateItemOnObject(R"gem_im_gift_gar.uti", oContainer, 1, "", TRUE);
            CreateItemOnObject(R"gen_im_gift_dia.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_ORZ02AL);
    }
}