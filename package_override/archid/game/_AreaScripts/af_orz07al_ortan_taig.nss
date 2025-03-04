#include "af_utility_h"

/**
* Script for Area List: orz07al_ortan_taig
*
* Contains the following areas:
*   orz530ar_ortan_thaig  (Ortan Thaig)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "orz530ar_ortan_thaig") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_ORZ530AR)) {

            // Add Feastday Butterfly Sword
            object oContainer = GetObjectByTag("orz530ip_cocoon");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"val_im_gift_skull.uti", oContainer, 1, "", TRUE);
            }

            // Add Feastday Rotten Onion
            oContainer = GetObjectByTag("store_orz530cr_ruck");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"val_im_gift_onion.uti", oContainer, 1, "", TRUE);
            }

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(-155.128,-318.828,-0.168755), 0.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(-19.3497,-198.602,0.566611), -90.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush3.utp", Location(oArea, Vector(-90.3574,-168.007,0.7823), 90.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush3.utp", Location(oArea, Vector(69.4126,-70.7185,-18.9564), 0.0));

            AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_ORZ530AR);
        }
    }
}