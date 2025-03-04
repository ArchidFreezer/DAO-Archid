#include "af_utility_h"

/**
* Script for Area List: ntb310ar_top_level
*
* Contains the following areas:
*   ntb310ar_top_level   (Ruins Upper Level)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "ntb310ar_top_level") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB310AR)) {

            // Add DLC item Blood Dragon Plate Boots
            object oContainer = GetObjectByTag("ntb310ip_dragonhorde");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"prm000im_dragon_blood_boots.uti", oContainer, 1, "", TRUE);
            }

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(23.3287,375.325,9.25462), 0.0));

            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB310AR);
        }
    }
}