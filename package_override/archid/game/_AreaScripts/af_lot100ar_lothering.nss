#include "af_respec_h"
#include "af_utility_h"

/**
* Script for Area List: lot100ar_lothering
*
* Contains the following areas:
*   lot100ar_lothering  (Lothering)
*
*/
void main() {
    
    object oArea = GetArea(OBJECT_SELF);

    /* lot100ar (Lothering) - run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_LOT100AR)) {
        object oContainer;

        // Add Feastday Ugly Boots
        oContainer = GetObjectByTag("genip_pile_filth");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_boots.uti", oContainer, 1, "", TRUE);
        }

        // Respec Raven - Near the tavern on the fence pole
        location lSpawn = Location(GetArea(GetMainControlled()), Vector(309.39, 254.3, 0.72), -94.1);
        object oRaven    = CreateObject(OBJECT_TYPE_CREATURE, AF_CRR_RESPEC_RAVEN, lSpawn);
        SetPosition(oRaven, Vector(308.79, 254.4, 2.72), FALSE);

        // Deep Mushrooms
        CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(384.065,304.404,1.02725), 0.0));

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_LOT100AR);
    }
}