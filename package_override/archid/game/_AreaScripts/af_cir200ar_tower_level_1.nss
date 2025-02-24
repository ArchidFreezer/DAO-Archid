#include "af_utility_h"

/**
* Script for Area List: cir200ar_tower_level_1
*
* Contains the following areas:
*   cir200ar_tower_level_1 - (Apprentice Quarters)
*
*/
void main() {

    /* cir200ar (Apprentice Quarters) - Run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_CIR200AR)) {
        object oContainer;

        // Add DLC item Vestments of the Seer
        oContainer = GetObjectByTag("cir200cr_lt_rea_demon");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prc_im_reward3.uti", oContainer, 1, "", TRUE);
        }

        // Add Feastday Amulet of Memories
        oContainer = GetObjectByTag("cir200cr_lt_rea_demon");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_amulet.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_CIR200AR);
    }
}