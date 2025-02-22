#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_CIR220AR)) {
        object oContainer;
        
        // Add DLC item Embris Many Pockets
        oContainer = GetObjectByTag("cir220cr_tranquil_mon", 0);
        if (IsObjectValid(oContainer)) {
            object oItem = CreateItemOnObject(R"prm000im_embri.uti", oContainer, 1, "", TRUE);
            EquipItem(oContainer, oItem);
        }
        
        // Swap out templars - Templar Variety mod
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

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_CIR220AR);
    }

}