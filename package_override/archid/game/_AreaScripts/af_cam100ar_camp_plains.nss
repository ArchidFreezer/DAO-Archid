#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_CAM100AR)) {

        // Add Feastday Lump of Charcoal
        object oArea = GetObjectByTag("cam100ar_camp_plains");
        vector vLocation = Vector(138.489f,121.367f,-0.294134f);
        object oContainer = CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_invis_campfire.utp", Location(oArea, vLocation, 0.0f));
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_coal.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_CAM100AR);
    }
}