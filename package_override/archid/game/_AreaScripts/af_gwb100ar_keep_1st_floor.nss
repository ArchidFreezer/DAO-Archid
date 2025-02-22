#include "af_utility_h"

void main() {
    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_GWB100AR)) {
        object oContainer;      
        
        // Add DLC item Bregan's Bow
        oContainer = GetObjectByTag("genip_weapon_stand_2");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_griffbeak.uti", oContainer, 1, "", TRUE);
        }
        
        // Add DLC item Grimoire of the Frozen Wastes
        oContainer = GetObjectByTag("gwb100cr_summoner_demon");
        object oContainer2 = GetObjectByTag("gwb100cr_lt_skel_scribe");
        if (IsObjectValid(oContainer) || IsObjectValid(oContainer2)) {
            CreateItemOnObject(R"prm000im_grimoire_frozen.uti", oContainer, 1, "", TRUE);
            CreateItemOnObject(R"prm000im_grimoire_frozen.uti", oContainer2, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_GWB100AR);
    }
}