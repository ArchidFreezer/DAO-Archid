#include "af_utility_h"

/**
* Script for Area List: str300ar_elven_ruins
*
* Contains the following areas:
*   str300ar_elven_ruins ()
*
*/
void main() {
    
    object oArea = GetArea(OBJECT_SELF);

    /* atr300ar () - Run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA3_FLAG, AF_DAOAREA3_STR300AR)) {

        // Deep Mushrooms
        CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush5.utp", Location(oArea, Vector(-30.5361,-50.2337,-0.000340901), 0.0));
        CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush4.utp", Location(oArea, Vector(-51.87, 13.62, 0.17), 180.0));

        AF_SetModuleFlag(AF_DAOAREA3_FLAG, AF_DAOAREA3_STR300AR);
    }
}