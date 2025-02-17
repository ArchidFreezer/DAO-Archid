#include "af_utility_h"

void main() {

    // Add DLC item Blood Dragon Plate Gauntlets
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_BLOOD_DRAGON_PLATE_GAUNTLETS)) {
        object oContainer = GetObjectByTag("genip_chest_iron", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_dragon_blood_glove.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_BLOOD_DRAGON_PLATE_GAUNTLETS);
        }
    }

    // Add DLC item Mark of Vigilance
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_MARK_OF_VIGILANCE)) {
        object oContainer = GetObjectByTag("genip_chest_ornate", 1);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_vigilance.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_MARK_OF_VIGILANCE);
        }
    }

    // Swap out templars - Templar Variety mod
    if (!AF_IsModuleFlagSet(AF_GENERAL_FLAG, AF_GENERAL_TPSWAP_BC4)) {
        AF_SetModuleFlag(AF_GENERAL_FLAG, AF_GENERAL_TPSWAP_BC4);
              object oTemplar = GetObjectByTag("cir220cr_possessedtemplar", 1);
        if (!IsDead(oTemplar)) {
            object oNewTemp = CreateObject(OBJECT_TYPE_CREATURE, R"templar_m_arch_hos.utc", GetLocation(oTemplar));
            SetTeamId(oNewTemp, 126);
            SetName(oNewTemp, GetName(oTemplar));
            if (IsObjectValid(oNewTemp)) {
                Safe_Destroy_Object(oTemplar);
            }
        }
    }
}