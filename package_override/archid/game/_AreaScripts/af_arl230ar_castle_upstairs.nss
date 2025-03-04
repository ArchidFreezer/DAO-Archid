#include "af_utility_h"

/**
* Script for Area List: arl230ar_castle_upstairs
*
* Contains the following areas:
*   arl230ar_castle_upstairs  (Redcliffe Castle - Upper Floor)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "arl230ar_castle_upstairs") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_ARL230AR)) {

            // Add DLC item Bulwark of the True King
            object oContainer = GetObjectByTag("genip_chest_ornate", 0);
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
}