#include "af_utility_h"

/**
* Script for Area List: lot110ar_chantry
*
* Contains the following areas:
*   lot110ar_chantry (Chantry)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "lot110ar_chantry") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_LOT110AR)) {

            // Add Feastday Chant of Light
            object oContainer = GetObjectByTag("lot100ip_holy_sym_chest");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"val_im_gift_chant.uti", oContainer, 1, "", TRUE);
            }

            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_LOT110AR);
        }
    }
}