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

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "lot100ar_lothering") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_LOT100AR)) {

            // Add Feastday Ugly Boots
            object oContainer = GetObjectByTag("genip_pile_filth");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"val_im_gift_boots.uti", oContainer, 1, "", TRUE);
            }

            // Respec Raven - Near the tavern on the fence pole
            location lSpawn = Location(oArea, Vector(309.39, 254.3, 0.72), -94.1);
            object oRaven    = CreateObject(OBJECT_TYPE_CREATURE, AF_CRR_RESPEC_RAVEN, lSpawn);
            SetPosition(oRaven, Vector(308.79, 254.4, 2.72), FALSE);

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(384.065,304.404,1.02725), 0.0));   
            
            // Phoenixheart Light armour
            oContainer = CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_cocoon.utp", Location(oArea, Vector(380.692, 297.73, 0.49465), 0.0));
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"af_boot_lgt_pnx.uti", oContainer, 1, "", TRUE);
                CreateItemOnObject(R"af_chest_lgt_pnx.uti", oContainer, 1, "", TRUE);
                CreateItemOnObject(R"af_glove_lgt_pnx.uti", oContainer, 1, "", TRUE);
                CreateItemOnObject(R"af_dagg_pnxh4.uti", oContainer, 1, "", TRUE);
                CreateItemOnObject(R"af_dagg_pnxm4.uti", oContainer, 1, "", TRUE);
                CreateItemOnObject(R"af_sbow_pnx4.uti", oContainer, 1, "", TRUE);
                CreateItemOnObject(R"af_ammo_pnxthunder.uti", oContainer, 3, "", TRUE);
            }
            oContainer = GetObjectByTag("genip_crate_broken_2", 1);
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"af_lbow_pnx4.uti", oContainer, 1, "", TRUE);
                CreateItemOnObject(R"af_ammo_pnxflash.uti", oContainer, 3, "", TRUE);
            }

            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_LOT100AR);
        }
    }
}