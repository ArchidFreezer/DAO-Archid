#include "af_utility_h"

void main() {

     // Add Feastday Beard Flask
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_BEARD_FLASK)) {
        object oContainer = GetObjectByTag("genip_barrel_standard", 2);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_flask.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_BEARD_FLASK);
        }
    }
}