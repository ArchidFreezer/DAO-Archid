#include "wrappers_h"
#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_ORZ05AL)) {

        // No Outsiders in Orzammar
        // Get the load templates
        string sBerserker = "orz260cr_prov_fight_3";
        string sChampion = "orz260cr_prov_fight_2";

        object oArea = GetObjectByTag("orz260ar_proving");
        object[] oFighters = GetObjectsInArea(oArea, "orz260cr_prov_lite");
        int i;
        for (i = 0; i < GetArraySize(oFighters); i++) {
            string sResRef = GetResRef(oFighters[i]);

            // Give the merecenaries that were not dwarves different gear
            if (sResRef == "orz260cr_prov_fight_0" || sResRef == "orz260cr_prov_fight_7" || sResRef == "orz260cr_prov_fight_9") {
                LoadItemsFromTemplate(oFighters[i], sBerserker);
            } else if (sResRef == "orz260cr_prov_fight_8") {
                LoadItemsFromTemplate(oFighters[i], sChampion);
            }
        }
        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_ORZ05AL);
    }
}