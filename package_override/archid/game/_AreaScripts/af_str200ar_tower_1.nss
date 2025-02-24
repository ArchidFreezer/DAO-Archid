#include "utility_h"
#include "af_utility_h"

/**
* Script for Area List: str200ar_tower_1
*
* Contains the following areas:
*   str200ar_tower_1   (???)
*
*/
void main() {

    /* str200ar (???) - run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_STR200AR)) {

        // Swap out templars - Templar Variety mod
        object oTempGen = GetObjectByTag("str200cr_templar");
        location lTemp = GetLocation(oTempGen);
        object oNewTemp = CreateObject(OBJECT_TYPE_CREATURE, R"templar_m_arch_low.utc", lTemp);
        if (IsObjectValid(oNewTemp)) {
            Safe_Destroy_Object(oTempGen);
        }

        object oTempGen1 = GetObjectByTag("str200cr_templar", 1);
        location lTemp1 = GetLocation(oTempGen1);
        object oNewTemp1 = CreateObject(OBJECT_TYPE_CREATURE, R"templar_f_heavy.utc", lTemp1);
        object oHelm = GetItemInEquipSlot(INVENTORY_SLOT_HEAD, oNewTemp1);
        UnequipItem(oNewTemp1, oHelm);
        if (IsObjectValid(oNewTemp1)) {
            Safe_Destroy_Object(oTempGen1);
        }

        object oTempGen2 = GetObjectByTag("str200cr_templar", 2);
        location lTemp2 = GetLocation(oTempGen2);
        object oNewTemp2 = CreateObject(OBJECT_TYPE_CREATURE, R"templar_m_med.utc", lTemp2);
        if (IsObjectValid(oNewTemp2)) {
            Safe_Destroy_Object(oTempGen2);
        }

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_STR200AR);
    }
}


