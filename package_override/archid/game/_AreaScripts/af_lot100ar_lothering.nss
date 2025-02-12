#include "af_utility_h"

void main() {

     // Add Feastday Ugly Boots
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_UGLY_BOOTS)) {
        object oContainer = GetObjectByTag("genip_pile_filth");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_boots.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_UGLY_BOOTS);
        }
    }
}