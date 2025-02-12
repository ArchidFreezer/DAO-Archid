#include "af_utility_h"

void main() {

    // Add DLC item Dalish Promise Ring
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_DALISH_PROMISE_RING)) {
        object oContainer = GetObjectByTag("ntb100ip_lanaya_chest");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_dalish_ring.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_DALISH_PROMISE_RING);
        }
    }
}