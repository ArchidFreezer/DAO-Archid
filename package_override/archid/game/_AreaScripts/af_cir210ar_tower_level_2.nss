#include "af_utility_h"

/**
* Script for Area List: cir210ar_tower_level_2
*
* Contains the following areas:
*   cir210ar_tower_level_2  (Senior Mage Quarters)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "cir210ar_tower_level_2") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_CIR210AR)) {

            // Add DLC item Final Reason
            object oContainer = GetObjectByTag("cir210ip_lt_belcache");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"prm000im_final_reason.uti", oContainer, 1, "", TRUE);
            }

            // Add DLC item Formati Tome
            oContainer = GetObjectByTag("genip_corpse_charred", 0);
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"gen_im_qck_book_formari.uti", oContainer, 1, "", TRUE);
            }

            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_CIR210AR);
        }
    }
}