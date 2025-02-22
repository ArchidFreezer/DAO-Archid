#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_KCC01AL)) {
        object oContainer;     
        
        // Add DLC item Blightblood
        oContainer = GetObjectByTag("kcc100cr_commander_d");
        if (IsObjectValid(oContainer)) {
            object oItem = CreateItemOnObject(R"prc_im_wep_mel_lsw_drk_dao.uti", oContainer, 1, "", TRUE);
            EquipItem(oContainer, oItem, INVENTORY_SLOT_MAIN, 0);
        }  
        
        // Add DLC item Memory Band
        oContainer = GetObjectByTag("kcc100ip_wizards_chest");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"gen_im_acc_rng_exp.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_KCC01AL);
    }
}