#include "af_utility_h"

void main() {

    // Add DLC item Band of Fire
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_BAND_OF_FIRE)) {
        object oContainer = GetObjectByTag("store_den230cr_proprietor");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_band_of_fire.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_BAND_OF_FIRE);
        }
    }

    // Add DLC item Battledress of the Provocateur
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_BATTLEDRESS_OF_THE_PROVOCATEUR)) {
        object oContainer = GetObjectByTag("den250ip_chest_iron");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prc_dao_lel_im_arm_cht_01.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_BATTLEDRESS_OF_THE_PROVOCATEUR);
        }
    }

    // Add DLC item Edge
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_EDGE)) {
        object oContainer = GetObjectByTag("den200ip_pick3_silversmith");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_edge_.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_EDGE);
        }
    }

    // Add DLC item Guildmaster's Belt
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_GUILDMASTERS_BELT)) {
        object oContainer = GetObjectByTag("genip_chest_wood_1", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_gm_belt.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_GUILDMASTERS_BELT);
        }
    }

    // Add Feastday Fat Lute
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_FAT_LUTE)) {
        object oContainer = GetObjectByTag("den250ip_chest_iron");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_lute.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_FAT_LUTE);
        }
    }

    // Add Feastday Sugar Cake
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_SUGAR_CAKE)) {
        object oContainer = GetObjectByTag("store_den220cr_bartender");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_parfait.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_SUGAR_CAKE);
        }
    }
}