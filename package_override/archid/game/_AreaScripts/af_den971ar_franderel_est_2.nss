#include "af_utility_h"

void main() {

     // Add Feastday King Marics Shield
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_KING_MARICS_SHIELD)) {
        object oContainer = GetObjectByTag("genip_chest_iron");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_shield.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_KING_MARICS_SHIELD);
        }
    }
}