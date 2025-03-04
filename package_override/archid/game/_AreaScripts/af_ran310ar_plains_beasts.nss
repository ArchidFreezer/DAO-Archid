#include "af_utility_h"

/**
* Script for Area List: ran310ar_plains_beasts
*
* Contains the following areas:
*   ran310ar_plains_beasts (The Low Road)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "ran310ar_plains_beasts") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA3_FLAG, AF_DAOAREA3_RAN310AR)) {

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(351.73,145.293,17.7352), 0.0));

            AF_SetModuleFlag(AF_DAOAREA3_FLAG, AF_DAOAREA3_RAN310AR);
        }
    }
}