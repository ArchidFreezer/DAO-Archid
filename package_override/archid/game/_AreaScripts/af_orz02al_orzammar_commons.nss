#include "af_utility_h"

/**
* Script for Area List: orz02al_orzammar_commons
*
* Contains the following areas:
*   orz200ar_commons           (Orzammar Commons)
*   orz210ar_tapsters          (Tapster's Tavern)
*   orz220ar_shop              (Figor's Imports)
*   orz240ar_gangsters_shop    (Janar Armorer's)
*   orz250ar_chantry           (Orzammar Chantry)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "orz200ar_commons") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_ORZ200AR)) {

            // The Unobtainables
            object oContainer = GetObjectByTag("store_orz200cr_garin");
            if (IsObjectValid(oContainer))
            {
                CreateItemOnObject(R"gem_im_gift_gar.uti", oContainer, 1, "", TRUE);
                CreateItemOnObject(R"gen_im_gift_dia.uti", oContainer, 1, "", TRUE);
            }

            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_ORZ200AR);
        }
    }
}