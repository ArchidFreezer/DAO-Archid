#include "af_utility_h"

void main() {

     // Add Feastday Scented Soap
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_SCENTED_SOAP)) {
        object oContainer = GetObjectByTag("arl170ip_dwarven_chest");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_soap.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_SCENTED_SOAP);
        }
    }
    
    // Owens upgraded store sells Farsong
    if (!AF_IsModuleFlagSet(AF_GENERAL_FLAG, AF_GENERAL_OWEN_FARSONG)) {
        object oContainer = GetObjectByTag("store_arl120cr_owen_extra");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"gen_im_wep_rng_lbw_fsn.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_GENERAL_FLAG, AF_GENERAL_OWEN_FARSONG);
        }
    }
}