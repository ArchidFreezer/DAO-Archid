#include "af_utility_h"

void main() {

    // Add DLC item Embris Many Pockets
    if (!AF_IsModuleFlagSet(AF_DLCITEMS_FLAG1, AF_DLC_EMBRIS_MANY_POCKETS)) {
        object oContainer = GetObjectByTag("cir220cr_tranquil_mon", 0);
        if (IsObjectValid(oContainer)) {
            object oItem = CreateItemOnObject(R"prm000im_embri.uti", oContainer, 1, "", TRUE);
            EquipItem(oContainer, oItem);
            AF_SetModuleFlag(AF_DLCITEMS_FLAG1, AF_DLC_EMBRIS_MANY_POCKETS);
        }
    }

    // Swap out templars - Templar Variety mod
    if (!AF_IsModuleFlagSet(AF_GENERAL_FLAG, AF_GENERAL_TPSWAP_BC3)) {
        object oTemplar = GetObjectByTag("cir230cr_possessed_templar", 1);
        if (!IsDead(oTemplar)) {
            object oNewTemp = CreateObject(OBJECT_TYPE_CREATURE, R"templar_m_med_hos.utc", GetLocation(oTemplar));
            SetTeamId(oNewTemp, 16);
            SetName(oNewTemp, GetName(oTemplar));
            if (IsObjectValid(oNewTemp)) {
                Safe_Destroy_Object(oTemplar);
            }
        }

        oTemplar = GetObjectByTag("cir230cr_possessed_templar", 3);
        if (!IsDead(oTemplar)) {
            object oNewTemp= CreateObject(OBJECT_TYPE_CREATURE, R"templar_f_heavy_hos.utc", GetLocation(oTemplar));
            SetTeamId(oNewTemp, 16);
            SetName(oNewTemp, GetName(oTemplar));
            UnequipItem(oNewTemp, GetItemInEquipSlot(INVENTORY_SLOT_HEAD, oNewTemp));
            if (IsObjectValid(oNewTemp)) {
                Safe_Destroy_Object(oTemplar);
            }
        }

        oTemplar = GetObjectByTag("cir230cr_possessed_templar", 4);
        if (!IsDead(oTemplar)) {
            UnequipItem(oTemplar, GetItemInEquipSlot(INVENTORY_SLOT_HEAD, oTemplar));
        }

        AF_SetModuleFlag(AF_GENERAL_FLAG, AF_GENERAL_TPSWAP_BC3);
    }
}