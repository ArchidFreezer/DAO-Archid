#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN971AR)) {
        object oContainer;            
        
        // Add Feastday King Marics Shield
        oContainer = GetObjectByTag("genip_chest_iron");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_shield.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN971AR);
    }
}