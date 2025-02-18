#include "wrappers_h"
#include "af_utility_h"

void main() {

     // Add Feastday Beard Flask
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_BEARD_FLASK)) {
        object oContainer = GetObjectByTag("genip_barrel_standard", 2);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_flask.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_BEARD_FLASK);
        }
    }

    // No Outsiders in Orzammar
    if (!AF_IsModuleFlagSet(AF_GENERAL_FLAG, AF_GENERAL_ORZOUTS_230)) {
        
        // Equip all creatures who used to be non-dwarves with berserker gear
        object oArea = GetObjectByTag("orz230ar_gangsters_hideout");
        object[] oQunari = GetObjectsInArea(oArea, "orz230cr_qunari");
        object[] oElves = GetObjectsInArea(oArea, "orz230cr_elf");

        int i;
        for (i = 0; i < GetArraySize(oQunari); i++) {
            LoadItemsFromTemplate(oQunari[i], "orz260cr_prov_fight_3");
        }

        for (i = 0; i < GetArraySize(oElves); i++) {
            LoadItemsFromTemplate(oElves[i], "orz260cr_prov_fight_3");
        }
        AF_SetModuleFlag(AF_GENERAL_FLAG, AF_GENERAL_ORZOUTS_230);
    }

}