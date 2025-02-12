#include "af_utility_h"

void main() {

    // Add DLC item Pearl of the Anointed
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_PEARL_OF_THE_ANOINTED)) {
        object oContainer = GetObjectByTag("urn110ip_chest");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_pearlan.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_PEARL_OF_THE_ANOINTED);
        }
    }
}