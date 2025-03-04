#include "af_utility_h"

/**
* Script for Area List: ran530ar_hw_army_werewolves
*
* Contains the following areas:
*   ran530ar_hw_army_werewolves (Wooded Highway)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "ran530ar_hw_army_werewolves") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA3_FLAG, AF_DAOAREA3_RAN530AR)) {

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(351.523,145.262,17.7208), 0.0));

            AF_SetModuleFlag(AF_DAOAREA3_FLAG, AF_DAOAREA3_RAN530AR);
        }
    }
}