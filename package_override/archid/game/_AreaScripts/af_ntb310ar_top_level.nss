#include "af_utility_h"

/**
* Script for Area List: ntb310ar_top_level
*
* Contains the following areas:
*   ntb310ar_top_level   (Ruins Upper Level)
*
*/
void main() {

    /* ntb310ar (Ruins Upper Level) - run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB310AR)) {
        object oContainer;

        // Add DLC item Blood Dragon Plate Boots
        oContainer = GetObjectByTag("ntb310ip_dragonhorde");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_dragon_blood_boots.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB310AR);
    }
}