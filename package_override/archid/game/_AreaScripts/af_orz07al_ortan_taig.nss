#include "af_utility_h"

/**
* Script for Area List: orz07al_ortan_taig
*
* Contains the following areas:
*   orz530ar_ortan_thaig  (Ortan Thaig)
*
*/
void main() {

    /* orz530ar (Ortan Thaig) - run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_ORZ530AR)) {
        object oContainer;

        // Add Feastday Butterfly Sword
        oContainer = GetObjectByTag("orz530ip_cocoon");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_skull.uti", oContainer, 1, "", TRUE);
        }

        // Add Feastday Rotten Onion
        oContainer = GetObjectByTag("store_orz530cr_ruck");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_onion.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_ORZ530AR);
    }
}