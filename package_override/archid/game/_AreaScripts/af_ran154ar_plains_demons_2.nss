#include "af_utility_h"

void main() {
    // Swap out templars - Templar Variety mod
    if (!AF_IsModuleFlagSet(AF_GENERAL_FLAG, AF_GENERAL_TPSWAP_RAN154)) {
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

        AF_SetModuleFlag(AF_GENERAL_FLAG, AF_GENERAL_TPSWAP_RAN154);
    }
}
