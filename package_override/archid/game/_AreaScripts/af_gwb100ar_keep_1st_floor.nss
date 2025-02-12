#include "af_utility_h"

void main() {

    // Add DLC item Bregan's Bow
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_BREGANS_BOW)) {
        object oContainer = GetObjectByTag("genip_weapon_stand_2");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_griffbeak.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_BREGANS_BOW);
        }
    }

    // Add DLC item Grimoire of the Frozen Wastes
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_GRIMOIRE_OF_THE_FROZEN_WASTES)) {
        object oContainer = GetObjectByTag("gwb100cr_summoner_demon");
        object oContainer2 = GetObjectByTag("gwb100cr_lt_skel_scribe");
        if (IsObjectValid(oContainer) || IsObjectValid(oContainer2)) {
            CreateItemOnObject(R"prm000im_grimoire_frozen.uti", oContainer, 1, "", TRUE);
            CreateItemOnObject(R"prm000im_grimoire_frozen.uti", oContainer2, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_GRIMOIRE_OF_THE_FROZEN_WASTES);
        }
    }
}