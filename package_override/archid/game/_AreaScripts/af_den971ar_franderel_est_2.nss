#include "af_utility_h"

/**
* Script for Area List: den971ar_franderel_estate_2
*
* Contains the following areas:
*   den971ar_franderel_estate_2  (South Wing of Bann Franderel's Estate)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "den971ar_franderel_estate_2") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN971AR)) {

            // Add Feastday King Marics Shield
            object oContainer = GetObjectByTag("genip_chest_iron");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"val_im_gift_shield.uti", oContainer, 1, "", TRUE);
            }

            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN971AR);
        }
    }
}