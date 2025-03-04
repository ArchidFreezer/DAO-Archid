#include "af_utility_h"

/**
* Script for Area List: kcc200ar_ishal
*
* Contains the following areas:
*   kcc200ar_ishal (???)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "kcc200ar_ishal") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA3_FLAG, AF_DAOAREA3_KKC200AR)) {

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush3.utp", Location(oArea, Vector(-67.73, -35.44, 0.06), 0.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(-44.23, 47.39, 0.1), 90.0));

            AF_SetModuleFlag(AF_DAOAREA3_FLAG, AF_DAOAREA3_KKC200AR);
        }
    }
}