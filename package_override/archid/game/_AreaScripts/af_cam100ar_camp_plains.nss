#include "af_respec_h"
#include "af_utility_h"

/**
* Script for Area List: cam100ar_camp_plains
*
* Contains the following areas:
*   cam100ar_camp_plains   (Plains camp)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);    
    object oHero = GetHero();

    if (sAreaTag == "cam100ar_camp_plains") {
        
        // Only run code in this block once
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_CAM100AR)) {

            // Add Feastday Lump of Charcoal
            vector vLocation = Vector(138.489f,121.367f,-0.294134f);
            object oContainer = CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_invis_campfire.utp", Location(oArea, vLocation, 0.0f));
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"val_im_gift_coal.uti", oContainer, 1, "", TRUE);
            }

            // Respec Raven - Next to the fallen tree on top of a rock
            location lSpawn = Location(oArea, Vector(115.77, 115.68, -0.94), -85.0);
            object oRaven    = CreateObject(OBJECT_TYPE_CREATURE, AF_CRR_RESPEC_RAVEN, lSpawn);

            // Camp Merchant Chest
            lSpawn = Location(oArea, Vector(149.692,144.812,-0.968447), 199.0);
            CreateObject(OBJECT_TYPE_PLACEABLE, AF_IPR_CAMP_MERCH_CHEST, lSpawn);

            // Leliana Stories
            if(WR_GetPlotFlag(PLT_GENPT_APP_LELIANA, APP_LELIANA_ROMANCE_ACTIVE)){
                //trigger flower Placement
                location flowerLocation = Location(oArea, Vector(142.621,153.453,0.457722), 0.0);
                object Flower = CreateObject(OBJECT_TYPE_PLACEABLE, R"af_ip_leli_flower.utp", flowerLocation);
            }
            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_CAM100AR);
        }
        
        // Bodahn Store
        object oStore = GetObjectByTag("store_camp_bodahn");
        if (IsObjectValid(oStore)) {
            // Always have seom phoenixheart arrows around
            int iMax = AF_GetOptionValue(AF_OPT_MAX_PHOENIX_ARROWS);
            AF_StockMerchant(oStore, R"af_ammo_pnxdisrupt.uti", iMax);
            AF_StockMerchant(oStore, R"af_ammo_pnxflash.uti", iMax);
            AF_StockMerchant(oStore, R"af_ammo_pnxthunder.uti", iMax);
        }            
    }
}