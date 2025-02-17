#include "af_utility_h"

void main()
{
    // Swap out templars - Templar Variety mod
    if (!AF_IsModuleFlagSet(AF_GENERAL_FLAG, AF_GENERAL_TPSWAP_RAN800)) {
        object oTemplar = GetObjectByTag("ran800cr_templar", 1);
        if (!IsDead(oTemplar)) {
            object oNewTemp = CreateObject(OBJECT_TYPE_CREATURE, R"templar_f_med_low.utc", GetLocation(oTemplar)); //
            SetTeamId(oNewTemp, 5);
            if (IsObjectValid(oNewTemp)) {
                Safe_Destroy_Object(oTemplar);
            }
        }

        oTemplar = GetObjectByTag("ran800cr_templar", 3);
        if (!IsDead(oTemplar)) {
            object oNewTemp = CreateObject(OBJECT_TYPE_CREATURE, R"templar_f_arch_low.utc", GetLocation(oTemplar)); //
            SetTeamId(oNewTemp, 5);
            if (IsObjectValid(oNewTemp)) {
                Safe_Destroy_Object(oTemplar);
            }
        }

        oTemplar = GetObjectByTag("ran800cr_templar", 7);
        if (!IsDead(oTemplar)) {
            object oNewTemp = CreateObject(OBJECT_TYPE_CREATURE, R"templar_m_med_low.utc", GetLocation(oTemplar)); //
            SetTeamId(oNewTemp, 5);
            if (IsObjectValid(oNewTemp)) {
                Safe_Destroy_Object(oTemplar);
            }
        }

        oTemplar = GetObjectByTag("ran800cr_templar", 8);
        if (!IsDead(oTemplar)) {
            object oNewTemp = CreateObject(OBJECT_TYPE_CREATURE, R"templar_f_heavy_low.utc", GetLocation(oTemplar)); //
            SetTeamId(oNewTemp, 5);
            if (IsObjectValid(oNewTemp)) {
                Safe_Destroy_Object(oTemplar);
            }
        }

        AF_SetModuleFlag(AF_GENERAL_FLAG, AF_GENERAL_TPSWAP_RAN800);
    }
}