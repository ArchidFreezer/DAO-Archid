#include "af_utility_h"

void main() {

     // Add Feastday Stick
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_STICK)) {
        object oContainer = GetObjectByTag("ntb200ip_ironbark");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_ball.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_STICK);
        }
    }

     // Add Uncrushable Pigeon
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_UNCRUSHABLE_PIGEON)) {
        object oContainer = GetObjectByTag("bear_great", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_pigeon.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_UNCRUSHABLE_PIGEON);
        }
    }
}