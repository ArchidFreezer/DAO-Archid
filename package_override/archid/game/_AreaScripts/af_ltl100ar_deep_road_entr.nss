#include "af_utility_h"

/**
* Script for Area List: ltl100ar_deep_road_entrance
*
* Contains the following areas:
*   ltl100ar_deep_road_entrance ()
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "ltl100ar_deep_road_entrance") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_LTL100AR)) {

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(52.63, 243.28, -21.57), -90.0));

            AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_LTL100AR);
        }
    }
}