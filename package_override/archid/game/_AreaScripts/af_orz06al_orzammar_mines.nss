#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_ORZ06AL)) {
        object oContainer;  
        
        // Add DLC item Reaper's Cudgel
        oContainer = GetObjectByTag("orz510ip_drifters_cache", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prc_im_gib_wep_mac_dao.uti", oContainer, 1, "", TRUE);
        }
        
        // No Outsiders in Orzammar
        // Equip ambusher who used to be non-dwarf with berserker gear
        object oTarget = GetObjectByTag("orz510cr_ambusher_1");
        if (IsObjectValid(oTarget)) LoadItemsFromTemplate(oTarget, "orz510cr_ambusher");

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_ORZ06AL);
    }
}