#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_ARL01AL)) {
        object oContainer;
        
        // Add Feastday Scented Soap
        oContainer = GetObjectByTag("arl170ip_dwarven_chest");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_soap.uti", oContainer, 1, "", TRUE);
        }
        
        // Owens upgraded store sells Farsong
        oContainer = GetObjectByTag("store_arl120cr_owen_extra");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"gen_im_wep_rng_lbw_fsn.uti", oContainer, 1, "", TRUE);
        }
        
        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_ARL01AL);
    }
}