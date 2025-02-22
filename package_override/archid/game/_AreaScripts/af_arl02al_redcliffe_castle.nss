#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_ARL02AL)) {
        object oContainer;
        
        // Add Feastday Protective Cone
        oContainer = GetObjectByTag("genip_chest_wood_1", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_muzzle.uti", oContainer, 1, "", TRUE);
        }
        
        // Add Feastday Grey Warden Puppet
        oContainer = GetObjectByTag("genip_chest_wood_1", 4);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_horse.uti", oContainer, 1, "", TRUE);
        }
        
        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_ARL02AL);
    }
}