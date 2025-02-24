#include "af_respec_h"
#include "af_utility_h"

/**
* Script for Area List: cir100ar_docks
*
* Contains the following areas:
*   cir100ar_docks - (Lake Calenhad Docks)
*
*/
void main() {

    /* cir100ar (Lake Calenhad Docks) - Run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_CIR100AR)) {

        // Respec Raven - On the wooden poles near the fire
        location lSpawn = Location(GetArea(GetMainControlled()), Vector(128.41, 191.2, 1.0), 180.0);
        object oRaven    = CreateObject(OBJECT_TYPE_CREATURE, AF_CRR_RESPEC_RAVEN, lSpawn);
        SetPosition(oRaven, Vector(128.55, 190.6, 1.52), FALSE);

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_CIR100AR);
    }
}