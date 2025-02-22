#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_PRE04AL)) {
        object oContainer;
                                       
        // Add DLC item Memory Band
        oContainer = GetObjectByTag("pre100ip_wizards_chest");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"gen_im_acc_rng_exp.uti", oContainer, 1, "", TRUE);
        }
        
        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_PRE04AL);
    }
}