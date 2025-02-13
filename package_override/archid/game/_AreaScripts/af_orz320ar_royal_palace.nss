#include "af_utility_h"

void main() {

    // Add DLC item Blood Dragon Plate Helmet
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_BLOOD_DRAGON_PLATE_HELMET)) {
        object oContainer = GetObjectByTag("orz320cr_lt_dragon");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_dragon_blood_helm.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_BLOOD_DRAGON_PLATE_HELMET);
        }
    }

    // Add DLC item Bergen's Honour
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_BERGENS_HONOUR)) {
        object oContainer = GetObjectByTag("genip_chest_ornate");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_bergens_honor.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_BERGENS_HONOUR);
        }
    }
    // Add DLC item Sash of Forbidden Secrets
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_SASH_OF_FORBIDDEN_SECRETS)) {
        object oContainer = GetObjectByTag("orz320cr_lt_revenant");
        if (IsObjectValid(oContainer)) {
            object oItem = CreateItemOnObject(R"prc_im_gib_acc_blt_dao.uti", oContainer, 1, "", TRUE);
            EquipItem(oContainer, oItem);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_SASH_OF_FORBIDDEN_SECRETS);
        }
    }

}