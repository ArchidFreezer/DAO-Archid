#include "af_utility_h"

/**
* Script for Area List: cir310ar_fade_burning_tower
*
* Contains the following areas:
*   cir310ar_fade_burning_tower  (Burning Tower)
*
*/
void main()
{
    /* cir310ar (Burning Tower) - Run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_CIR310AR)) {

        // Swap out templars - Templar Variety mod
        object oTemplar = GetObjectByTag("cir310cr_burning_templar", 1);
        if (!IsDead(oTemplar)) {
            object oNewTemp = CreateObject(OBJECT_TYPE_CREATURE, R"templar_m_med_low_hos.utc", GetLocation(oTemplar), "cir310cr_burning_effect"); //
            SetName(oNewTemp, GetName(oTemplar));
            if (IsObjectValid(oNewTemp)) {
                Safe_Destroy_Object(oTemplar);
            }
        }

        oTemplar = GetObjectByTag("cir310cr_burning_templar", 2);
        if (!IsDead(oTemplar)) {
            object oNewTemp = CreateObject(OBJECT_TYPE_CREATURE, R"templar_f_heavy_low_hos.utc", GetLocation(oTemplar), "cir310cr_burning_effect"); //
            SetName(oNewTemp, GetName(oTemplar));
            if (IsObjectValid(oNewTemp)) {
                Safe_Destroy_Object(oTemplar);
            }
        }

        oTemplar = GetObjectByTag("cir310cr_burning_templar_2", 0);
        if (!IsDead(oTemplar)) {
            object oNewTemp = CreateObject(OBJECT_TYPE_CREATURE, R"templar_f_arch_low_hos.utc", GetLocation(oTemplar), "cir310cr_burning_effect"); //
            SetName(oNewTemp, GetName(oTemplar));
            if (IsObjectValid(oNewTemp)) {
                Safe_Destroy_Object(oTemplar);
            }
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_CIR310AR);
    }

}