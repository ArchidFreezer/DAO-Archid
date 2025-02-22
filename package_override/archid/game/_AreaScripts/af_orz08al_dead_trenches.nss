#include "af_utility_h"

void main() {

        /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_ORZ08AL)) {
        object oContainer;          
        
        // Add DLC item Helm of the Deep
        oContainer = GetObjectByTag("genip_sarcophagus_dwarven", 12);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_helmdeep.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_ORZ08AL);
    }
}