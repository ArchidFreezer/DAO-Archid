#include "af_utility_h"

/**
* Script for Area List: cir210ar_tower_level_2
*
* Contains the following areas:
*   cir210ar_tower_level_2  (Senior Mage Quarters)
*
*/
void main() {

    /* cir210ar (Senior Mage Quarters) - Run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_CIR210AR)) {
        object oContainer;

        // Add DLC item Final Reason
        oContainer = GetObjectByTag("cir210ip_lt_belcache");
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