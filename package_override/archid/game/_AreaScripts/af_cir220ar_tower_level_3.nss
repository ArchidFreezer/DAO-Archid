#include "af_utility_h"

void main() {

    // Add DLC item Embris Many Pockets
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_EMBRIS_MANY_POCKETS)) {
        object oContainer = GetObjectByTag("cir220cr_tranquil_mon", 0);
        if (IsObjectValid(oContainer)) {
            object oItem = CreateItemOnObject(R"prm000im_embri.uti", oContainer, 1, "", TRUE);
            EquipItem(oContainer, oItem);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_EMBRIS_MANY_POCKETS);
        }
    }
}