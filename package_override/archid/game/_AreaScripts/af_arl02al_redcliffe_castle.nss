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

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "arl220ar_castle_main_floor") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_ARL220AR)) {

            // Add Feastday Protective Cone
            object oContainer = GetObjectByTag("genip_chest_wood_1", 0);
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
}