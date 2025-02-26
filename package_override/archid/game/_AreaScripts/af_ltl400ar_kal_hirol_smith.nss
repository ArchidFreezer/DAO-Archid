#include "af_utility_h"

/**
* Script for Area List: ltl400ar_kal_hirol_smith
*
* Contains the following areas:
*   ltl400ar_kal_hirol_smith ()
*
*/
void main() {                                                         
    
    object oArea = GetArea(OBJECT_SELF);

    /* ltl400ar () - Run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_LTL400AR)) {

        // Deep Mushrooms
        CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(45.61, -50.1, -5.17), 180.0));
        CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(71.53, -35.48, -10.8), 90.0));
        CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(42.96, 98.58, -16.54), 0.0));
        CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush3.utp", Location(oArea, Vector(-46.78, 19.26, 0.61), 0.0));
        CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush4.utp", Location(oArea, Vector(-14.42, 74.67, 0.25), -90.0));

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_LTL400AR);
    }
}