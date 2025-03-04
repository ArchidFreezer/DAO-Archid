#include "af_utility_h"

/**
* Script for Area List: cir220ar_tower_level_3
*
* Contains the following areas:
*   cir220ar_tower_level_3  (Great Hall)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "cir220ar_tower_level_3") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_CIR220AR)) {

            // Add DLC item Embris Many Pockets
            object oContainer = GetObjectByTag("cir220cr_tranquil_mon", 0);
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
            
            // Wings of Velvet
            oContainer = GetObjectByTag("cir000ip_chest", 0);
            if (IsObjectValid(oContainer)) {
                if (!IsObjectValid(GetObjectByTag("af_boot_lgt_wings"))) CreateItemOnObject(R"af_boot_lgt_wings.uti", oContainer, 1, "", TRUE);
                if (!IsObjectValid(GetObjectByTag("af_glove_lgt_wings"))) CreateItemOnObject(R"af_glove_lgt_wings.uti", oContainer, 1, "", TRUE);
                if (!IsObjectValid(GetObjectByTag("af_helm_cth_wings"))) CreateItemOnObject(R"af_helm_cth_wings.uti", oContainer, 1, "", TRUE);
                if (!IsObjectValid(GetObjectByTag("af_robe_wings"))) CreateItemOnObject(R"af_robe_wings.uti", oContainer, 1, "", TRUE);
                if (!IsObjectValid(GetObjectByTag("af_staff_wings"))) CreateItemOnObject(R"af_staff_wings.uti", oContainer, 1, "", TRUE);
            }            

            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_CIR220AR);
        }
    }
}