#include "af_respec_h"
#include "af_utility_h"

/**
* Script for Area List: cam110ar_camp_arch3
*
* Contains the following areas:
*   cam110ar_camp_arch3  (Camp Arch3)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "cam110ar_camp_arch3") {
        // Only run code in this block once
        if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_CAM110AR)) {

            // Respec Raven - Next to the fallen tree on top of a rock
            location lSpawn = Location(oArea, Vector(115.77, 115.68, -0.94), -85.0);
            object oRaven    = CreateObject(OBJECT_TYPE_CREATURE, AF_CRR_RESPEC_RAVEN, lSpawn);

            // Camp Merchant Chest
            lSpawn = Location(oArea, Vector(149.692,144.812,-0.968447), 199.0);
            CreateObject(OBJECT_TYPE_PLACEABLE, AF_IPR_CAMP_MERCH_CHEST, lSpawn);

            AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_CAM110AR);
        }

        // Bodahn Store
        object oMerchant = GetObjectByTag("store_camp_bodahn");
        if (IsObjectValid(oMerchant)) {
            // Always have seom phoenixheart arrows around
            int iMax = AF_GetOptionValue(AF_OPT_MAX_PHOENIX_ARROWS);
            AF_StockMerchant(oMerchant, R"af_ammo_pnxdisrupt.uti", iMax);
            AF_StockMerchant(oMerchant, R"af_ammo_pnxflash.uti", iMax);
            AF_StockMerchant(oMerchant, R"af_ammo_pnxthunder.uti", iMax);
        }
    }
}