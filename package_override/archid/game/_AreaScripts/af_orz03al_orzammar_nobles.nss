#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_ORZ03AL)) {
        object oContainer;                   
        
        // Add DLC item High Regard of House Dace
        oContainer = GetObjectByTag("orz310ip_chest", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prc_im_gib_acc_amu_dao.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_ORZ03AL);
    }
}