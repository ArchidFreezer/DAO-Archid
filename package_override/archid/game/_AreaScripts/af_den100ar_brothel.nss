#include "af_utility_h"

void main() {

     // Add Feastday Chastity Belt
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_CHASTITY_BELT)) {
        object oContainer = GetObjectByTag("liteip_rogue_letterchest");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_chastity.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_CHASTITY_BELT);
        }
    }
}