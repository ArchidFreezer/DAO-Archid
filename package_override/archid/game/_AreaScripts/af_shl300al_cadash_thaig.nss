#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_SHL300AL)) {
        object oContainer;                        
        
        // Add DLC item Cinch of Skillful Manoeuvering
        oContainer = GetObjectByTag("genip_chest_iron", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prc_im_reward4.uti", oContainer, 1, "", TRUE);
        }
        
        // Add Feastday Pet Rock
        oContainer = GetObjectByTag("genip_rubble", 2);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_rock.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_SHL300AL);
    }
}