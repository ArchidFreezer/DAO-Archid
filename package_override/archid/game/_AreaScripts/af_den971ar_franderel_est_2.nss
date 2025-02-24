#include "af_utility_h"

/**
* Script for Area List: den971ar_franderel_estate_2
*
* Contains the following areas:
*   den971ar_franderel_estate_2  (South Wing of Bann Franderel's Estate)
*
*/
void main() {

    /* den971ar (South Wing of Bann Franderel's Estate) - Run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN971AR)) {
        object oContainer;

        // Add Feastday King Marics Shield
        oContainer = GetObjectByTag("genip_chest_iron");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_shield.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN971AR);
    }
}