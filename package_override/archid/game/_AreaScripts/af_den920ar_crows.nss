#include "af_utility_h"

/**
* Script for Area List: den920ar_crows
*
* Contains the following areas:
*   den920ar_crows  (Back Alley - Crows)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "den920ar_crows") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN920AR)) {

            // Add DLC item Wicked Oath
            object oContainer = GetObjectByTag("den920cr_taliesen");
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
}