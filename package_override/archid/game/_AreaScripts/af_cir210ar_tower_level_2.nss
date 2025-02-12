#include "af_utility_h"

void main() {

    // Add DLC item Final Reason
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_FINAL_REASON)) {
        object oContainer = GetObjectByTag("cir210ip_lt_belcache");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_final_reason.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_FINAL_REASON);
        }
    }

    // Add DLC item Formati Tome
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_FORMATI_TOME)) {
        object oContainer = GetObjectByTag("genip_corpse_charred", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"gen_im_qck_book_formari.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_FORMATI_TOME);
        }
    }
}