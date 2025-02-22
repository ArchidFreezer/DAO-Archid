#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB02AL)) {
        object oContainer;
        
        // Add Feastday Stick
        oContainer = GetObjectByTag("ntb200ip_ironbark");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_ball.uti", oContainer, 1, "", TRUE);
        }                     
        
        // Add Uncrushable Pigeon
        oContainer = GetObjectByTag("bear_great", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_pigeon.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB02AL);
    }
}