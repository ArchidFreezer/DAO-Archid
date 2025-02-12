#include "af_utility_h"

void main() {

     // Add Feastday Cat Lady's Hobblestick
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_CAT_LADY_HOBBLESTICK)) {
        object oContainer = GetObjectByTag("den960cr_rabid_wardog", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_stick.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_CAT_LADY_HOBBLESTICK);
        }
    }
}