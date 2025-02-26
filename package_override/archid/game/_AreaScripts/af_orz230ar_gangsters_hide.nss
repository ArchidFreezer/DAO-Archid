#include "wrappers_h"
#include "af_utility_h"

/**
* Script for Area List: orz230ar_gangsters_hideout
*
* Contains the following areas:
*   orz230ar_gangsters_hideout  (Carta Hideout)
*
*/
void main() {
    
    object oArea = GetArea(OBJECT_SELF);

    /* orz230ar (Carta Hideout) - run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_ORZ230AR)) {
        object oContainer;

        // Add Feastday Beard Flask
        oContainer = GetObjectByTag("genip_barrel_standard", 2);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_flask.uti", oContainer, 1, "", TRUE);
        }

        // No Outsiders in Orzammar
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
        
        // Deep Mushrooms
        CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(97.3649,-233.399,-10.0739), 0.0));
        CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(100.271,-128.191,-0.0107007), 90.0));
        CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(148.796,-129.986,-1.70084), 0.0));


        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_ORZ230AR);
    }
}