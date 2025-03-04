#include "af_utility_h"

/**
* Script for Area List: ran210ar_forest_spiders
*
* Contains the following areas:
*   ran210ar_forest_spiders (Dark Forest)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "ran210ar_forest_spiders") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA3_FLAG, AF_DAOAREA3_RAN210AR)) {

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(124.246,93.2881,1.65392), 0.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(129.409,139.173,3.83757), 90.0));

            AF_SetModuleFlag(AF_DAOAREA3_FLAG, AF_DAOAREA3_RAN210AR);
        }
    }
}