#include "af_utility_h"

/**
* Script for Area List: ltl300ar_kal_hirol_upper
*
* Contains the following areas:
*   ltl300ar_kal_hirol_upper ()
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "ltl300ar_kal_hirol_upper") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_LTL300AR)) {

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(223.54, 48.89, -15.84), 0.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(241.61, -53.77, -12.06), -90.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(183.58, -106.86, -10.58), 180.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush3.utp", Location(oArea, Vector(21.43, 40.41, 6.96), 90.0));

            AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_LTL300AR);
        }
    }
}