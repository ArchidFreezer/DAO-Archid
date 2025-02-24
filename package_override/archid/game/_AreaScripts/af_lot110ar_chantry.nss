#include "af_utility_h"

/**
* Script for Area List: lot110ar_chantry
*
* Contains the following areas:
*   lot110ar_chantry (Chantry)
*
*/
void main() {

    /* lot110ar (Chantry) - run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_LOT110AR)) {
        object oContainer;

        // Add Feastday Chant of Light
        oContainer = GetObjectByTag("lot100ip_holy_sym_chest");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_chant.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_LOT110AR);
    }
}