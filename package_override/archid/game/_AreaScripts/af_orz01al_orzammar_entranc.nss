#include "af_respec_h"
#include "af_utility_h"

/**
* Script for Area List: orz01al_orzammar_entrance
*
* Contains the following areas:
*   orz100ar_mountain_pass
*   orz110ar_hall_of_heroes
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "orz100ar_mountain_pass") {   
        /* orz100ar (Frostback Mountain Pass) - run once */
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_ORZ100AR)) {

            // Add Feastday Qunari Prayers for the Dead
            object oContainer = GetObjectByTag("store_orz100cr_faryn");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"val_im_gift_cookie.uti", oContainer, 1, "", TRUE);
            }

            // Respec Raven - Near the white striped tent
            location lSpawn = Location(oArea, Vector(128.41, 191.2, 1.0), 180.0);
            object oRaven    = CreateObject(OBJECT_TYPE_CREATURE, AF_CRR_RESPEC_RAVEN, lSpawn);
            SetPosition(oRaven, Vector(128.55, 190.6, 1.52), FALSE);

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(204.444,294.726,6.04715), 0.0));

            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_ORZ100AR);
        }
    }
}