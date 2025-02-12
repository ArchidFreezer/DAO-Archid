#include "af_utility_h"

void main() {

    // Add DLC item Cinch of Skillful Manoeuvering
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_CINCH_OF_SKILLFULL_MANOEUVERING)) {
        object oContainer = GetObjectByTag("genip_chest_iron", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prc_im_reward4.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_CINCH_OF_SKILLFULL_MANOEUVERING);
        }
    }

     // Add Feastday Pet Rock
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_PET_ROCK)) {
        object oContainer = GetObjectByTag("genip_rubble", 2);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_rock.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_PET_ROCK);
        }
    }
}