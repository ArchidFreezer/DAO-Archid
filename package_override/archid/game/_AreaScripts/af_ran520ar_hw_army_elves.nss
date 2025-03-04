#include "af_utility_h"

/**
* Script for Area List: ran520ar_hw_army_elves
*
* Contains the following areas:
*   ran520ar_hw_army_elves (Rocky Road)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "ran520ar_hw_army_elves") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA3_FLAG, AF_DAOAREA3_RAN520AR)) {

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(351.723,145.307,17.7359), 0.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(315.518,144.35,16.0239), 180.0));

            AF_SetModuleFlag(AF_DAOAREA3_FLAG, AF_DAOAREA3_RAN520AR);
        }
    }
}