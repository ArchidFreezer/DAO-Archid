#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN920AR)) {
        object oContainer;     
        
        // Add DLC item Wicked Oath
        oContainer = GetObjectByTag("den920cr_taliesen");
        if (IsObjectValid(oContainer)) {
            object oItem = CreateItemOnObject(R"prm000im_wickedoath.uti", oContainer, 1, "", TRUE);
            EquipItem(oContainer, oItem);
        }                               
        
        // Add Feastday Rare Antivan Brandy
        oContainer = GetObjectByTag("genip_crate_wood_large");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_brandy.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN920AR);
    }

}