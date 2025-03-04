#include "af_utility_h"

/**
* Script for Area List: ntb340ar_lair_of_werewolves
*
* Contains the following areas:
*   ntb340ar_lair_of_werewolves   (Lair of the Werewolves)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "ntb340ar_lair_of_werewolves") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB340AR)) {

            // Add DLC item Dragonbone Cleaver
            object oContainer = GetObjectByTag("ntb340cr_lt_revenant");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"prc_im_reward1.uti", oContainer, 1, "", TRUE);
            }

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(-204.276,143.188,-3.45156), 90.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush3.utp", Location(oArea, Vector(-173.237,4.15403,-16.4824), 0.0));

            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB340AR);
        }
    }
}