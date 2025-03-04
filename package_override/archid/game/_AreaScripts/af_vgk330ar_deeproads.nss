#include "af_utility_h"

/**
* Script for Area List: vgk330ar_deeproads
*
* Contains the following areas:
*   vgk330ar_deeproads ()
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "vgk330ar_deeproads") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_VGK330AR)) {

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(-135.8, -11.35, 0.6), 180.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(-61.07, -37.08, -1.29), 0.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush4.utp", Location(oArea, Vector(-71.1, 11.8, -0.98), 0.0));

            AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_VGK330AR);
        }
    }
}