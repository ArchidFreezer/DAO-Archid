#include "af_respec_h"
#include "af_utility_h"

void main() {

    /* cam100ar_camp_plains - Run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_CAM100AR)) {

        // Add Feastday Lump of Charcoal
        object oArea = GetObjectByTag("cam100ar_camp_plains");
        vector vLocation = Vector(138.489f,121.367f,-0.294134f);
        object oContainer = CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_invis_campfire.utp", Location(oArea, vLocation, 0.0f));
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_coal.uti", oContainer, 1, "", TRUE);
        }

        // Respec Raven - Next to the fallen tree on top of a rock
        location lSpawn = Location(oArea, Vector(115.77, 115.68, -0.94), -85.0);
        object oRaven    = CreateObject(OBJECT_TYPE_CREATURE, AF_CRR_RESPEC_RAVEN, lSpawn);

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_CAM100AR);
    }
}