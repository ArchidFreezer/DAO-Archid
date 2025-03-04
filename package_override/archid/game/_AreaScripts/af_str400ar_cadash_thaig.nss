#include "af_utility_h"

/**
* Script for Area List: str400ar_cadash_thaig
*
* Contains the following areas:
*   str400ar_cadash_thaig ()
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "arl100ar_redcliffe_village") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA3_FLAG, AF_DAOAREA3_STR400AR)) {

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush3.utp", Location(oArea, Vector(82.94, 61.85, 0.41), 0.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush3.utp", Location(oArea, Vector(163.67, 74.68, 1.26), 0.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush4.utp", Location(oArea, Vector(156.25, 89.52, 0.72), -90.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush5.utp", Location(oArea, Vector(242.45, 78.97, 1.75), 90.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush3.utp", Location(oArea, Vector(111.91, 59.78, 0.86), 90.0));

            AF_SetModuleFlag(AF_DAOAREA3_FLAG, AF_DAOAREA3_STR400AR);
        }
    }
}