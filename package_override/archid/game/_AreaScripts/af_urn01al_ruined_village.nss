#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_URN01AL)) {
        object oContainer;

        // Add DLC item Pearl of the Anointed
        oContainer = GetObjectByTag("urn110ip_chest");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_pearlan.uti", oContainer, 1, "", TRUE);
        }                                                                                  
        
        // The Unobtainables
        oContainer = GetObjectByTag("store_urn130cr_shopkeeper");
        if (IsObjectValid(oContainer))
        {
            CreateItemOnObject(R"gen_im_cft_hrb_406.uti", oContainer, 1, "", TRUE);
            CreateItemOnObject(R"gen_im_qck_book_attribute2.uti", oContainer, 1, "", TRUE);
        }                   
        
        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_URN01AL);
    }
}