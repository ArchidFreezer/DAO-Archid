#include "af_respec_h"
#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_PRE04AL)) {
        object oContainer;

        // Add DLC item Memory Band
        oContainer = GetObjectByTag("pre100ip_wizards_chest");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"gen_im_acc_rng_exp.uti", oContainer, 1, "", TRUE);
        }

        // Respec Raven - On the floor behind the fire next to Duncan
        location lSpawn = Location(GetArea(GetMainControlled()), Vector(562.17, 498.52, -0.49), -92.5);
        object oTest    = CreateObject(OBJECT_TYPE_CREATURE, AF_CRR_RESPEC_RAVEN, lSpawn);

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_PRE04AL);
    }
}