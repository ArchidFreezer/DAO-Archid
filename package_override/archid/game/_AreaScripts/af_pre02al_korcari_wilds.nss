#include "af_utility_h"

/**
* Script for Area List: pre02al_korcari_wilds
*
* Contains the following areas:
*   game_intro_wilds           (Korcari Wilds)
*   pre200ar_korcari_wilds     (Korcari Wilds)
*   pre211ar_flemeths_hut_int  (Hut)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "pre200ar_korcari_wilds") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_PRE200AR)) {

            // Add DLC item Feral Wolf Charm
            object oContainer = GetObjectByTag("pre200ip_iron_chest2");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"prm000im_wolf_charm.uti", oContainer, 1, "", TRUE);
            }

            // Add DLC item Lion's Paw
            oContainer = GetObjectByTag("litip_kor_trail_cache");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"prm000im_lionspaw.uti", oContainer, 1, "", TRUE);
            }

            AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_PRE200AR);
        }
    }

    if (sAreaTag == "pre211ar_flemeths_hut_int") {   
        /* pre211ar (Hut) - run once */
        if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_PRE211AR)) {

            // Add DLC item Lucky Stone
            object oContainer = GetObjectByTag("pre211ip_chest_iron");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"prm000im_luckystone.uti", oContainer, 1, "", TRUE);
            }

            // Add Feastday Alistair Doll
            oContainer = GetObjectByTag("pre211ip_chest_iron");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"val_im_gift_doll.uti", oContainer, 1, "", TRUE);
            }

            AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_PRE211AR);
        }
    }
}