#include "af_utility_h"

void main() {

     // Add Feastday Chant of Light
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_CHANT_OF_LIGHT)) {
        object oContainer = GetObjectByTag("lot100ip_holy_sym_chest");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_chant.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_CHANT_OF_LIGHT);
        }
    }
}