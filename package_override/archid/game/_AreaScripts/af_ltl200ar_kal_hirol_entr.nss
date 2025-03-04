#include "af_utility_h"

/**
* Script for Area List: ltl200ar_kal_hirol_entrance
*
* Contains the following areas:
*   ltl200ar_kal_hirol_entrance ()
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "ltl200ar_kal_hirol_entrance") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_LTL200AR)) {

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(54.98, 48.78, -8.63), 0.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(185.72, 38.25, -7.5), -90.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(109.86, 81.13, -8.94), 90.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush3.utp", Location(oArea, Vector(129.02, 142.01, 1.27), 0.0));

            AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_LTL200AR);
        }
    }
}