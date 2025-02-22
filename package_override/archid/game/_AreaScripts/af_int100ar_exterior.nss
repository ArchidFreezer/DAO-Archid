#include "wrappers_h"
#include "utility_h"
#include "af_log_h"
#include "af_utility_h"

/**
* Awakening starting location
*/
void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_GIB000AR)) {
        object oContainer;

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_GIB000AR);
    }

    /* Run the Awakening initialisation code
    *  This should only be run once, but may be run from one of several scripts so it
    *   has it's own varaible */
    if (!AF_IsModuleFlagSet(AF_GENERAL_FLAG, AF_GENERAL_AWAKENING_INIT)) {
        object oHero = GetHero();
        object oItem;
        int nItemUpdated = FALSE;

        // Battledress of the Provocateur import
        oItem = GetItemPossessedBy(oHero, "prc_dao_lel_im_arm_cht_01");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Battledress found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prc_daep1_lel_im_arm_cht_01.uti", 1);
            nItemUpdated = TRUE;
        }

        // Brightblood import
        oItem = GetItemPossessedBy(oHero, "prc_im_wep_mel_lsw_drk_dao");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Brightblood found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prc_im_wep_mel_lsw_drk_ep1.uti", 1);
            nItemUpdated = TRUE;
        }

        // Bregan's Bow
        oItem = GetItemPossessedBy(oHero, "prm000im_griffbeak");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Bregan's Bow found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prm000im_ep1_griffbeak.uti", 1);
            nItemUpdated = TRUE;
        }

        // Bulwark of the True King
        oItem = GetItemPossessedBy(oHero, "prm000im_bulwarktk");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Bulwark of the True King found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prm000im_ep1_bulwarktk.uti", 1);
            nItemUpdated = TRUE;
        }

        // Reaper's Cudgel
        oItem = GetItemPossessedBy(oHero, "prc_im_gib_wep_mac_dao");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Reaper's Cudgel found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prc_im_gib_wep_mac_ep1.uti", 1);
            nItemUpdated = TRUE;
        }

        // High Regard
        oItem = GetItemPossessedBy(oHero, "prc_im_gib_acc_amu_dao");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("High Regard found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prc_im_gib_acc_amu_ep1.uti", 1);
            nItemUpdated = TRUE;
        }

        // Forbidden Secrets
        oItem = GetItemPossessedBy(oHero, "prc_im_gib_acc_blt_dao");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Forbidden Secrets found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prc_im_gib_acc_blt_ep1.uti", 1);
            nItemUpdated = TRUE;
        }

        // Pearl of the Anointed
        oItem = GetItemPossessedBy(oHero, "prm000im_pearlan");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Pearl of the Anointed found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prm000im_ep1_pearlan.uti", 1);
            nItemUpdated = TRUE;
        }

         // Dragonbone Cleaver import
        oItem = GetItemPossessedBy(oHero, "prc_im_reward1");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Dragonbone Cleaver found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prc_im_ep1_reward1.uti", 1);
            nItemUpdated = TRUE;
        }

        // Sorrows of Arlathan import
        oItem = GetItemPossessedBy(oHero, "prc_im_reward2");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Sorrows Arlathan found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prc_im_ep1_reward2.uti", 1);
            nItemUpdated = TRUE;
        }

        // Vestments of the Seer import
        oItem = GetItemPossessedBy(oHero, "prc_im_reward3");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Vestments of the Seer found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prc_im_ep1_reward3.uti", 1);
            nItemUpdated = TRUE;
        }

        // Cinch of Skillful Manoeuvering import
        oItem = GetItemPossessedBy(oHero, "prc_im_reward4");
        if (IsObjectValid(oItem)) {
            AF_LogDebug("Cinch of Skillful Manoeuvering found - giving Awakening version to hero", AF_LOGGROUP_DLCINT);
            WR_DestroyObject(oItem);
            UT_AddItemToInventory(R"prc_im_ep1_reward4.uti", 1);
            nItemUpdated = TRUE;
        }

        if (nItemUpdated) DisplayFloatyMessage(oHero, "DAO DLC Items imported to Awakening, check equipped", FLOATY_MESSAGE, AF_COLOUR_RED, 5.0f);

        // Set the correct number of specialisation points when importing into Awakening
        AF_AwakeningSpecFix();

        // Gain starting Runecrafting recipes in Awakening
        if(IsUsingEP1Resources()) {
            UT_AddItemToInventory(R"gxa_im_cft_run_102.uti", 1, OBJECT_INVALID, "", TRUE);
            UT_AddItemToInventory(R"gxa_im_cft_run_103.uti", 1, OBJECT_INVALID, "", TRUE);
            UT_AddItemToInventory(R"gxa_im_cft_run_111.uti", 1, OBJECT_INVALID, "", TRUE);
        }
                
        AF_SetModuleFlag(AF_GENERAL_FLAG, AF_GENERAL_AWAKENING_INIT);
    }
}