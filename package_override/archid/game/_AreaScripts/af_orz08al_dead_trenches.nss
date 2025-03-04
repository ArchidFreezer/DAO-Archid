#include "af_utility_h"

/**
* Script for Area List: orz08al_dead_trenches
*
* Contains the following areas:
*   orz550ar_dead_trenches   (The Dead Trenches)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "orz550ar_dead_trenches") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_ORZ550AR)) {

            // Add DLC item Helm of the Deep
            object oContainer = GetObjectByTag("genip_sarcophagus_dwarven", 12);
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"prm000im_helmdeep.uti", oContainer, 1, "", TRUE);
            }

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(-55.106,-3.97282,-5.04237), 0.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(203.036,-67.5324,5.0), -90.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush3.utp", Location(oArea, Vector(255.094,-143.375,4.65319), 0.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(412.158,122.62,8.97722), 180.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush3.utp", Location(oArea, Vector(341.157,55.8712,4.80511), 90.0));

            AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_ORZ550AR);
        }
    }
}