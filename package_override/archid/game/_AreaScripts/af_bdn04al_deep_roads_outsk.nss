#include "af_utility_h"

/**
* Script for Area List: bdn04al_deep_roads_outskirt
*
* Contains the following areas:
*   bdn400ar_deep_road_outskirt (Deep Roads Outskirts)
*
*/
void main() {

    object oArea = GetArea(OBJECT_SELF);

    /* bdn400ar (Deep Roads Outskirts) - Run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA3_FLAG, AF_DAOAREA3_BDN400AR)) {

        // Deep Mushrooms
        CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(35.1193,-85.3455,0.29706), 0.0));
        CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(75.7985,-23.7636,0.0431643), 180.0));

        AF_SetModuleFlag(AF_DAOAREA3_FLAG, AF_DAOAREA3_BDN400AR);
    }
}