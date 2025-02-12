#include "af_utility_h"

void main() {

    // Add DLC item Darkspawn Chronicles
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_DARKSPAWN_CHRONICLES)) {
        object oContainer = GetObjectByTag("drk_riordan", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prc_im_wep_mel_lsw_drk_dao.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_DARKSPAWN_CHRONICLES);
        }
    }
}