#include "af_utility_h"

void main() {

     // Add Feastday Butterfly Sword
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_BUTTERFLY_SWORD)) {
        object oContainer = GetObjectByTag("orz530ip_cocoon");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_skull.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_BUTTERFLY_SWORD);
        }
    }

     // Add Feastday Rotten Onion
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_ROTTEN_ONION)) {
        object oContainer = GetObjectByTag("store_orz530cr_ruck");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_onion.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_ROTTEN_ONION);
        }
    }
}