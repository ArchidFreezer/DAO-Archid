#include "af_utility_h"

void main() {

     // Add Feastday Thoughtful Gift
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_THOUGHTFUL_GIFT)) {
        object oContainer = GetObjectByTag("store_ran700cr_merchant");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_thoughtful.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_THOUGHTFUL_GIFT);
        }
    }
}