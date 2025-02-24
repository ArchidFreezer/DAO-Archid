#include "af_utility_h"

/**
* Script for Area List: orz320ar_royal_palace
*
* Contains the following areas:
*   orz320ar_royal_palace  (Orzammar Royal Palace)
*
*/
void main() {

    /* orz320ar (Orzammar Royal Palace) - run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_ORZ320AR)) {
        object oContainer;

        // Add DLC item Blood Dragon Plate Helmet
        oContainer = GetObjectByTag("orz320cr_lt_dragon");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_dragon_blood_helm.uti", oContainer, 1, "", TRUE);
        }

        // Add DLC item Bergen's Honour
        oContainer = GetObjectByTag("genip_chest_ornate");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_bergens_honor.uti", oContainer, 1, "", TRUE);
        }

        // Add DLC item Sash of Forbidden Secrets
        oContainer = GetObjectByTag("orz320cr_lt_revenant");
        if (IsObjectValid(oContainer)) {
            object oItem = CreateItemOnObject(R"prc_im_gib_acc_blt_dao.uti", oContainer, 1, "", TRUE);
            EquipItem(oContainer, oItem);
        }

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_ORZ320AR);
    }
}