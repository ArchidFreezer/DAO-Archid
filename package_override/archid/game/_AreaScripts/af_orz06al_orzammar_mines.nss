#include "af_utility_h"

void main() {

    // Add DLC item Reaper's Cudgel
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_REAPERS_CUDGEL)) {
        object oContainer = GetObjectByTag("orz510ip_drifters_cache", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prc_im_gib_wep_mac_dao.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_REAPERS_CUDGEL);
        }
    }
}