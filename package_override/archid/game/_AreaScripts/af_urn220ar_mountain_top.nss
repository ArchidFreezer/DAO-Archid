#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_URN220AR)) {
        object oContainer;            
        
        // Add DLC item Blood Dragon Plate
        oContainer = GetObjectByTag("urn220cr_dragon");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_dragon_blood_plate.uti", oContainer, 1, "", TRUE);
        }
        
        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_URN220AR);
    }
}