#include "af_utility_h"

void main() {
    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_RAN154AR)) {
        object oContainer;
        
        // Swap out templars - Templar Variety mod
        object oTemplar = GetObjectByTag("ran154cr_templar_a", 1);
        if (!IsDead(oTemplar)) {
            object oNewTemp = CreateObject(OBJECT_TYPE_CREATURE, R"templar_f_heavy.utc", GetLocation(oTemplar)); //
            if (IsObjectValid(oNewTemp)) {
                Safe_Destroy_Object(oTemplar);
            }
        }

        oTemplar = GetObjectByTag("ran154cr_templar_a", 2);
        if (!IsDead(oTemplar)) {
            object oNewTemp = CreateObject(OBJECT_TYPE_CREATURE, R"templar_m_arch.utc", GetLocation(oTemplar)); //
            if (IsObjectValid(oNewTemp)) {
                Safe_Destroy_Object(oTemplar);
            }
        }

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_RAN154AR);
    }
}
