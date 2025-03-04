#include "af_utility_h"

/**
* Script for Area List: bed110ar_elven_ruins
*
* Contains the following areas:
*   bed110ar_elven_ruins (Elven Ruins)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "bed110ar_elven_ruins") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA3_FLAG, AF_DAOAREA3_BED110AR)) {

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(-30.5361,-50.2337,-0.000340901), 0.0));

            AF_SetModuleFlag(AF_DAOAREA3_FLAG, AF_DAOAREA3_BED110AR);
        }
    }
}