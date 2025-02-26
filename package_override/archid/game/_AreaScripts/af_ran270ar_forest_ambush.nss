#include "af_utility_h"

/**
* Script for Area List: ran270ar_forest_ambush
*
* Contains the following areas:
*   ran270ar_forest_ambush (Twisted Path)
*
*/
void main() {

    object oArea = GetArea(OBJECT_SELF);

    /* ran270ar (Twisted Path) - Run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA3_FLAG, AF_DAOAREA3_RAN270AR)) {

        // Deep Mushrooms
        CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(84.8845,143.111,0.344009), -90.0));
        CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(129.264,127.751,3.56325), 0.0));

        AF_SetModuleFlag(AF_DAOAREA3_FLAG, AF_DAOAREA3_RAN270AR);
    }
}