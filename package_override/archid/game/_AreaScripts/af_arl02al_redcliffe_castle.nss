#include "af_utility_h"

/**
* Script for Area List: arl02al_redcliffe_castle
*
* Contains the following areas:
*   arl210ar_castle_dungeon     (Redcliffe Castle - Basement)
*   arl220ar_castle_main_floor  (Redcliffe Castle - Main Floor)
*
*/
void main() {

    /* arl220ar (Redcliffe Castle - Main Floor) - Run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_ARL220AR)) {
        object oContainer;

        // Add Feastday Protective Cone
        oContainer = GetObjectByTag("genip_chest_wood_1", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_muzzle.uti", oContainer, 1, "", TRUE);
        }

        // Add Feastday Grey Warden Puppet
        oContainer = GetObjectByTag("genip_chest_wood_1", 4);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_horse.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_ARL220AR);
    }
}