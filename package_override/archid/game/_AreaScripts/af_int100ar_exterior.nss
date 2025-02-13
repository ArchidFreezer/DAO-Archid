#include "wrappers_h"
#include "utility_h"
#include "af_log_h"
#include "af_utility_h"

/**
* Awakening starting location
*/
void main() {

    object oHero = GetHero();
    object oItem;
    int nItemUpdated = FALSE;

    // Battledress of the Provocateur import
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG2, AF_DLC2_BATTLEDRESS_IMPORT)) {
        oItem = GetItemPossessedBy(oHero, "prc_dao_lel_im_arm_cht_01");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Battledress found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prc_daep1_lel_im_arm_cht_01.uti", 1);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG2, AF_DLC2_BATTLEDRESS_IMPORT);
            nItemUpdated = TRUE;
        }
    }

    // Brightblood import
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG2, AF_DLC2_BLIGHTBLOOD_IMPORT)) {
        oItem = GetItemPossessedBy(oHero, "prc_im_wep_mel_lsw_drk_dao");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Brightblood found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prc_im_wep_mel_lsw_drk_ep1.uti", 1);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG2, AF_DLC2_BLIGHTBLOOD_IMPORT);
            nItemUpdated = TRUE;
        }
    }

    // Bregan's Bow
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG2, AF_DLC2_BREGANS_BOW_IMPORT)) {
        oItem = GetItemPossessedBy(oHero, "prm000im_griffbeak");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Bregan's Bow found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prm000im_ep1_griffbeak.uti", 1);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG2, AF_DLC2_BREGANS_BOW_IMPORT);
            nItemUpdated = TRUE;
        }
    }

    // Bulwark of the True King
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG2, AF_DLC2_BULWARK_IMPORT)) {
        oItem = GetItemPossessedBy(oHero, "prm000im_bulwarktk");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Bulwark of the True King found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prm000im_ep1_bulwarktk.uti", 1);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG2, AF_DLC2_BULWARK_IMPORT);
            nItemUpdated = TRUE;
        }
    }

    // Reaper's Cudgel
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG2, AF_DLC2_REAPERS_CUDGEL_IMPORT)) {
        oItem = GetItemPossessedBy(oHero, "prc_im_gib_wep_mac_dao");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Reaper's Cudgel found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prc_im_gib_wep_mac_ep1.uti", 1);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG2, AF_DLC2_REAPERS_CUDGEL_IMPORT);
            nItemUpdated = TRUE;
        }
    }

    // High Regard
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG2, AF_DLC2_HIGH_REGARD_IMPORT)) {
        oItem = GetItemPossessedBy(oHero, "prc_im_gib_acc_amu_dao");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("High Regard found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prc_im_gib_acc_amu_ep1.uti", 1);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG2, AF_DLC2_HIGH_REGARD_IMPORT);
            nItemUpdated = TRUE;
        }
    }

    // Forbidden Secrets
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG2, AF_DLC2_FORBIDDEN_SECRETS_IMPORT)) {
        oItem = GetItemPossessedBy(oHero, "prc_im_gib_acc_blt_dao");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Forbidden Secrets found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prc_im_gib_acc_blt_ep1.uti", 1);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG2, AF_DLC2_FORBIDDEN_SECRETS_IMPORT);
            nItemUpdated = TRUE;
        }
    }

    // Pearl of the Anointed
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG2, AF_DLC2_PEARL_IMPORT)) {
        oItem = GetItemPossessedBy(oHero, "prm000im_pearlan");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Pearl of the Anointed found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prm000im_ep1_pearlan.uti", 1);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG2, AF_DLC2_PEARL_IMPORT);
            nItemUpdated = TRUE;
        }
    }

     // Dragonbone Cleaver import
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG2, AF_DLC2_DRAGONBONE_CLEAVER_IMPORT)) {
        oItem = GetItemPossessedBy(oHero, "prc_im_reward1");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Dragonbone Cleaver found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prc_im_ep1_reward1.uti", 1);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG2, AF_DLC2_DRAGONBONE_CLEAVER_IMPORT);
            nItemUpdated = TRUE;
        }
    }

    // Sorrows of Arlathan import
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG2, AF_DLC2_SORROWS_ARLATHAN_IMPORT)) {
        oItem = GetItemPossessedBy(oHero, "prc_im_reward2");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Sorrows Arlathan found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prc_im_ep1_reward2.uti", 1);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG2, AF_DLC2_SORROWS_ARLATHAN_IMPORT);
            nItemUpdated = TRUE;
        }
    }

    // Vestments of the Seer import
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG2, AF_DLC2_VESTMENTS_IMPORT)) {
        oItem = GetItemPossessedBy(oHero, "prc_im_reward3");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Vestments of the Seer found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prc_im_ep1_reward3.uti", 1);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG2, AF_DLC2_VESTMENTS_IMPORT);
            nItemUpdated = TRUE;
        }
    }

    // Cinch of Skillful Manoeuvering import
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG2, AF_DLC2_CINCH_IMPORT)) {
        oItem = GetItemPossessedBy(oHero, "prc_im_reward4");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Cinch of Skillful Manoeuvering found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prc_im_ep1_reward4.uti", 1);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG2, AF_DLC2_CINCH_IMPORT);
            nItemUpdated = TRUE;
        }
    }

    if (nItemUpdated) DisplayFloatyMessage(oHero, "DAO DLC Items imported to Awakening, check equipped", FLOATY_MESSAGE, AF_COLOUR_RED, 5.0f);
                          
    // Set the correct number of specialisation points when importing into Awakening
    AF_AwakeningSpecFix();
}