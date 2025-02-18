#include "af_utility_h"

void main() {

    // Add DLC item Reaper's Cudgel
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_REAPERS_CUDGEL)) {
        object oContainer = GetObjectByTag("orz510ip_drifters_cache", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prc_im_gib_wep_mac_dao.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_REAPERS_CUDGEL);
        }
    }

    // No Outsiders in Orzammar
    if (!AF_IsModuleFlagSet(AF_GENERAL_FLAG, AF_GENERAL_ORZOUTS_06)) {
        // Equip ambusher who used to be non-dwarf with berserker gear
        object oTarget = GetObjectByTag("orz510cr_ambusher_1");
        if (IsObjectValid(oTarget)) LoadItemsFromTemplate(oTarget, "orz510cr_ambusher");
        AF_SetModuleFlag(AF_GENERAL_FLAG, AF_GENERAL_ORZOUTS_06);
    }
}