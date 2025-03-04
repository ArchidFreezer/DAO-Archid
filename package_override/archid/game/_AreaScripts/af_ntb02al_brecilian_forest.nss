#include "af_utility_h"

/**
* Script for Area List: ntb02al_brecilian_forest
*
* Contains the following areas:
*   brecilian_forestnw_cutscene   (West Brecilian Forest)
*   ntb200ar_brecilian_forestnw   (West Brecilian Forest)
*   ntb210ar_brecilian_forestne   (East Brecilian Forest)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "ntb200ar_brecilian_forestnw") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB200AR)) {

            // Add Feastday Stick
            object oContainer = GetObjectByTag("ntb200ip_ironbark");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"val_im_gift_ball.uti", oContainer, 1, "", TRUE);
            }

            // Add Uncrushable Pigeon
            oContainer = GetObjectByTag("bear_great", 0);
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"val_im_gift_pigeon.uti", oContainer, 1, "", TRUE);
            }

            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB200AR);
        }
    }
}