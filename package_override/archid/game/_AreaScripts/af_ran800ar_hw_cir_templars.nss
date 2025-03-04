#include "af_utility_h"

/**
* Script for Area List: ran800ar_hw_cir_templars
*
* Contains the following areas:
*   ran800ar_hw_cir_templars   (Narrow Road)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "ran800ar_hw_cir_templars") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_RAN800AR)) {

            // Swap out templars - Templar Variety mod
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

            AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_RAN800AR);
        }
    }
}