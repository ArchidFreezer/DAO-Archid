#include "af_respec_h"
#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN02AL)) {
        object oContainer;

        // Add DLC item Band of Fire
        oContainer = GetObjectByTag("store_den230cr_proprietor");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_band_of_fire.uti", oContainer, 1, "", TRUE);
        }

        // Add DLC item Battledress of the Provocateur
        oContainer = GetObjectByTag("den250ip_chest_iron");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prc_dao_lel_im_arm_cht_01.uti", oContainer, 1, "", TRUE);
        }

        // Add DLC item Edge
        oContainer = GetObjectByTag("den200ip_pick3_silversmith");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_edge_.uti", oContainer, 1, "", TRUE);
        }

        // Add DLC item Guildmaster's Belt
        oContainer = GetObjectByTag("genip_chest_wood_1", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_gm_belt.uti", oContainer, 1, "", TRUE);
        }

        // Add Feastday Fat Lute
        oContainer = GetObjectByTag("den250ip_chest_iron");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_lute.uti", oContainer, 1, "", TRUE);
        }

        // Add Feastday Sugar Cake
        oContainer = GetObjectByTag("store_den220cr_bartender");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_parfait.uti", oContainer, 1, "", TRUE);
        }

        // Respec Raven - On top of three barrels
        location lSpawn = Location(GetArea(GetMainControlled()), Vector(72.14, 45.76, 0.0), -147.0);
        object oRaven    = CreateObject(OBJECT_TYPE_CREATURE, AF_CRR_RESPEC_RAVEN, lSpawn);
        SetPosition(oRaven, Vector(71.6, 45.6, 0.97), FALSE);

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN02AL);
    }
}