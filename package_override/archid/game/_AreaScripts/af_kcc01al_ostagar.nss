#include "af_utility_h"

void main() {

    // Add DLC item Blightblood
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_BLIGHTBLOOD)) {
        object oContainer = GetObjectByTag("kcc100cr_commander_d");
        if (IsObjectValid(oContainer)) {
            object oItem = CreateItemOnObject(R"prc_im_wep_mel_lsw_drk_dao.uti", oContainer, 1, "", TRUE);
            EquipItem(oContainer, oItem, INVENTORY_SLOT_MAIN, 0);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_BLIGHTBLOOD);
        }
    }

    // Add DLC item Memory Band
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG2, AF_DLC2_MEMORY_BAND_RETURN)) {
        object oContainer = GetObjectByTag("kcc100ip_wizards_chest");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"gen_im_acc_rng_exp.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG2, AF_DLC2_MEMORY_BAND_RETURN);
        }
    }
}