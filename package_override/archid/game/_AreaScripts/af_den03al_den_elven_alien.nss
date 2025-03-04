#include "af_utility_h"

/**
* Script for Area List: den03al_den_elven_alienage
*
* Contains the following areas:
*   den300ar_elven_alienage    (Elven Alienage)
*   den310ar_cityelf_pc_house  (Home)
*   den320ar_alariths_store    (Alarith's Store)
*   den330ar_valendrians_home  (Valendrian's Home)
*   den960ar_orphanage         (Abandoned Orphanage)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "den960ar_orphanage") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN960AR)) {

            // Add Feastday Cat Lady's Hobblestick
            object oContainer = GetObjectByTag("den960cr_rabid_wardog", 0);
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"val_im_gift_stick.uti", oContainer, 1, "", TRUE);
            }

            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN960AR);
        }
    }
}