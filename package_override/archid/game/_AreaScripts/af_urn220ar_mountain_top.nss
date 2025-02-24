#include "af_utility_h"

/**
* Script for Area List: urn220ar_mountain_top
*
* Contains the following areas:
*   urn220ar_mountain_top   (Mountain Top)
*
*/
void main() {

    /* urn220ar (Mountain Top) - run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_URN220AR)) {
        object oContainer;

        // Add DLC item Blood Dragon Plate
        oContainer = GetObjectByTag("urn220cr_dragon");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_dragon_blood_plate.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_URN220AR);
    }
}