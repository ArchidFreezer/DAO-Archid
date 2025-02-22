#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_ARL230AR)) {
        object oContainer;

        // Add DLC item Bulwark of the True King
        oContainer = GetObjectByTag("genip_chest_ornate", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_bulwarktk.uti", oContainer, 1, "", TRUE);
        }                         
        
        // Add Feastday Orlesian Mask
        oContainer = GetObjectByTag("genip_vanity_2", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_mask.uti", oContainer, 1, "", TRUE);
        }
        
        // Add Feastday Geneaology of Kyngs
        oContainer = GetObjectByTag("arl220ip_books_1");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_sermon.uti", oContainer, 1, "", TRUE);
        }
        
        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_ARL230AR);
    }

}