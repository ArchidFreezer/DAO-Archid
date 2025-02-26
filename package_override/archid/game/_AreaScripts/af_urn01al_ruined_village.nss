#include "af_utility_h"

/**
* Script for Area List: urn01al_ruined_village
*
* Contains the following areas:
*   urn100ar_cultists_village (The Village of Haven)
*   urn110ar_chantry          (Haven Chantry)
*   urn120ar_village_house    (Villager House)
*   urn130ar_village_shop     (Village Store)
*
*/
void main() {

    /* urn110ar (Haven Chantry) - run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_URN110AR)) {
        object oContainer;

        // Add DLC item Pearl of the Anointed
        oContainer = GetObjectByTag("urn110ip_chest");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_pearlan.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_URN110AR);
    }

    /* urn130ar (Village Store) - run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_URN130AR)) {
        object oContainer;

        // The Unobtainables
        oContainer = GetObjectByTag("store_urn130cr_shopkeeper");
        if (IsObjectValid(oContainer))
        {
            CreateItemOnObject(R"gen_im_cft_hrb_406.uti", oContainer, 1, "", TRUE);
            CreateItemOnObject(R"gen_im_qck_book_attribute2.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_URN130AR);
    }
}
