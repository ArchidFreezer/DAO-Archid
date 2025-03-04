#include "af_utility_h"

/**
* Script for Area List: den961ar_blood_mage
*
* Contains the following areas:
*   den961ar_blood_mage  (Deserted Building)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "den961ar_blood_mage") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN961AR)) {

            // Add DLC item Amulet of the War Mage
            object  oContainer = GetObjectByTag("den961cr_blood_mage_last");
            if (IsObjectValid(oContainer)) {
                object oItem = CreateItemOnObject(R"prm000im_warmage.uti", oContainer, 1, "", TRUE);
                EquipItem(oContainer, oItem);
            }

            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_DEN961AR);
        }
    }
}