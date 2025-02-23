#include "af_respec_h"
#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_ARL101AR)) {

        // Respec Raven
        location lSpawn = Location(GetArea(GetMainControlled()), Vector(264.82, 311.54, 1.59), 70.0);
        object oRaven    = CreateObject(OBJECT_TYPE_CREATURE, AF_CRR_RESPEC_RAVEN, lSpawn);
        SetPosition(oRaven, Vector(265.3, 311.74, 3.59), FALSE);

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_ARL101AR);
    }
}