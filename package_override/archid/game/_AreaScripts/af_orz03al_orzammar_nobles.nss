#include "af_utility_h"

void main() {

    // Add DLC item High Regard of House Dace
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_HIGH_REGARD_OF_HOUSE_DACE)) {
        object oContainer = GetObjectByTag("orz310ip_chest", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prc_im_gib_acc_amu_dao.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_HIGH_REGARD_OF_HOUSE_DACE);
        }
    }
}