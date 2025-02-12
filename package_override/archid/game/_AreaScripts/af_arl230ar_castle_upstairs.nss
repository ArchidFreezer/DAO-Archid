#include "af_utility_h"

void main() {

    // Add DLC item Blood Dragon Plate Gauntlets
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_BULWARK_OF_THE_TRUE_KING)) {
        object oContainer = GetObjectByTag("genip_chest_ornate", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_bulwarktk.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_BULWARK_OF_THE_TRUE_KING);
        }
    }

     // Add Feastday Orlesian Mask
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_ORLESIAN_MASK)) {
        object oContainer = GetObjectByTag("genip_vanity_2", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_mask.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_ORLESIAN_MASK);
        }
    }

     // Add Feastday Geneaology of Kyngs
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_GENEAOLOGY_OF_KYNGS)) {
        object oContainer = GetObjectByTag("arl220ip_books_1");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_sermon.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_GENEAOLOGY_OF_KYNGS);
        }
    }
}