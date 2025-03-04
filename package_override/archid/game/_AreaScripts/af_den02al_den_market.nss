#include "af_respec_h"
#include "af_utility_h"

/**
* Script for Area List: den02al_den_market
*
* Contains the following areas:
*   den200ar_market             (Denerim Market District)
*   den220ar_noble_tavern       (Gnawed Noble Tavern)
*   den230ar_wonders_of_thedas  (Wonders of Thedas)
*   den240ar_goldanas_house     (Goldanna's House)
*   den250ar_leliana_plot       (Marjolaine's House)
*   den260ar_warden_cache       (Market Warehouse)
*   den270ar_genitivis_home     (Genitivi's Home)
*   den280ar_smithy             (Smithy)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "den200ar_market") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN200AR)) {

            // Add DLC item Edge
            object oContainer = GetObjectByTag("den200ip_pick3_silversmith");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"prm000im_edge_.uti", oContainer, 1, "", TRUE);
            }

            // Respec Raven - On top of three barrels
            location lSpawn = Location(oArea, Vector(72.14, 45.76, 0.0), -147.0);
            object oRaven    = CreateObject(OBJECT_TYPE_CREATURE, AF_CRR_RESPEC_RAVEN, lSpawn);
            SetPosition(oRaven, Vector(71.6, 45.6, 0.97), FALSE);

            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN200AR);
        }
    } else if (sAreaTag == "den220ar_noble_tavern") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_DEN220AR)) {

            // Add Feastday Sugar Cake
            object oContainer = GetObjectByTag("store_den220cr_bartender");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"val_im_gift_parfait.uti", oContainer, 1, "", TRUE);
            }

            AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_DEN220AR);
        }
    } else if (sAreaTag == "den230ar_wonders_of_thedas") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_DEN230AR)) {

            // Add DLC item Band of Fire
            object oContainer = GetObjectByTag("store_den230cr_proprietor");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"prm000im_band_of_fire.uti", oContainer, 1, "", TRUE);
            }

            AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_DEN230AR);
        }
    } else if (sAreaTag == "den250ar_leliana_plot") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_DEN250AR)) {

            // Add DLC item Battledress of the Provocateur
            object oContainer = GetObjectByTag("den250ip_chest_iron");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"prc_dao_lel_im_arm_cht_01.uti", oContainer, 1, "", TRUE);
            }

            // Add Feastday Fat Lute
            oContainer = GetObjectByTag("den250ip_chest_iron");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"val_im_gift_lute.uti", oContainer, 1, "", TRUE);
            }

            AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_DEN250AR);
        }
    } else if (sAreaTag == "den260ar_warden_cache") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_DEN260AR)) {

            // Add DLC item Guildmaster's Belt
            object oContainer = GetObjectByTag("genip_chest_wood_1", 0);
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"prm000im_gm_belt.uti", oContainer, 1, "", TRUE);
            }

            AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_DEN260AR);
        }
    }
}