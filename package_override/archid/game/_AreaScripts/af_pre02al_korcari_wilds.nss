#include "af_utility_h"

void main() {

    // Add DLC item Feral Wolf Charm
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_FERAL_WOLF_CHARM)) {
        object oContainer = GetObjectByTag("pre200ip_iron_chest2");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_wolf_charm.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_FERAL_WOLF_CHARM);
        }
    }

    // Add DLC item Lion's Paw
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_LIONS_PAW)) {
        object oContainer = GetObjectByTag("litip_kor_trail_cache");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_lionspaw.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_LIONS_PAW);
        }
    }

    // Add DLC item Lucky Stone
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_LUCKY_STONE)) {
        object oContainer = GetObjectByTag("pre211ip_chest_iron");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_luckystone.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_LUCKY_STONE);
        }
    }

    // Add Feastday Alistair Doll
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_ALISTAIR_DOLL)) {
        object oContainer = GetObjectByTag("pre211ip_chest_iron");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_doll.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_ALISTAIR_DOLL);
        }
    }
}