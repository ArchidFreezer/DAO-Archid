#include "af_respec_h"
#include "af_utility_h"

void main() {

    /* cam104ar_camp_arch1 - Run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_CAM104AR)) {

        // Respec Raven - Next to the fallen tree on top of a rock
        location lSpawn = Location(GetArea(GetMainControlled()), Vector(115.77, 115.68, -0.94), -85.0);
        object oRaven    = CreateObject(OBJECT_TYPE_CREATURE, AF_CRR_RESPEC_RAVEN, lSpawn);

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_CAM104AR);
    }
}