#include "af_utility_h"

/**
* Script for Area List: orz08al_dead_trenches
*
* Contains the following areas:
*   orz550ar_dead_trenches   (The Dead Trenches)
*
*/
void main() {

    /* orz550ar (The Dead Trenches) - run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_ORZ550AR)) {
        object oContainer;

        // Add DLC item Helm of the Deep
        oContainer = GetObjectByTag("genip_sarcophagus_dwarven", 12);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_helmdeep.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_ORZ550AR);
    }
}