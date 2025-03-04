#include "af_utility_h"

/**
* Script for Area List: ran250ar_forest_jowan
*
* Contains the following areas:
*   ran250ar_forest_jowan (Deep Woods)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "ran250ar_forest_jowan") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA3_FLAG, AF_DAOAREA3_RAN250AR)) {

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(129.736,52.343,-8.71824), 0.0));
            object oDeathroot = GetObjectByTag("genip_herb_04_autoloot", 0);
            SetLocation(oDeathroot, Location(oArea, Vector(110.598,68.3893,-8.88755), 0.0));

            AF_SetModuleFlag(AF_DAOAREA3_FLAG, AF_DAOAREA3_RAN250AR);
        }
    }
}