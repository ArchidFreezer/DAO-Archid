#include "af_utility_h"

void main() {

     // Add Feastday Qunari Prayers for the Dead
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_QUNARI_PRAYERS_DEAD)) {
        object oContainer = GetObjectByTag("store_orz100cr_faryn");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_cookie.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_QUNARI_PRAYERS_DEAD);
        }
    }
}