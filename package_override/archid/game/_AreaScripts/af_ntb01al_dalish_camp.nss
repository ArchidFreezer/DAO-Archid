#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB01AL)) {
        object oContainer;             
        
        // Add DLC item Dalish Promise Ring
        oContainer = GetObjectByTag("ntb100ip_lanaya_chest");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_dalish_ring.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB01AL);
    }
}