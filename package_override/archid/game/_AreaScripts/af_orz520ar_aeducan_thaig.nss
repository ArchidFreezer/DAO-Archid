#include "af_utility_h"

/**
* Script for Area List: orz520ar_aeducan_thaig
*
* Contains the following areas:
*   orz520ar_aeducan_thaig (Aeducan Thaig)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "orz520ar_aeducan_thaig") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA3_FLAG, AF_DAOAREA3_ORZ520AR)) {

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(-360.764,8.5136,4.31807), 0.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(-304.361,-41.7938,8.33502), 0.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush3.utp", Location(oArea, Vector(-305.047,-112.409,8.17671), 180.0));

            AF_SetModuleFlag(AF_DAOAREA3_FLAG, AF_DAOAREA3_ORZ520AR);
        }
    }
}