#include "af_utility_h"

/**
* Script for Area List: kkc01al
*
* Contains the following areas:
*   kkc100ar (Ostagar)
*   kcc200ar_ishal (Tower of Ishal)
*   kcc300ar_tunnel (Tunnel)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "kkc100ar") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_KCC100AR)) {

            // Add DLC item Blightblood
            object oContainer = GetObjectByTag("kcc100cr_commander_d");
            if (IsObjectValid(oContainer)) {
                object oItem = CreateItemOnObject(R"prc_im_wep_mel_lsw_drk_dao.uti", oContainer, 1, "", TRUE);
                EquipItem(oContainer, oItem, INVENTORY_SLOT_MAIN, 0);
            }

            // Add DLC item Memory Band
            oContainer = GetObjectByTag("kcc100ip_wizards_chest");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"gen_im_acc_rng_exp.uti", oContainer, 1, "", TRUE);
            }

            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_KCC100AR);
        }
    }
    
    if (sAreaTag == "kcc300ar_tunnel") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA3_FLAG, AF_DAOAREA3_KKC300AR)) {

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush3.utp", Location(oArea, Vector(-67.73, -35.44, 0.06), 0.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(-44.23, 47.39, 0.1), 90.0));

            AF_SetModuleFlag(AF_DAOAREA3_FLAG, AF_DAOAREA3_KKC300AR);
        }
    }
}