#include "af_utility_h"

/**
* Script for Area List: cir200ar_tower_level_1
*
* Contains the following areas:
*   cir200ar_tower_level_1 - (Apprentice Quarters)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "cir200ar_tower_level_1") {
        // Only run this block of code once
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_CIR200AR)) {

            // Add DLC item Vestments of the Seer
            object oContainer = GetObjectByTag("cir200cr_lt_rea_demon");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"prc_im_reward3.uti", oContainer, 1, "", TRUE);
            }

            // Add Feastday Amulet of Memories
            oContainer = GetObjectByTag("cir200cr_lt_rea_demon");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"val_im_gift_amulet.uti", oContainer, 1, "", TRUE);
            }

            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_CIR200AR);
        }
        
        // Storeman
        object oStore = GetObjectByTag("store_cir200cr_shopman");
        if (IsObjectValid(oStore)) {
            // Always have seom phoenixheart arrows around
            int iMax = AF_GetOptionValue(AF_OPT_MAX_PHOENIX_ARROWS);
            AF_StockMerchant(oStore, R"af_ammo_pnxdisrupt.uti", iMax);
            AF_StockMerchant(oStore, R"af_ammo_pnxflash.uti", iMax);
            AF_StockMerchant(oStore, R"af_ammo_pnxthunder.uti", iMax);
        }            
    }
}