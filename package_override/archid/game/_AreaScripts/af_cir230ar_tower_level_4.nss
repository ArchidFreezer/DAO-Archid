#include "af_utility_h"

/**
* Script for Area List: cir230ar_tower_level_4
*
* Contains the following areas:
*   cir230ar_tower_level_4  (Templar Quarters)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "cir230ar_tower_level_4") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_CIR230AR)) {

            // Add DLC item Blood Dragon Plate Gauntlets
            object oContainer = GetObjectByTag("genip_chest_iron", 0);
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"prm000im_dragon_blood_glove.uti", oContainer, 1, "", TRUE);
            }

            // Add DLC item Mark of Vigilance
            oContainer = GetObjectByTag("genip_chest_ornate", 1);
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"prm000im_vigilance.uti", oContainer, 1, "", TRUE);
            }

            // Swap out templars - Templar Variety mod
            object oTemplar = GetObjectByTag("cir220cr_possessedtemplar", 1);
            if (!IsDead(oTemplar)) {
                object oNewTemp = CreateObject(OBJECT_TYPE_CREATURE, R"templar_m_arch_hos.utc", GetLocation(oTemplar));
                SetTeamId(oNewTemp, 126);
                SetName(oNewTemp, GetName(oTemplar));
                if (IsObjectValid(oNewTemp)) {
                    Safe_Destroy_Object(oTemplar);
                }
            }

            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_CIR230AR);
        }
    }
}