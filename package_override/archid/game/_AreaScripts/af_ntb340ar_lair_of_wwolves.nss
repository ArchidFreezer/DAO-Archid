#include "af_utility_h"

/**
* Script for Area List: ntb340ar_lair_of_werewolves
*
* Contains the following areas:
*   ntb340ar_lair_of_werewolves   (Lair of the Werewolves)
*
*/
void main() {

    /* ntb340ar (Lair of the Werewolves) - run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB340AR)) {
        object oContainer;

        // Add DLC item Dragonbone Cleaver
        oContainer = GetObjectByTag("ntb340cr_lt_revenant");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prc_im_reward1.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB340AR);
    }
}