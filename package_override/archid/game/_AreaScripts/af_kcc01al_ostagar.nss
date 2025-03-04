#include "af_utility_h"

/**
* Script for Area List: kkc01al
*
* Contains the following areas:
*   kkc100ar (Ostagar)
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
}