#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB310AR)) {
        object oContainer;                  
        
        // Add DLC item Blood Dragon Plate Boots
        oContainer = GetObjectByTag("ntb310ip_dragonhorde");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_dragon_blood_boots.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB310AR);
    }
}