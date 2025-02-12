#include "af_utility_h"

void main() {

    // Add DLC item Helm of the Deep
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_HELM_OF_THE_DEEP)) {
        object oContainer = GetObjectByTag("genip_sarcophagus_dwarven", 12);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_helmdeep.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_HELM_OF_THE_DEEP);
        }
    }
}