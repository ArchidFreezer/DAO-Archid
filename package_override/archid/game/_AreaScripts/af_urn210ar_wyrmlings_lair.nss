#include "af_utility_h"

/**
* Script for Area List: urn210ar_wyrmlings_lair
*
* Contains the following areas:
*   urn210ar_wyrmlings_lair (Caverns)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "urn210ar_wyrmlings_lair") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA3_FLAG, AF_DAOAREA3_URN210AR)) {

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(23.3287,375.325,9.25462), 90.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(-200.618,313.43,22.8219), 0.0));

            // Add Garahels Vigil longsword on drake in the egg chamber
            object oDrake = GetObjectByTag("drake");
            if (IsObjectValid(oDrake)) {
                CreateItemOnObject(R"af_lsword_gar_fury.uti", oDrake, 1, "", TRUE, TRUE);
                CreateItemOnObject(R"af_lsword_gar_vigil.uti", oDrake, 1, "", TRUE, TRUE);
            }

            AF_SetModuleFlag(AF_DAOAREA3_FLAG, AF_DAOAREA3_URN210AR);
        }
    }
}