#include "af_utility_h"

/**
* Script for Area List: orz540ar_anvil_of_the_void
*
* Contains the following areas:
*   orz540ar_anvil_of_the_void (Anvil of the Void)
*
*/
void main() {

    object oArea = GetArea(OBJECT_SELF);

    /* orz540ar (Anvil of the Void) - Run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA3_FLAG, AF_DAOAREA3_ORZ540AR)) {

        // Deep Mushrooms
        CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(106.874,-8.56824,-15.4695), 0.0));
        CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(191.472,-55.7364,-15.9701), 0.0));
        CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(270.784,100.157,-15.1926), 90.0));

        AF_SetModuleFlag(AF_DAOAREA3_FLAG, AF_DAOAREA3_ORZ540AR);
    }
}