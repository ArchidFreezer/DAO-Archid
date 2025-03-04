#include "af_utility_h"

/**
* Script for Area List: trp200ar_silverite_mine
*
* Contains the following areas:
*   trp200ar_silverite_mine ()
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "arl100ar_redcliffe_village") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA3_FLAG, AF_DAOAREA3_TRP200AR)) {

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(19.7, -193.5, 0.54), 0.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(-99.4, -57.82, -0.55), 90.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush4.utp", Location(oArea, Vector(71.31, -125.79, -0.56), 90.0));

            AF_SetModuleFlag(AF_DAOAREA3_FLAG, AF_DAOAREA3_TRP200AR);
        }
    }
}