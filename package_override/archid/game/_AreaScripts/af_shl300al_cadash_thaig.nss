#include "af_utility_h"

/**
* Script for Area List: shl300al_cadash_thaig
*
* Contains the following areas:
*   shl300ar_cadash_thaig   (???)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "shl300ar_cadash_thaig") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_SHL300AR)) {

            // Add DLC item Cinch of Skillful Manoeuvering
            object oContainer = GetObjectByTag("genip_chest_iron", 0);
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"prc_im_reward4.uti", oContainer, 1, "", TRUE);
            }

            // Add Feastday Pet Rock
            oContainer = GetObjectByTag("genip_rubble", 2);
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"val_im_gift_rock.uti", oContainer, 1, "", TRUE);
            }

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(82.94, 61.85, 0.41), 0.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(163.67, 74.68, 1.26), 0.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(156.25, 89.52, 0.72), -90.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(164.13, 99.86, 0.67), 0.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(242.45, 78.97, 1.75), 90.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(111.91, 59.78, 0.86), 90.0));

            AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_SHL300AR);
        }
    }
}