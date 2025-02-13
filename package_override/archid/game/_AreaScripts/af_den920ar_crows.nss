#include "af_utility_h"

void main() {

    // Add DLC item Wicked Oath
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG2, AF_DLC2_WICKED_OATH)) {
        object oContainer = GetObjectByTag("den920cr_taliesen");
        if (IsObjectValid(oContainer)) {
            object oItem = CreateItemOnObject(R"prm000im_wickedoath.uti", oContainer, 1, "", TRUE);
            EquipItem(oContainer, oItem);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG2, AF_DLC2_WICKED_OATH);
        }
    }

     // Add Feastday Rare Antivan Brandy
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_RARE_ANTIVAN_BRANDY)) {
        object oContainer = GetObjectByTag("genip_crate_wood_large");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_brandy.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_RARE_ANTIVAN_BRANDY);
        }
    }
}