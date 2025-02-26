#include "af_utility_h"

/**
* Script for Area List: bdc120ar_berahts_hideout
*
* Contains the following areas:
*   bdc120ar_berahts_hideout (Beraht's Hideout)
*
*/
void main() {

    object oArea = GetArea(OBJECT_SELF);

    /* bdc120ar (Beraht's Hideout) - Run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA3_FLAG, AF_DAOAREA3_BDC120AR)) {

        // Deep Mushrooms
        CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(143.943,-208.502,-7.92654), 0.0));
        CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(97.0657,-123.909,-0.311534), 90.0));

        AF_SetModuleFlag(AF_DAOAREA3_FLAG, AF_DAOAREA3_BDC120AR);
    }
}