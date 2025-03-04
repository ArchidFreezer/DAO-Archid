#include "af_respec_h"
#include "af_utility_h"

/**
* Script for Area List: pre04al_kings_camp_night
*
* Contains the following areas:
*   charge_betrayal_ostagar    (Ostagar)
*   pre100ar_kings_camp_night  (Ostagar)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "pre100ar_kings_camp_night") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_PRE100AR2)) {

            // Add DLC item Memory Band
            object oContainer = GetObjectByTag("pre100ip_wizards_chest");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"gen_im_acc_rng_exp.uti", oContainer, 1, "", TRUE);
            }

            // Respec Raven - On the floor behind the fire next to Duncan
            location lSpawn = Location(oArea, Vector(562.17, 498.52, -0.49), -92.5);
            object oTest    = CreateObject(OBJECT_TYPE_CREATURE, AF_CRR_RESPEC_RAVEN, lSpawn);

            AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_PRE100AR2);
        }
    }
}