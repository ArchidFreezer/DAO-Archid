#include "af_utility_h"

/**
* Script for Area List: den100ar_brothel
*
* Contains the following areas:
*   den100ar_brothel  (The Pearl)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "den100ar_brothel") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN100AR)) {

            // Add Feastday Chastity Belt
            object oContainer = GetObjectByTag("liteip_rogue_letterchest");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"val_im_gift_chastity.uti", oContainer, 1, "", TRUE);
            }
            
            // Add Garahels Armour on Paedan
            object oPaedan = GetObjectByTag("den100cr_paedan");
            if (IsObjectValid(oPaedan)) {
                object oArmour = CreateItemOnObject(R"af_chest_mas_gar.uti", oPaedan, 1, "", TRUE, TRUE);
                if (IsObjectValid(oArmour)) EquipItem(oPaedan, oArmour);
            }

            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN100AR);
        }
    }
}