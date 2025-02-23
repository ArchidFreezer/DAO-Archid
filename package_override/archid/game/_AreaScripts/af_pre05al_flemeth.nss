#include "af_respec_h"
#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_PRE05AL)) {

        // Respec Raven - Outside of Flemeth's hut, next to the old statue
        location lSpawn = Location(GetArea(GetMainControlled()), Vector(309.39, 254.3, 0.72), -94.1);
        object oRaven    = CreateObject(OBJECT_TYPE_CREATURE, AF_CRR_RESPEC_RAVEN, lSpawn);
        SetPosition(oRaven, Vector(308.79, 254.4, 2.72), FALSE);

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_PRE05AL);
    }
}