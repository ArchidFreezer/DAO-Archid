#include "af_utility_h"

/**
* Script for Area List: ran290ar_forest_ntb_steal
*
* Contains the following areas:
*   ran290ar_forest_ntb_steal (Wooded Hills)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "ran290ar_forest_ntb_steal") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA3_FLAG, AF_DAOAREA3_RAN290AR)) {

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(90.277,51.6026,0.212399), 0.0));

            AF_SetModuleFlag(AF_DAOAREA3_FLAG, AF_DAOAREA3_RAN290AR);
        }
    }
}