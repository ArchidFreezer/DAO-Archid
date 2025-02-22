#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_DRK500AR)) {
        object oContainer;              
        
        // Add DLC item Darkspawn Chronicles
        oContainer = GetObjectByTag("drk_riordan", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prc_im_wep_mel_lsw_drk_dao.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_DRK500AR);
    }
}