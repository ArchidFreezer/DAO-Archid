#include "af_utility_h"

/**
* Script for Area List: ran154ar_plains_demons_2
*
* Contains the following areas:
*   ran154ar_plains_demons_2  (Lakeside Road)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "ran154ar_plains_demons_2") {   
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
}
